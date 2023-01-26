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
    private let paymentWorker: NewCheckoutPaymentWorker
    private let loyaltyWorker: LoyaltyWorker
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
        loyaltyWorker: LoyaltyWorker = KarhooLoyaltyWorker(),
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
        self.setup()
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
                submitGuestOrTokenExchangeBooking()
            }
        }
    }

    // MARK: - Setup methods

    private func setup() {
        paymentWorker.setup(using: quote)
    }

    // MARK: - Booking initial methods

    private func submitGuestOrTokenExchangeBooking() {
        guard let passengerDetails = passengerDetails else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
            return
        }

        if sdkConfiguration.paymentManager.shouldCheckThreeDSBeforeBooking {
            guard let user = userService.getCurrentUser(),
                  let currentOrganisation = user.organisations.first?.id
            else {
                bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
                return
            }
            paymentWorker.threeDSecureNonceCheck(
                organisationId: currentOrganisation,
                passengerDetails: passengerDetails
            ) { [weak self] result in
                self?.handleThreeDSecureCheck(result)
            }
        } else {
            guard paymentWorker.getStoredPaymentNonce() != nil else {
                requestNewPaymentMethod()
                return
            }
            book()
        }
    }

    private func submitAuthenticatedBooking() {
        if paymentWorker.getStoredPaymentNonce() != nil {
            if sdkConfiguration.paymentManager.shouldGetPaymentBeforeBooking {
                getPaymentNonceAndBook()
            } else {
                book()
            }
        } else {
            getPaymentNonceAndBook()
        }
    }

    // MARK: - Payment handling methods

    private func getPaymentNonceAndBook() {
        guard
            let currentOrganisation = userService.getCurrentUser()?.organisations.first?.id
        else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.getUserFail, code: ""))
            return
        }
        paymentWorker.getPaymentNonce(
            organisationId: currentOrganisation,
            completion: { [weak self] result in
                switch result {
                case .completed(let result):
                    self?.handleGetPaymentNonceResult(result)
                case .cancelledByUser:
                    self?.bookingState = .idle
                }
            }
        )
    }

    // MARK: - Booking handling methods

    private func book() {
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
            sendBookRequest()
        }
    }

    func handleGetPaymentNonceResult(_ paymentNonceResult: PaymentNonceProviderResult) {
        switch paymentNonceResult {
        case .nonce:
            book()
        case .threeDSecureCheckFailed:
            requestNewPaymentMethod(showRetryAlert: true)
        case .failedToInitialisePaymentService(error: let error):
            bookingState = .failure(error ?? ErrorModel.unknown())
        case .failedToAddCard(error: let error):
            if let error {
                bookingState = .failure(error)
            } else {
                bookingState = .idle
            }
            bookingState = .failure(error ?? ErrorModel.unknown())
        case .cancelledByUser:
            bookingState = .idle
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
                requestNewPaymentMethod()
            case .success:
                book()
            }
        case .cancelledByUser:
            bookingState = .idle
        }
    }

    private func handleAddNewPaymentMethod(with result: CardFlowResult) {
        switch result {
        case .didAddPaymentMethod:
            performBooking()
        case .didFailWithError(let error):
            bookingState = .failure(error ?? ErrorModel.unknown())
        case .cancelledByUser:
            bookingState = .idle
        }
    }

    private func sendBookRequest(loyaltyNonce: String? = nil) {
        guard let paymentNonce = paymentWorker.getStoredPaymentNonce(),
              let passengerDetails = passengerDetails else {
            bookingState = .failure(ErrorModel(message: UITexts.Errors.somethingWentWrong, code: ""))
            assertionFailure("At this point all required data should be already in place.")
            return
        }
        var flight: String? = flightNumber
        if let flightText = flight, (flightText.isEmpty || flightText.isWhitespace) {
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

    // MARK: - Manage payment-related flow

    private func requestNewPaymentMethod(showRetryAlert: Bool = false) {
        paymentWorker.requestNewPaymentMethod(showRetryAlert: showRetryAlert) { [weak self] result in
            self?.handleAddNewPaymentMethod(with: result)
        }
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
                requestNewPaymentMethod(showRetryAlert: true)
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
            lastFourDigits: paymentWorker.getStoredPaymentNonce()?.lastFour ?? "",
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

    private func isLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }

    private func isKarhooUser() -> Bool {
        switch sdkConfiguration.authenticationMethod() {
        case .karhooUser: return true
        default: return false
        }
    }
}
