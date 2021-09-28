//
//  PassengerFormBookingRequestPresenter.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

final class FormBookingRequestPresenter: BookingRequestPresenter {
    private let callback: ScreenResultCallback<TripInfo>
    private weak var view: BookingRequestView?
    private let quote: Quote
    private let bookingDetails: BookingDetails
    internal var passengerDetails: PassengerDetails!
    private let threeDSecureProvider: ThreeDSecureProvider
    private let tripService: TripService
    private let userService: UserService
    private let bookingMetadata: [String: Any]?
    private let paymentNonceProvider: PaymentNonceProvider
    
    private let analytics: Analytics
    private let appStateNotifier: AppStateNotifierProtocol
    private var trip: TripInfo?
    private var flightNumber: String?
    private var comments: String?
    private var bookingRequestInProgress: Bool = false
    private var flightDetailsScreenIsPresented: Bool = false
    private let flightDetailsScreenBuilder: FlightDetailsScreenBuilder
    private let baseFareDialogBuilder: PopupDialogScreenBuilder

    var karhooUser: Bool = false

    init(quote: Quote,
         bookingDetails: BookingDetails,
         bookingMetadata: [String: Any]?,
         threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
         tripService: TripService = Karhoo.getTripService(),
         userService: UserService = Karhoo.getUserService(),
         analytics: Analytics = KarhooAnalytics(),
         appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
         flightDetailsScreenBuilder: FlightDetailsScreenBuilder = KarhooUI().screens().flightDetails(),
         baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
         paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
         callback: @escaping ScreenResultCallback<TripInfo>) {
        self.threeDSecureProvider = threeDSecureProvider
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.paymentNonceProvider = paymentNonceProvider
        self.appStateNotifier = appStateNotifier
        self.analytics = analytics
        self.flightDetailsScreenBuilder = flightDetailsScreenBuilder
        self.baseFareDialogBuilder = baseFarePopupDialogBuilder
        self.quote = quote
        self.bookingDetails = bookingDetails
        self.bookingMetadata = bookingMetadata
        
        appStateNotifier.register(listener: self)
    }

    func load(view: BookingRequestView) {
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
        view.set(quote: quote)
        setUpBookingButtonState()
        threeDSecureProvider.set(baseViewController: view)
    }

     private func completeLoadingViewForKarhooUser(view: BookingRequestView) {
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
    
    func addOrEditPassengerDetails() {
        var details = view?.getPassengerDetails()
        let presenter = PassengerDetailsPresenter(details: details) { result in
            if result.isComplete() {
                details = result.completedValue()
                PassengerInfo.shared.set(details: details)
                self.view?.setPassenger(details: details)
            }
        }
        let detailsViewController = PassengerDetailsViewController(presenter: presenter)
        view?.showAsOverlay(item: detailsViewController, animated: true)
    }
    
    func addMoreDetails() {
        if !arePassengerDetailsValid() {
            addOrEditPassengerDetails()
        } else {
            view?.retryAddPaymentMethod()
        }
    }
    
    func didAddPassengerDetails() {
        if !arePassengerDetailsValid() || getPaymentNonceAccordingToAuthState() == nil {
            view?.setMoreDetailsState()
        } else {
            view?.setDefaultState()
        }
    }
    
    private func arePassengerDetailsValid() -> Bool {
        guard let details = view?.getPassengerDetails(),
              Utils.isValidName(name: details.firstName),
              Utils.isValidName(name: details.lastName),
              Utils.isValidEmail(email: details.email),
              Utils.isValidPhoneNumber(number: details.phoneNumber),
              !details.locale.isEmpty
        else {
            return false
        }
        
        return true
    }

    func bookTripPressed() {
        view?.setRequestingState()
        
        if karhooUser {
            submitKarhooUserBooking()
        } else {
            submitGuestAndTokenBooking()
        }
    }

    private func submitKarhooUserBooking() {
        bookingRequestInProgress = true
        
        guard let currentUser = userService.getCurrentUser(),
              let passengerDetails = view?.getPassengerDetails(),
              let currentOrg = userService.getCurrentUser()?.organisations.first
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
            book(paymentNonce: nonce,
                 passenger: passengerDetails,
                 flightNumber: flightNumber)
        } else {
            paymentNonceProvider.getPaymentNonce(user: currentUser,
                                                 organisation: currentOrg,
                                                 quote: quote) { [weak self] result in
                switch result {
                case .completed(let result):
                    handlePaymentNonceProviderResult(result)
                    
                case .cancelledByUser:
                    self?.view?.setDefaultState()
                }
            }
        }
        func handlePaymentNonceProviderResult(_ paymentNonceResult: PaymentNonceProviderResult) {
             switch paymentNonceResult {
             case .nonce(let nonce):
                 self.book(paymentNonce: nonce.nonce,
                      passenger: passengerDetails,
                      flightNumber: flightNumber)
                 
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
    
    private func submitGuestAndTokenBooking() {
        guard let passengerDetails = view?.getPassengerDetails(),
              let nonce = getPaymentNonceAccordingToAuthState()
        else {
            view?.setDefaultState()
            return
        }
        
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
            threeDSecureNonceThenBook(nonce: nonce,
                                      passengerDetails: passengerDetails)
        } else {
            let flightNumber = view?.getFlightNumber()?.isEmpty == true ? nil : view?.getFlightNumber()
            book(paymentNonce: nonce, passenger: passengerDetails, flightNumber: flightNumber)
        }
    }

    private func threeDSecureNonceThenBook(nonce: String, passengerDetails: PassengerDetails) {
        threeDSecureProvider.threeDSecureCheck(nonce: nonce,
                                               currencyCode: quote.price.currencyCode,
                                               paymentAmout: NSDecimalNumber(value: quote.price.highPrice),
                                               callback: { [weak self] result in
                                                switch result {
                                                case .completed(let result): handleThreeDSecureCheck(result)
                                                case .cancelledByUser: self?.view?.setDefaultState()
                                                }
        })

        func handleThreeDSecureCheck(_ result: ThreeDSecureCheckResult) {
            switch result {
            case .failedToInitialisePaymentService:
                view?.setDefaultState()
                
            case .threeDSecureAuthenticationFailed:
                view?.retryAddPaymentMethod()
                view?.setDefaultState()
                
            case .success(let threeDSecureNonce):
                let flightNumber = view?.getFlightNumber()?.isEmpty == true ? nil : view?.getFlightNumber()
                book(paymentNonce: threeDSecureNonce, passenger: passengerDetails, flightNumber: flightNumber)
            }
        }
    }
    
    private func book(paymentNonce: String, passenger: PassengerDetails, flightNumber: String?) {
        var tripBooking = TripBooking(quoteId: quote.id,
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [passenger]),
                                      flightNumber: (flightNumber ?? "").isEmpty ? nil : flightNumber,
                                      paymentNonce: paymentNonce,
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
            }
            else {
                self?.handleGuestAndTokenBookTripResult(result)
            }
        })
    }
    
    private func handleKarhooUserBookTripResult(_ result: Result<TripInfo>) {
        bookingRequestInProgress = false
        
        guard let trip = result.successValue() else {
            view?.setDefaultState()

            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                view?.retryAddPaymentMethod()
            } else {
                callback(ScreenResult.failed(error: result.errorValue()))
            }

            return
        }

        self.trip = trip
        view?.showBookingRequestView(false)
    }
    
    private func handleGuestAndTokenBookTripResult(_ result: Result<TripInfo>) {
        if let trip = result.successValue() {
            PassengerInfo.shared.passengerDetails = view?.getPassengerDetails()
            callback(.completed(result: trip))
        }
        else if let error = result.errorValue() {
            view?.showAlert(title: UITexts.Generic.error, message: "\(error.localizedMessage)", error: result.errorValue())
        }
    }

    func didPressAddFlightDetails() {
        if karhooUser {
            var dismissCallback: (() -> Void)?
            let flightDetailsScreen = flightDetailsScreenBuilder
                .buildFlightDetailsScreen(completion: { [weak self] result in
                    dismissCallback?()
                    self?.flightDetailsScreenIsPresented = false
                    
                    guard let flightDetails = result.completedValue() else {
                        return
                    }
                    
                    self?.didAdd(flightDetails: flightDetails)
                })
            
            dismissCallback = {
                flightDetailsScreen.dismiss(animated: true, completion: nil)
            }
            
            view?.present(flightDetailsScreen, animated: true, completion: nil)
            self.flightDetailsScreenIsPresented = true
        }
    }
    
    private func didAdd(flightDetails: FlightDetails) {
        self.flightDetailsScreenIsPresented = false
        self.flightNumber = flightDetails.flightNumber
        self.comments = flightDetails.comments
        
        submitKarhooUserBooking()
    }
    
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
        PassengerInfo.shared.passengerDetails = view?.getPassengerDetails()
        view?.showBookingRequestView(false)
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
    
    deinit {
        appStateNotifier.remove(listener: self)
    }
}

extension FormBookingRequestPresenter: AppStateChangeDelegate {
    func appDidEnterBackground() {
        if bookingRequestInProgress == false,
           flightDetailsScreenIsPresented == false {
            self.didPressClose()
        }
    }
}
