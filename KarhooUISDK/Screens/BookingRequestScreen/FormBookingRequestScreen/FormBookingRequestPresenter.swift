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
    
    private var karhooUser: Bool = false

    init(quote: Quote,
         bookingDetails: BookingDetails,
         bookingMetadata: [String: Any]?,
         threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
         tripService: TripService = Karhoo.getTripService(),
         paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
         userService: UserService = Karhoo.getUserService(),
         callback: @escaping ScreenResultCallback<TripInfo>) {
        self.threeDSecureProvider = threeDSecureProvider
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.quote = quote
        self.bookingDetails = bookingDetails
        self.paymentNonceProvider = paymentNonceProvider
        self.bookingMetadata = bookingMetadata
    }

    func load(view: BookingRequestView, karhooUser: Bool = false) {
        self.view = view
        self.karhooUser = karhooUser
        view.set(quote: quote)
        setUpBookingButtonState()
        threeDSecureProvider.set(baseViewController: view)
        
        
        if karhooUser {
            finishLoad(view: view)
        }
    }
    
    func isUserAuthenticated() -> Bool {
        karhooUser
    }
    
    private func finishLoad(view: BookingRequestView) {
        if quote.source == .market {
            view.set(price: CurrencyCodeConverter.quoteRangePrice(quote: quote))
        } else {
            view.set(price: CurrencyCodeConverter.toPriceString(quote: quote))
        }

        view.set(quoteType: quote.quoteType.description)
        view.set(baseFareExplanationHidden: quote.quoteType == .fixed)
        paymentNonceProvider.set(baseViewController: view)
        configureQuoteView()
        view.paymentView(hidden: userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen)
    }

    func bookTripPressed() {
        view?.setRequestingState()
        
        guard let passengerDetails = view?.getPassengerDetails(), let nonce = getPaymentNonceAccordingToAuthState() else {
            view?.setDefaultState()
            return
        }

        if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
            threeDSecureNonceThenBook(nonce: nonce,
                                      passengerDetails: passengerDetails)
        } else {
            book(threeDSecureNonce: nonce, passenger: passengerDetails)
        }
    }

    private func getPaymentNonceAccordingToAuthState() -> String? {
        switch Karhoo.configuration.authenticationMethod() {
        case .tokenExchange(settings: _): return tokenExchangeNonce()
        case .karhooUser: return userService.getCurrentUser()?.nonce?.nonce
        default: return view?.getPaymentNonce()
        }
    }
    
    private func tokenExchangeNonce() -> String? {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .braintree {
            return userService.getCurrentUser()?.nonce?.nonce
        } else {
            return view?.getPaymentNonce()
        }
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
                book(threeDSecureNonce: threeDSecureNonce, passenger: passengerDetails)
            }
        }
    }

    private func book(threeDSecureNonce: String, passenger: PassengerDetails) {
        let flightNumber = view?.getFlightNumber()?.isEmpty == true ? nil : view?.getFlightNumber()
        var tripBooking = TripBooking(quoteId: quote.id,
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [passenger]),
                                      flightNumber: flightNumber,
                                      paymentNonce: threeDSecureNonce,
                                      comments: view?.getComments())
        
        var map: [String: Any] = [:]
        if let metadata = bookingMetadata {
            map = metadata
        }
        tripBooking.meta = map
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            tripBooking.meta["trip_id"] = threeDSecureNonce
        }

        tripService.book(tripBooking: tripBooking).execute(callback: { [weak self] result in
            self?.view?.setDefaultState()

            if let trip = result.successValue() {
                PassengerInfo.shared.passengerDetails = self?.view?.getPassengerDetails()
                self?.callback(.completed(result: trip))
            } else if let error = result.errorValue() {
                self?.view?.showAlert(title: UITexts.Generic.error, message: "\(error.localizedMessage)", error: result.errorValue())
            }
        })
    }

    func didPressAddFlightDetails() {}
    func didPressFareExplanation() {}

    func didPressClose() {
        PassengerInfo.shared.passengerDetails = view?.getPassengerDetails()
        view?.showBookingRequestView(false)
    }

    func screenHasFadedOut() {
        callback(ScreenResult.cancelled(byUser: true))
    }
    
    private func setUpBookingButtonState() {
        if TripInfoUtility.isAirportBooking(bookingDetails) {
            view?.setAddFlightDetailsState()
        }
    }
}
