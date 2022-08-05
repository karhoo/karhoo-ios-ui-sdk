//
//  KarhooCheckoutPresenter.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//
// swiftlint:disable file_length
import Foundation
import KarhooSDK
import UIKit

final class KarhooCheckoutPresenter: CheckoutPresenter {
    
    private let callback: ScreenResultCallback<TripInfo>
    private weak var view: CheckoutView?
    private let quote: Quote
    private let journeyDetails: JourneyDetails
    private var quoteValidityTimer: Timer?
    internal var passengerDetails: PassengerDetails!
    private let threeDSecureProvider: ThreeDSecureProvider?
    private let tripService: TripService
    private let userService: UserService
    private let bookingMetadata: [String: Any]?
    private let paymentNonceProvider: PaymentNonceProvider
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let analytics: Analytics
    private let appStateNotifier: AppStateNotifierProtocol
    private var trip: TripInfo?
    private var comments: String?
    private var bookingRequestInProgress: Bool = false
    private var flightDetailsScreenIsPresented: Bool = false
    private let baseFareDialogBuilder: PopupDialogScreenBuilder

    var karhooUser: Bool = false

    // MARK: - Init & Config

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        threeDSecureProvider: ThreeDSecureProvider? = nil,
        tripService: TripService = Karhoo.getTripService(),
        userService: UserService = Karhoo.getUserService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
        baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
        paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
        sdkConfiguration: KarhooUISDKConfiguration =  KarhooUISDKConfigurationProvider.configuration,
        callback: @escaping ScreenResultCallback<TripInfo>
    ) {
        self.threeDSecureProvider = threeDSecureProvider ?? sdkConfiguration.paymentManager.threeDSecureProvider 
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.paymentNonceProvider = paymentNonceProvider
        self.sdkConfiguration = sdkConfiguration
        self.appStateNotifier = appStateNotifier
        self.analytics = analytics
        self.baseFareDialogBuilder = baseFarePopupDialogBuilder
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.setQuoteValidityDeadline(quote.quoteExpirationDate)
    }

    deinit {
        quoteValidityTimer?.invalidate()
        quoteValidityTimer = nil
    }

    func load(view: CheckoutView) {
        self.view = view
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            self.karhooUser = true
        default:
            self.karhooUser = false
        }
       
        if karhooUser {
            completeLoadingViewForKarhooUser(view: view)
        }
        
        setUpBookingButtonState()
        threeDSecureProvider?.set(baseViewController: view)
        
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        let showLoyalty = isLoyaltyEnabled()
        view.set(quote: quote, showLoyalty: showLoyalty, loyaltyId: loyaltyId)
    }

    func screenWillAppear() {
        reportScreenOpened()
    }

     private func completeLoadingViewForKarhooUser(view: CheckoutView) {
         if quote.source == .market {
             view.set(price: CurrencyCodeConverter.quoteRangePrice(quote: quote))
         } else {
             view.set(price: CurrencyCodeConverter.toPriceString(quote: quote))
         }

         view.set(quoteType: quote.quoteType.description)
         view.set(baseFareExplanationHidden: quote.quoteType == .fixed)
         paymentNonceProvider.set(baseViewController: view)
         configureQuoteView()
     }
    
    private func configureQuoteView() {
         if journeyDetails.isScheduled {
             configurePrebookState()
             return
         }
         configureForAsapState()
     }

     private func configurePrebookState() {
         guard let timeZone = journeyDetails.originLocationDetails?.timezone() else {
             return
         }

         let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)

         view?.setPrebookState(timeString: prebookFormatter.display(shortStyleTime: journeyDetails.scheduledDate),
                                 dateString: prebookFormatter.display(mediumStyleDate: journeyDetails.scheduledDate))
     }

     private func configureForAsapState() {
         view?.setAsapState(qta: QtaStringFormatter().qtaString(min: quote.vehicle.qta.lowMinutes,
                                                                  max: quote.vehicle.qta.highMinutes))
     }

    private func setQuoteValidityDeadline(_ validityDate: Date?) {
        guard let validityDate = validityDate else {
            return
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: validityDate.timeIntervalSinceNow,
            repeats: false
        ) { [weak self] _ in
            self?.view?.quoteDidExpire()
            self?.quoteValidityTimer?.invalidate()
            self?.quoteValidityTimer = nil
        }

        RunLoop.main.add(timer, forMode: .common)
        quoteValidityTimer = timer
    }
    
    // MARK: - Passenger Details
    func addOrEditPassengerDetails() {
        let details = view?.getPassengerDetails()
        let detailsViewController = KarhooComponents.shared.passengerDetails(details: details, delegate: self)
        view?.showAsOverlay(item: detailsViewController, animated: true)
    }
    
    func addMoreDetails() {
        if !arePassengerDetailsValid() {
            addOrEditPassengerDetails()
        } else {
            view?.retryAddPaymentMethod(showRetryAlert: false)
        }
    }
    
    func didAddPassengerDetails() {
        updateBookButtonWithEnabledState()
    }
    
    func updateBookButtonWithEnabledState() {
        if !arePassengerDetailsValid() || getPaymentNonceAccordingToAuthState() == nil {
            view?.setMoreDetailsState()
        } else if bookingRequestInProgress {
            // nothing to do here, the view is already in `Requesting` state
        } else {
            view?.setDefaultState()
        }
    }
    
    private func arePassengerDetailsValid() -> Bool {
        guard let details = view?.getPassengerDetails(),
              details.areValid
        else {
            return false
        }
        
        return true
    }

    /// Returns true if explicite acceptance is not required OR it is required and user accepted it
    private var areTermsAndConditionsAccepted: Bool {
        if shouldRequireExplicitTermsAndConditionsAcceptance() == false {
            return true
        }
        return view?.areTermsAndConditionsAccepted ?? true
    }

    // MARK: - Book
    func bookTripPressed() {
        guard areTermsAndConditionsAccepted else {
            self.view?.showTermsConditionsRequiredError()
            return
        }
        
        view?.setRequestingState()

        if Karhoo.configuration.authenticationMethod().isGuest() {
            submitGuestBooking()
        } else {
            submitAuthenticatedBooking()
        }
    }

    private func submitAuthenticatedBooking() {
        bookingRequestInProgress = true
        
        guard let currentUser = userService.getCurrentUser(),
              let passengerDetails = view?.getPassengerDetails(),
              let currentOrg = userService.getCurrentUser()?.organisations.first?.id
        else {
            view?.setDefaultState()
            view?.showAlert(title: UITexts.Errors.somethingWentWrong,
                            message: UITexts.Errors.getUserFail,
                            error: nil)
            return
        }

        if let nonce = retrievePaymentNonce() {
            if sdkConfiguration.paymentManager.shouldGetPaymentBeforeBooking {
                self.getPaymentNonceThenBook(user: currentUser,
                                            organisationId: currentOrg,
                                            passengerDetails: passengerDetails)
            } else {
                book(paymentNonce: nonce.nonce,
                     passenger: passengerDetails,
                     flightNumber: view?.getFlightNumber())
            }
        } else {
            getPaymentNonceThenBook(user: currentUser,
                                   organisationId: currentOrg,
                                   passengerDetails: passengerDetails)
        }
        
    }
    
    private func getOrganisationId() -> String {
        if let guestId = Karhoo.configuration.authenticationMethod().guestSettings?.organisationId {
            return guestId
        } else if let userOrg = userService.getCurrentUser()?.organisations.first?.id {
            return userOrg
        }

        return ""
    }
    
    private func submitGuestBooking() {
        guard let passengerDetails = view?.getPassengerDetails()
        else {
            view?.setDefaultState()
            return
        }
        guard let nonce = getPaymentNonceAccordingToAuthState()
        else {
            view?.retryAddPaymentMethod(showRetryAlert: false)
            return
        }
        
        if sdkConfiguration.paymentManager.shouldCheckThreeDSBeforeBooking {
            guard userService.getCurrentUser() != nil
            else {
                view?.showAlert(title: UITexts.Errors.somethingWentWrong,
                                message: UITexts.Errors.getUserFail,
                                error: nil)
                view?.setDefaultState()
                return
            }
            threeDSecureNonceThenBook(nonce: nonce,
                                      passengerDetails: passengerDetails)
        } else {
            book(paymentNonce: nonce, passenger: passengerDetails, flightNumber: view?.getFlightNumber())
        }
    }
    
    private func book(paymentNonce: String, passenger: PassengerDetails, flightNumber: String?) {
        
        if isLoyaltyEnabled(),
            let view = self.view {
            
            view.getLoyaltyNonce(quoteId: quote.id) { [weak self] result in
                if let error = result.errorValue() {
                    if error.type == .failedToGenerateNonce {
                        self?.sendBookRequest(loyaltyNonce: nil, paymentNonce: paymentNonce, passenger: passenger, flightNumber: flightNumber)
                    } else {
                        self?.showLoyaltyNonceError(error: error)
                    }
                    return
                }
                
                if let loyaltyNonce = result.successValue() {
                    self?.sendBookRequest(loyaltyNonce: loyaltyNonce.nonce, paymentNonce: paymentNonce, passenger: passenger, flightNumber: flightNumber)
                }
            }
        } else {
            sendBookRequest(loyaltyNonce: nil, paymentNonce: paymentNonce, passenger: passenger, flightNumber: flightNumber)
        }
    }
    
    private func sendBookRequest(loyaltyNonce: String?, paymentNonce: String, passenger: PassengerDetails, flightNumber: String?) {
        var flight: String? = flightNumber
        if let f = flight, (f.isEmpty || f == " ") {
            flight = nil
        }
        
        var tripBooking = TripBooking(
            quoteId: quote.id,
            passengers: Passengers(
                additionalPassengers: journeyDetails.passangersCount - 1,
                passengerDetails: [passenger],
                luggage: Luggage(total: journeyDetails.luggagesCount)
            ),
            flightNumber: flight,
            paymentNonce: paymentNonce,
            loyaltyNonce: loyaltyNonce,
            comments: view?.getComments()
        )
        
        var map: [String: Any] = [:]
        if let metadata = bookingMetadata {
            map = metadata
        }
        tripBooking.meta = sdkConfiguration.paymentManager.getMetaWithUpdateTripIdIfRequired(meta: map, nonce: paymentNonce)
        reportBookingEvent(quoteId: quote.id)
        tripService.book(tripBooking: tripBooking).execute(callback: { [weak self] result in
            self?.view?.setDefaultState()

            if self?.isKarhooUser() ?? false {
                self?.handleKarhooUserBookTripResult(result)
            } else {
                self?.handleGuestAndTokenBookTripResult(result)
            }
        })
    }
    
    private func handleKarhooUserBookTripResult(_ result: Result<TripInfo>) {
        bookingRequestInProgress = false
        guard let trip = result.successValue() else {
            view?.setDefaultState()
            reportBookingFailure(message: result.errorValue()?.message ?? "", correlationId: result.correlationId())
            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                view?.retryAddPaymentMethod(showRetryAlert: true)
            } else {
                callback(ScreenResult.failed(error: result.errorValue()))
            }

            return
        }

        self.trip = trip
        reportPaymentSuccess(tripId: trip.tripId, quoteId: quote.id, correlationId: result.correlationId())
        routeToBooking(result: ScreenResult.completed(result: trip))
    }

    private func handleGuestAndTokenBookTripResult(_ result: Result<TripInfo>) {
        if let trip = result.successValue() {
            reportPaymentSuccess(tripId: trip.tripId, quoteId: quote.id, correlationId: result.correlationId())
            routeToBooking(result: .completed(result: trip))
        } else if let error = result.errorValue() {
            reportBookingFailure(message: error.message, correlationId: result.correlationId())
            view?.showAlert(title: UITexts.Generic.error, message: "\(error.localizedMessage)", error: result.errorValue())
        }
    }
    
    // MARK: - Payment
    private func getPaymentNonceThenBook(user: UserInfo,
                                         organisationId: String,
                                         passengerDetails: PassengerDetails) {
        
        paymentNonceProvider.getPaymentNonce(user: user,
                                             organisationId: organisationId,
                                             quote: quote) { [weak self] result in
            switch result {
            case .completed(let result):
                handlePaymentNonceProviderResult(result)
                
            case .cancelledByUser:
                self?.view?.setDefaultState()
            }
        }
        
        func handlePaymentNonceProviderResult(_ paymentNonceResult: PaymentNonceProviderResult) {
             switch paymentNonceResult {
             case .nonce(let nonce):
                 self.book(paymentNonce: nonce.nonce,
                      passenger: passengerDetails,
                      flightNumber: view?.getFlightNumber())
                 reportCardAuthorisationSuccess()
             case .cancelledByUser:
                 self.view?.setDefaultState()
             case .failedToAddCard(let error):
                 self.view?.setDefaultState()
                 self.view?.show(error: error)
                 if let message = error?.message {
                     self.reportCardAuthorisationFailure(message: message)
                 }
                 default:
                 self.reportCardAuthorisationFailure(message: "Unknown error")
                 self.view?.showAlert(title: UITexts.Generic.error,
                                      message: UITexts.Errors.somethingWentWrong,
                                      error: nil)
                 view?.setDefaultState()
             }
        }
    }
    
    private func getPaymentNonceAccordingToAuthState() -> String? {
        switch Karhoo.configuration.authenticationMethod() {
        case .tokenExchange(settings: _), .karhooUser: return retrievePaymentNonce()?.nonce
        default: return retrievePaymentNonce()?.nonce
        }
    }

    private func threeDSecureNonceThenBook(nonce: String, passengerDetails: PassengerDetails) {
        threeDSecureProvider?.threeDSecureCheck(
            nonce: nonce,
            currencyCode: quote.price.currencyCode,
            paymentAmout: NSDecimalNumber(value: quote.price.highPrice),
            callback: { [weak self] result in
                switch result {
                case .completed(let result): handleThreeDSecureCheck(result)
                case .cancelledByUser:
                    self?.view?.resetPaymentNonce()
                    self?.view?.setDefaultState()
                }
            }
        )
        
        func handleThreeDSecureCheck(_ result: ThreeDSecureCheckResult) {
            switch result {
            case .failedToInitialisePaymentService:
                view?.setDefaultState()
                showPSPUndefinedError()
            case .threeDSecureAuthenticationFailed:
                view?.retryAddPaymentMethod(showRetryAlert: true)
                view?.setDefaultState()
            case .success(let threeDSecureNonce):
                book(paymentNonce: threeDSecureNonce, passenger: passengerDetails, flightNumber: view?.getFlightNumber())
            }
        }
    }
    
    // MARK: - Utils
    func didPressFareExplanation() {
        guard karhooUser, bookingRequestInProgress == false else {
            return
        }
        
        let popupDialog = baseFareDialogBuilder.buildPopupDialogScreen(callback: { [weak self] _ in
            self?.view?.dismiss(animated: true, completion: nil)
        })
        
        popupDialog.modalTransitionStyle = .crossDissolve
        view?.showAsOverlay(item: popupDialog, animated: true)
    }

    func didPressCloseOnExpirationAlert() {
        PassengerInfo.shared.set(details: view?.getPassengerDetails())
        routeToPreviousScene(result: ScreenResult.cancelled(byUser: false))
    }

    func screenHasFadedOut() {
        if let trip = self.trip {
             callback(ScreenResult.completed(result: trip))
         } else {
             callback(ScreenResult.cancelled(byUser: false))
         }
    }

    private func isLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }

    func isKarhooUser() -> Bool {
        return karhooUser
    }

    func shouldRequireExplicitTermsAndConditionsAcceptance() -> Bool {
        sdkConfiguration.isExplicitTermsAndConditionsConsentRequired
    }
    

    private func routeToBooking(result: ScreenResult<TripInfo>) {
        view?.navigationController?.popToRootViewController(animated: true) { [weak self] in
            self?.callback(result)
        }
    }

    func routeToPreviousScene(result: ScreenResult<TripInfo>) {
        view?.navigationController?.popViewController(animated: true)
    }

    private func setUpBookingButtonState() {
        if TripInfoUtility.isAirportBooking(journeyDetails) {
             view?.setAddFlightDetailsState()
         } else {
            didAddPassengerDetails()
         }
    }

    private func retrievePaymentNonce() -> Nonce? {
        view?.getPaymentNonce()
    }
    
    private func showLoyaltyNonceError(error: KarhooError) {
        var message = ""
        switch error.type {
        case .loyaltyCustomerNotAllowedToBurnPoints:
            message = UITexts.Loyalty.noAllowedToBurnPoints
            
        case .unknownCurrency:
            message = UITexts.Errors.unsupportedCurrency
            
        default:
            message = UITexts.Generic.errorMessage
        }
        
        let alert = UIAlertController.create(title: UITexts.Generic.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UITexts.Generic.ok, style: .default, handler: { [weak self] _ in
            self?.view?.setDefaultState()
        }))
        view?.present(alert, animated: true, completion: nil)
    }

    private func showPSPUndefinedError() {
        // log error
        view?.showAlert(
            title: UITexts.Generic.error,
            message: UITexts.PaymentError.noDetailsMessage,
            error: nil
        )
    }
    
    // MARK: - Analytics

    private func reportScreenOpened() {
        analytics.checkoutOpened(quote)
    }

    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote.id,
            errorMessage: message,
            lastFourDigits: retrievePaymentNonce()?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice.description,
            currency: quote.price.currencyCode
        )
    }

    private func reportCardAuthorisationSuccess(){
        analytics.cardAuthorisationSuccess(quoteId: quote.id)
    }

    private func reportBookingEvent(quoteId: String) {
        analytics.bookingRequested(quoteId: quoteId)
    }

    private func reportBookingSuccess(tripId: String, quoteId: String, correlationId: String?) {
            analytics.bookingSucceed(tripId: tripId, quoteId: quoteId, correlationId: correlationId)
    }

    private func reportBookingFailure(message: String, correlationId: String?) {
        analytics.bookingFailure(
            quoteId: quote.id,
            correlationId: correlationId ?? "",
            message: message,
            lastFourDigits: retrievePaymentNonce()?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice.description,
            currency: quote.price.currencyCode
        )
    }

}

extension KarhooCheckoutPresenter: PassengerDetailsDelegate {
    func didInputPassengerDetails(result: PassengerDetailsResult) {
        view?.setPassenger(details: result.details)
        PassengerInfo.shared.set(country: result.country ?? KarhooCountryParser.defaultCountry)
    }
    
    // No action needed in this case for now
    func didCancelInput(byUser: Bool) {}
}
