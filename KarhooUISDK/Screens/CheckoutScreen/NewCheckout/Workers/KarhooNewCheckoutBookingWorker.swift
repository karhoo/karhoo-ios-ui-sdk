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
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let paymentWorker: KarhooNewCheckoutPaymentWorker
    private let analytics: Analytics

    // MARK: - Properties

    private var quote: Quote!
    private(set) var paymentNonce: Nonce?
    private(set) var loyaltyNonce: LoyaltyNonce?
    private(set) var passengerDetails: PassengerDetails?
    private var flightNumber: String?

    var statePublisher: Published<NewCheckoutBookingState>.Publisher { $bookingState }
    @Published var bookingState: NewCheckoutBookingState = .idle

    // MARK: - Lifecycle

    init(
        quote: Quote,
        userService: UserService = Karhoo.getUserService(),
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        paymentWorker: KarhooNewCheckoutPaymentWorker = KarhooNewCheckoutPaymentWorker(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.quote = quote
        self.userService = userService
        self.sdkConfiguration = sdkConfiguration
        self.paymentWorker = paymentWorker
        self.analytics = analytics
    }

    // MARK: - Endpoints

    func isReadyToPerformBooking() -> Bool {
        true
    }

    func update(passengerDetails: PassengerDetails?) {
        self.passengerDetails = passengerDetails
    }

    func update(flightNumber: String?) {
        self.flightNumber = flightNumber
    }

    func performBooking() {
        switch bookingState {
        case .loading: break
        default:
            bookingState = .loading
            reportBookingEvent()
            if sdkConfiguration.authenticationMethod().isGuest() {
                submitGuestBooking()
            } else {
                submitAuthenticatedBooking()
            }
        }
    }

    // MARK: - Booking main methods

    private func submitGuestBooking() {
        guard let passengerDetails = passengerDetails else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
            return
        }
        guard let nonce = paymentWorker.getPaymentNonceAccordingToAuthState() else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.somethingWentWrong, code: ""))
            // TODO: handle in payment worker
            return
        }

        if sdkConfiguration.paymentManager.shouldCheckThreeDSBeforeBooking {
            guard userService.getCurrentUser() != nil
            else {
                bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
                return
            }
            mockBookingSuccess()
//            threeDSecureNonceThenBook(
//                nonce: nonce,
//                passengerDetails: passengerDetails
//            )
        } else {
            mockBookingSuccess()
//            book(
//                paymentNonce: nonce,
//                passenger: passengerDetails,
//                flightNumber: flightNumber
//            )
        }
    }

    private func submitAuthenticatedBooking() {
        mockBookingSuccess()
    }

    // MARK: - Booking handling methods

    private func book(paymentNonce: String, passenger: PassengerDetails, flightNumber: String?) {
        mockBookingSuccess()
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
}
