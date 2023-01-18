//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
import SwiftUI
import Combine

enum NewCheckoutBookingState {
    case idle
    case loading
    case failure(KarhooError)
    case success(TripInfo)
}

protocol NewCheckoutBookingWorker: AnyObject {
    var statePublisher: Published<NewCheckoutBookingState>.Publisher { get }
    func performBooking()
    func update(passengerDetails: PassengerDetails?)
    func update(flightNumber: String?)
}

final class KarhooNewCheckoutBookingWorker: NewCheckoutBookingWorker {

    // MARK: - Depencencies

    private let userService: UserService
    private let tripService: TripService
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let paymentWorker: KarhooNewCheckoutPaymentWorker
    private let loyaltyWorker: NewCheckoutLoyaltyWorker
    private let analytics: Analytics

    // MARK: - Properties

    private let quote: Quote
    private let journeyDetails: JourneyDetails
    private var passengerDetails: PassengerDetails?
    private var flightNumber: String?
    private var comment: String?
    private let bookingMetadata: [String: Any]?

    var statePublisher: Published<NewCheckoutBookingState>.Publisher { $bookingState }
    @Published var bookingState: NewCheckoutBookingState = .idle

    // MARK: - Lifecycle

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        userService: UserService = Karhoo.getUserService(),
        tripService: TripService = Karhoo.getTripService(),
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        paymentWorker: KarhooNewCheckoutPaymentWorker = KarhooNewCheckoutPaymentWorker(),
        loyaltyWorker: NewCheckoutLoyaltyWorker = KarhooNewCheckoutLoyaltyWorker(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.userService = userService
        self.tripService = tripService
        self.sdkConfiguration = sdkConfiguration
        self.paymentWorker = paymentWorker
        self.loyaltyWorker = loyaltyWorker
        self.analytics = analytics
    }

    // MARK: - Endpoints

    func update(passengerDetails: PassengerDetails?) {
        self.passengerDetails = passengerDetails
    }

    func update(flightNumber: String?) {
        self.flightNumber = flightNumber
    }

    func update(comment: String?) {
        self.comment = comment
    }

    func performBooking() {
        switch bookingState {
        case .loading: break
        default:
            bookingState = .loading
            reportBookingEvent()
            if isKarhooUser() {
                submitAuthenticatedBooking()
            } else {
                submitGuestBooking()
            }
        }
    }

    // MARK: - Booking initial methods

    private func submitGuestBooking() {
        guard let passengerDetails = passengerDetails else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
            return
        }

        if sdkConfiguration.paymentManager.shouldCheckThreeDSBeforeBooking {
            guard userService.getCurrentUser() != nil else {
                bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
                return
            }
            paymentWorker.threeDSecureNonceCheck(
                quote: quote,
                passengerDetails: passengerDetails
            ) { result in
                self.handleThreeDSecureCheck(result)
            }
        } else {
            mockBookingSuccess()
            guard let nonce = paymentWorker.getPaymentNonceAccordingToAuthState() else {
                paymentWorker.requestNewPaymentMethod()
                bookingState = .idle
                return
            }
            book(
                paymentNonce: nonce.nonce,
                passenger: passengerDetails
            )
        }
    }

    private func submitAuthenticatedBooking() {
        if isLoyaltyEnabled() {
            loyaltyWorker.getLoyaltyNonce { [weak self] result in
                if let error = result.getErrorValue() {
                    switch error.type {
                    case .errMissingBrowserInfo:
                        self?.sendBookRequest(loyaltyNonce: nil)
                    default:
                        self?.bookingState = .failure(error)
                    }
                } else if let loyaltyNonce = result.getSuccessValue() {
                    self?.sendBookRequest(loyaltyNonce: loyaltyNonce.nonce)
                } else {
                    self?.sendBookRequest(loyaltyNonce: nil)
                }
            }
        } else {
            sendBookRequest(loyaltyNonce: nil)
        }
    }

    // MARK: - Booking handling methods

    private func book(paymentNonce: String, passenger: PassengerDetails) {
        if isLoyaltyEnabled() {
            loyaltyWorker.getLoyaltyNonce { [weak self] result in
                if let error = result.getErrorValue() {
                    if error.type == .errMissingBrowserInfo {
                        self?.sendBookRequest(loyaltyNonce: nil)
                    } else {
                        self?.bookingState = .failure(error)
                    }
                    return
                }

                if let loyaltyNonce = result.getSuccessValue() {
                    self?.sendBookRequest(loyaltyNonce: loyaltyNonce.nonce)
                }
            }
        } else {
            sendBookRequest(loyaltyNonce: nil)
        }
    }

    func handleThreeDSecureCheck(_ result: OperationResult<ThreeDSecureCheckResult>) {
        switch result {
        case .completed(value: let result):
            switch result {
            case .failedToInitialisePaymentService:
                bookingState = .failure(ErrorModel(message: UITexts.PaymentError.noDetailsMessage, code: ""))
            case .threeDSecureAuthenticationFailed:
                bookingState = .idle
                paymentWorker.requestNewPaymentMethod()
            case .success(let threeDSecureNonce):
                guard let passengerDetails = passengerDetails else {
                    assertionFailure()
                    return
                }
                book(paymentNonce: threeDSecureNonce, passenger: passengerDetails)
            case .canceledByUser:
                bookingState = .idle
            }
        case .cancelledByUser:
            bookingState = .idle
        }
    }

    private func sendBookRequest(loyaltyNonce: String?) {
        guard let paymentNonce = paymentWorker.getPaymentNonceAccordingToAuthState(),
              let passengerDetails = passengerDetails else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.somethingWentWrong, code: ""))
            assertionFailure()
            return
        }
        var flight: String? = flightNumber
        if let flightText = flight, (flightText.isEmpty || flightText == " ") {
            flight = nil
        }

        var tripBooking = TripBooking(
            quoteId: quote.id,
            passengers: Passengers(
                additionalPassengers: journeyDetails.passangersCount - 1,
                passengerDetails: [passengerDetails],
                luggage: Luggage(total: journeyDetails.luggagesCount)
            ),
            flightNumber: flight,
            paymentNonce: paymentNonce.nonce,
            loyaltyNonce: loyaltyNonce,
            comments: comment
        )

        var map: [String: Any] = [:]
        if let metadata = bookingMetadata {
            map = metadata
        }
        tripBooking.meta = sdkConfiguration.paymentManager
            .getMetaWithUpdateTripIdIfRequired(
                meta: map,
                nonce: paymentNonce.nonce
            )
        reportBookingEvent()

        tripService.book(tripBooking: tripBooking).execute(callback: { [weak self] result in
            if self?.isKarhooUser() ?? false {
                self?.handleKarhooUserBookTripResult(result)
            } else {
                self?.handleGuestAndTokenBookTripResult(result)
            }
        })
    }

    // MARK: - Booking result handling

    private func handleKarhooUserBookTripResult(_ result: Result<TripInfo>) {
        guard let trip = result.getSuccessValue() else {
            bookingState = .idle
            reportBookingFailure(
                message: result.getErrorValue()?.message ?? "",
                correlationId: result.getCorrelationId()
            )
            if result.getErrorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                paymentWorker.requestNewPaymentMethod(showRetryAlert: true)
            } else {
                bookingState = .failure(result.getErrorValue() ?? ErrorModel.unknown())
            }

            return
        }

        bookingState = .success(trip)
        reportBookingSuccess(tripId: trip.tripId, correlationId: result.getCorrelationId())
    }

    private func handleGuestAndTokenBookTripResult(_ result: Result<TripInfo>) {
        if let trip = result.getSuccessValue() {
            reportBookingSuccess(tripId: trip.tripId, correlationId: result.getCorrelationId())
            bookingState = .success(trip)
        } else if let error = result.getErrorValue() {
            reportBookingFailure(message: error.message, correlationId: result.getCorrelationId())
            bookingState = .failure(result.getErrorValue() ?? ErrorModel.unknown())
        } else {
            bookingState = .failure(ErrorModel.unknown())
        }
    }

    // MARK: - Analytics

    private func reportBookingEvent() {
        analytics.bookingRequested(quoteId: quote.id)
    }

    private func reportBookingSuccess(tripId: String, correlationId: String?) {
        analytics.bookingSuccess(
            tripId: tripId,
            quoteId: quote.id,
            correlationId: correlationId
        )
    }

    private func reportBookingFailure(message: String, correlationId: String?) {
        analytics.bookingFailure(
            quoteId: quote.id,
            correlationId: correlationId ?? "",
            message: message,
            lastFourDigits: paymentWorker.getPaymentNonce()?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }

    private func reportCardAuthorisationSuccess() {
        analytics.cardAuthorisationSuccess(quoteId: quote.id)
    }

    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote.id,
            errorMessage: message,
            lastFourDigits: userService.getCurrentUser()?.nonce?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }

    // MARK: - Utils

    private func mockBookingSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.bookingState = .success(
                TripInfo(
                    tripId: "asdas",
                    passengers: Passengers(additionalPassengers: 2, passengerDetails: [], luggage: .init(total: 3))
                )

                //            self.bookingState = .failure(ErrorModel(message: "something_went_wrong", code: "0231"))
            )})
    }

    private func isLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }

    private func isKarhooUser() -> Bool {
        sdkConfiguration.authenticationMethod().isGuest() == false
    }
}
