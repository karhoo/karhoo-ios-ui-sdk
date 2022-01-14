//
//  KarhooCheckoutPresenter.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

final class KarhooCheckoutPresenter: CheckoutPresenter {
    
    private let callback: ScreenResultCallback<TripInfo>
    private weak var view: CheckoutView?
    private let quote: Quote
    private let bookingDetails: BookingDetails
    internal var passengerDetails: PassengerDetails!
    private let threeDSecureProvider: ThreeDSecureProvider
    private let tripService: TripService
    private let userService: UserService
    private let loyaltyService: LoyaltyService
    private let bookingMetadata: [String: Any]?
    private let paymentNonceProvider: PaymentNonceProvider
    
    private let analytics: Analytics
    private let appStateNotifier: AppStateNotifierProtocol
    private var trip: TripInfo?
    private var comments: String?
    private var bookingRequestInProgress: Bool = false
    private var flightDetailsScreenIsPresented: Bool = false
    private let baseFareDialogBuilder: PopupDialogScreenBuilder

    var karhooUser: Bool = false
    
    // MARK: - Init & Config
    init(quote: Quote,
         bookingDetails: BookingDetails,
         bookingMetadata: [String: Any]?,
         threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
         tripService: TripService = Karhoo.getTripService(),
         userService: UserService = Karhoo.getUserService(),
         loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
         analytics: Analytics = KarhooAnalytics(),
         appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
         baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
         paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
         callback: @escaping ScreenResultCallback<TripInfo>) {
        self.threeDSecureProvider = threeDSecureProvider
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.paymentNonceProvider = paymentNonceProvider
        self.appStateNotifier = appStateNotifier
        self.analytics = analytics
        self.baseFareDialogBuilder = baseFarePopupDialogBuilder
        self.quote = quote
        self.bookingDetails = bookingDetails
        self.bookingMetadata = bookingMetadata
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
        threeDSecureProvider.set(baseViewController: view)
        
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        let showLoyalty = isLoyaltyEnabled()
        view.set(quote: quote, showLoyalty: showLoyalty, loyaltyId: loyaltyId)
    }
    
    private func isLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
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
         if bookingDetails.isScheduled {
             configurePrebookState()
             return
         }
         configureForAsapState()
     }

     private func configurePrebookState() {
         guard let timeZone = bookingDetails.originLocationDetails?.timezone() else {
             return
         }

         let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)

         view?.setPrebookState(timeString: prebookFormatter.display(shortStyleTime: bookingDetails.scheduledDate),
                                 dateString: prebookFormatter.display(mediumStyleDate: bookingDetails.scheduledDate))
     }

     private func configureForAsapState() {
         view?.setAsapState(qta: QtaStringFormatter().qtaString(min: quote.vehicle.qta.lowMinutes,
                                                                  max: quote.vehicle.qta.highMinutes))
     }
    
    func isKarhooUser() -> Bool {
        return karhooUser
    }
    
    // MARK: - Passenger Details
    func addOrEditPassengerDetails() {
        let details = view?.getPassengerDetails()
        let presenter = PassengerDetailsPresenter(details: details) { [weak self] result in
            guard let completedValue = result.completedValue()
            else {
                return
            }
            
            self?.view?.setPassenger(details: completedValue.details)
            PassengerInfo.shared.set(country: completedValue.country ?? KarhooCountryParser.defaultCountry)
        }
        let detailsViewController = PassengerDetailsViewController(presenter: presenter)
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

    // MARK: - Book
    func bookTripPressed() {
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
            view?.showAlert(title: UITexts.Errors.somethingWentWrong,
                            message: UITexts.Errors.getUserFail,
                            error: nil)
            view?.setDefaultState()
            return
        }
        
        if let destination = bookingDetails.destinationLocationDetails {
            analytics.bookingRequested(destination: destination,
                                       dateScheduled: bookingDetails.scheduledDate,
                                       quote: quote)
        }
        
        if let nonce = view?.getPaymentNonce() {
            if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
                self.getPaymentNonceThenBook(user: currentUser,
                                            organisationId: currentOrg,
                                            passengerDetails: passengerDetails)
            } else {
                book(paymentNonce: nonce,
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
        
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
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
            
            view.getLoyaltyNonce { [weak self] result in
                if let error = result.errorValue() {
                    self?.showLoyaltyNonceError(error: error)
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
        
        var tripBooking = TripBooking(quoteId: quote.id,
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [passenger]),
                                      flightNumber: flight,
                                      paymentNonce: paymentNonce,
                                      loyaltyNonce: loyaltyNonce,
                                      comments: view?.getComments())
        
        var map: [String: Any] = [:]
        if let metadata = bookingMetadata {
            map = metadata
        }
        tripBooking.meta = map
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            tripBooking.meta["trip_id"] = paymentNonce
        }
        
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

            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                view?.retryAddPaymentMethod(showRetryAlert: true)
            } else {
                callback(ScreenResult.failed(error: result.errorValue()))
            }

            return
        }

        self.trip = trip
        view?.showCheckoutView(false)
    }
    
    private func handleGuestAndTokenBookTripResult(_ result: Result<TripInfo>) {
        if let trip = result.successValue() {
            callback(.completed(result: trip))
        } else if let error = result.errorValue() {
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
                 
             case .cancelledByUser:
                 self.view?.setDefaultState()
                 
             case .failedToAddCard(let error):
                 self.view?.setDefaultState()
                 self.view?.show(error: error)
                 
             default:
                 self.view?.showAlert(title: UITexts.Generic.error,
                                      message: UITexts.Errors.somethingWentWrong,
                                      error: nil)
                 view?.setDefaultState()
             }
        }
    }
    
    private func getPaymentNonceAccordingToAuthState() -> String? {
        switch Karhoo.configuration.authenticationMethod() {
        case .tokenExchange(settings: _), .karhooUser: return retrievePaymentNonce()
        default: return view?.getPaymentNonce()
        }
    }
    
    private func retrievePaymentNonce() -> String? {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
            return userService.getCurrentUser()?.nonce?.nonce
        } else {
            return view?.getPaymentNonce()
        }
    }

    private func threeDSecureNonceThenBook(nonce: String, passengerDetails: PassengerDetails) {
        threeDSecureProvider.threeDSecureCheck(nonce: nonce,
                                               currencyCode: quote.price.currencyCode,
                                               paymentAmout: NSDecimalNumber(value: quote.price.highPrice),
                                               callback: { [weak self] result in
                                                switch result {
                                                case .completed(let result): handleThreeDSecureCheck(result)
                                                case .cancelledByUser:
                                                    self?.view?.resetPaymentNonce()
                                                    self?.view?.setDefaultState()
                                                }
        })

        func handleThreeDSecureCheck(_ result: ThreeDSecureCheckResult) {
            switch result {
            case .failedToInitialisePaymentService:
                view?.setDefaultState()
                
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

    func didPressClose() {
        PassengerInfo.shared.set(details: view?.getPassengerDetails())
        view?.showCheckoutView(false)
    }

    func screenHasFadedOut() {
        if let trip = self.trip {
             callback(ScreenResult.completed(result: trip))
         } else {
             callback(ScreenResult.cancelled(byUser: false))
         }
    }
    
    private func setUpBookingButtonState() {
        if TripInfoUtility.isAirportBooking(bookingDetails) {
             view?.setAddFlightDetailsState()
         } else {
            didAddPassengerDetails()
         }
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
        alert.addAction(UIAlertAction(title: UITexts.Generic.ok, style: .default, handler: { [weak self] action in
            self?.view?.setDefaultState()
        }))
        view?.present(alert, animated: true, completion: nil)
    }
}
