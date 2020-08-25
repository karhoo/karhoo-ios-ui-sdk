//
//  GuestBookingRequestPresenter.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

final class GuestBookingRequestPresenter: BookingRequestPresenter {

    private let callback: ScreenResultCallback<TripInfo>
    private weak var view: BookingRequestView?
    private let quote: Quote
    private let bookingDetails: BookingDetails
    internal var passengerDetails: PassengerDetails!
    private let threeDSecureProvider: ThreeDSecureProvider
    private let tripService: TripService
    private let userService: UserService

    init(quote: Quote,
         bookingDetails: BookingDetails,
         threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
         tripService: TripService = Karhoo.getTripService(),
         userService: UserService = Karhoo.getUserService(),
         callback: @escaping ScreenResultCallback<TripInfo>) {
        self.threeDSecureProvider = threeDSecureProvider
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.quote = quote
        self.bookingDetails = bookingDetails
    }

    func load(view: BookingRequestView) {
        self.view = view
        view.set(quote: quote)
        setUpBookingButtonState()
        threeDSecureProvider.set(baseViewController: view)
    }

    func bookTripPressed() {
        view?.setRequestingState()

        guard let passengerDetails = view?.getPassengerDetails(), let nonce = getPaymentNonceAccordingToAuthState() else {
            view?.setDefaultState()
            return
        }

        threeDSecureNonceThenBook(nonce: nonce,
                                  passengerDetails: passengerDetails)
    }

    private func getPaymentNonceAccordingToAuthState() -> String? {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return view?.getPaymentNonce()
        }

        return userService.getCurrentUser()?.nonce?.nonce
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
        let tripBooking = TripBooking(quoteId: quote.id,
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [passenger]),
                                      flightNumber: flightNumber,
                                      paymentNonce: threeDSecureNonce,
                                      comments: view?.getComments())

        tripService.book(tripBooking: tripBooking).execute(callback: { [weak self] result in
            self?.view?.setDefaultState()

            if let trip = result.successValue() {
                PassengerInfo.shared.passengerDetails = self?.view?.getPassengerDetails()
                self?.callback(.completed(result: trip))
            } else if let error = result.errorValue() {
                self?.view?.showAlert(title: UITexts.Generic.error, message: "\(error.localizedMessage)")
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
