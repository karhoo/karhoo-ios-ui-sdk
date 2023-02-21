//
//  KarhooCheckoutPaymentWorker.swift
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

enum CheckoutBookingState: Equatable {
    case idle
    case loading
    case failure(KarhooError)
    case success(TripInfo)

    static func == (lhs: CheckoutBookingState, rhs: CheckoutBookingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedMessage == rhsError.localizedMessage
        case (.success(let lhsTripInfo), .success(let rhsTripInfo)):
            return lhsTripInfo.tripId == rhsTripInfo.tripId
        default:
            return false
        }
    }
}

protocol CheckoutBookingWorker: AnyObject {
    var stateSubject: CurrentValueSubject<CheckoutBookingState, Never> { get }
    func performBooking()
    func update(passengerDetails: PassengerDetails?)
    func update(trainNumber: String?)
    func update(flightNumber: String?)
    func update(comment: String?)
}

final class KarhooCheckoutBookingWorker: CheckoutBookingWorker {

    // MARK: - Depencencies

    private let userService: UserService
    private let tripService: TripService
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let paymentWorker: CheckoutPaymentWorker
    private let loyaltyWorker: LoyaltyWorker
    private let analytics: Analytics

    // MARK: - Properties

    private let quote: Quote
    private let journeyDetails: JourneyDetails
    private var passengerDetails: PassengerDetails?
    private var trainNumber: String?
    private var flightNumber: String?
    private var comment: String?
    private let bookingMetadata: [String: Any]?

    private(set) var stateSubject = CurrentValueSubject<CheckoutBookingState, Never>(.idle)
    private var bookingState: CheckoutBookingState {
        stateSubject.value
    }

    // MARK: - Lifecycle

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        userService: UserService = Karhoo.getUserService(),
        tripService: TripService = Karhoo.getTripService(),
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        paymentWorker: CheckoutPaymentWorker = KarhooCheckoutPaymentWorker(),
        loyaltyWorker: LoyaltyWorker = KarhooLoyaltyWorker.shared,
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

    func update(trainNumber: String?) {
        self.trainNumber = trainNumber
    }

    func update(comment: String?) {
        self.comment = comment
    }

    func performBooking() {
        switch bookingState {
        case .loading: break
        default:
            stateSubject.send(.loading)
            if isKarhooUser() {
                submitAuthenticatedBooking()
            } else {
                submitGuestOrTokenExchangeBooking()
            }
        }
    }

    // MARK: - Setup methods

    private func setup() {
        loyaltyWorker.setup(using: quote)
        paymentWorker.setup(using: quote)
    }

    // MARK: - Booking initial methods

    private func submitGuestOrTokenExchangeBooking() {
        guard let passengerDetails = passengerDetails else {
            stateSubject.send(.failure(ErrorModel(message: UITexts.Errors.getUserFail, code: "")))
            return
        }

        if sdkConfiguration.paymentManager.shouldCheckThreeDSBeforeBooking {
            guard let user = userService.getCurrentUser(),
                  let currentOrganisation = user.organisations.first?.id
            else {
                stateSubject.send(.failure(ErrorModel(message: UITexts.Errors.getUserFail, code: "")))
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
            stateSubject.send(.failure(ErrorModel(message: UITexts.Errors.getUserFail, code: "")))
            return
        }
        paymentWorker.getPaymentNonce(
            organisationId: currentOrganisation,
            completion: { [weak self] result in
                switch result {
                case .completed(let result):
                    self?.handleGetPaymentNonceResult(result)
                case .cancelledByUser:
                    self?.stateSubject.send(.idle)
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
                        self?.stateSubject.send(.failure(error))
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
            stateSubject.send(.failure(error ?? ErrorModel.unknown()))
        case .failedToAddCard(error: let error):
            if let error {
                stateSubject.send(.failure(error))
            } else {
                stateSubject.send(.idle)
            }
            stateSubject.send(.failure(error ?? ErrorModel.unknown()))
        case .cancelledByUser:
            stateSubject.send(.idle)
        }
    }

    func handleThreeDSecureCheck(_ result: OperationResult<ThreeDSecureCheckResult>) {
        switch result {
        case .completed(value: let result):
            switch result {
            case .failedToInitialisePaymentService:
                stateSubject.send(.failure(ErrorModel(message: UITexts.PaymentError.noDetailsMessage, code: "")))
            case .threeDSecureAuthenticationFailed:
                stateSubject.send(.idle)
                requestNewPaymentMethod()
            case .success:
                book()
            }
        case .cancelledByUser:
            stateSubject.send(.idle)
        }
    }

    private func handleAddNewPaymentMethod(with result: CardFlowResult) {
        switch result {
        case .didAddPaymentMethod:
            if isKarhooUser() {
                submitAuthenticatedBooking()
            } else {
                submitGuestOrTokenExchangeBooking()
            }
        case .didFailWithError(let error):
            stateSubject.send(.failure(error ?? ErrorModel.unknown()))
        case .cancelledByUser:
            stateSubject.send(.idle)
        }
    }

    private func sendBookRequest(loyaltyNonce: String? = nil) {
        guard let paymentNonce = paymentWorker.getStoredPaymentNonce(),
              let passengerDetails = passengerDetails else {
            stateSubject.send(.failure(ErrorModel(message: UITexts.Errors.somethingWentWrong, code: "")))
            assertionFailure("At this point all required data should be already in place.")
            return
        }
        var flight: String? = flightNumber
        if let flightText = flight, (flightText.isEmpty || flightText.isWhitespace) {
            flight = nil
        }
        var train: String? = trainNumber
        if let trainText = train, (trainText.isEmpty || trainText.isWhitespace) {
            train = nil
        }

        var tripBooking = TripBooking(
            quoteId: quote.id,
            passengers: Passengers(
                additionalPassengers: journeyDetails.passangersCount - 1,
                passengerDetails: [passengerDetails],
                luggage: Luggage(total: journeyDetails.luggagesCount)
            ),
            flightNumber: flight,
            trainNumber: train,
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
            stateSubject.send(.idle)
            reportBookingFailure(
                message: result.getErrorValue()?.message ?? "",
                correlationId: result.getCorrelationId()
            )
            if result.getErrorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                requestNewPaymentMethod(showRetryAlert: true)
            } else {
                stateSubject.send(.failure(result.getErrorValue() ?? ErrorModel.unknown()))
            }

            return
        }

        stateSubject.send(.success(trip))
        reportBookingSuccess(tripId: trip.tripId, correlationId: result.getCorrelationId())
    }

    private func handleGuestAndTokenBookTripResult(_ result: Result<TripInfo>) {
        if let trip = result.getSuccessValue() {
            reportBookingSuccess(tripId: trip.tripId, correlationId: result.getCorrelationId())
            stateSubject.send(.success(trip))
        } else if let error = result.getErrorValue() {
            reportBookingFailure(message: error.message, correlationId: result.getCorrelationId())
            stateSubject.send(.failure(result.getErrorValue() ?? ErrorModel.unknown()))
        } else {
            stateSubject.send(.failure(ErrorModel.unknown()))
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

    // MARK: - Utils

    private func isLoyaltyEnabled() -> Bool {
        loyaltyWorker.isLoyaltyEnabled
    }

    private func isKarhooUser() -> Bool {
        switch sdkConfiguration.authenticationMethod() {
        case .karhooUser: return true
        default: return false
        }
    }
}
