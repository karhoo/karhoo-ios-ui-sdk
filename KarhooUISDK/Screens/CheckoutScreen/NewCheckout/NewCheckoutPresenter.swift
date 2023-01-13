//
//  NewCheckoutPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
import SwiftUI
import Combine

enum NewCheckoutState {
    case loading
    case idle
    case scheduled
}

final class KarhooNewCheckoutViewModel: ObservableObject {

    // MARK: - Dependencies

    private let tripService: TripService
    private let userService: UserService
    private let quoteValidityWorker: QuoteValidityWorker
    private let analytics: Analytics
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let paymentsWorker = KarhooNewCheckoutPaymentAndBookingWorker()
    private let dateFormatter: DateFormatterType

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    private let quote: Quote
    private let journeyDetails: JourneyDetails
    private(set) var passengerDetails: PassengerDetails!
    private(set) var trip: TripInfo?
    private let bookingMetadata: [String: Any]?
    private var comments: String?
    private let callback: ScreenResultCallback<KarhooCheckoutResult>

    @Published var quoteExpired: Bool = false
    var termsAndConditionsAccepted: Bool = false

    // MARK: - Init & Config

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        quoteValidityWorker: QuoteValidityWorker = KarhooQuoteValidityWorker(),
        tripService: TripService = Karhoo.getTripService(),
        userService: UserService = Karhoo.getUserService(),
        passengerDetails: PassengerDetails? = PassengerInfo.shared.getDetails(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
        sdkConfiguration: KarhooUISDKConfiguration =  KarhooUISDKConfigurationProvider.configuration,
        dateFormatter: DateFormatterType = KarhooDateFormatter(),
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) {
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.quoteValidityWorker = quoteValidityWorker
        self.passengerDetails = passengerDetails ?? PassengerInfo.shared.currentUserAsPassenger()
        self.sdkConfiguration = sdkConfiguration
        self.analytics = analytics
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.dateFormatter = dateFormatter
    }

    // MARK: - Endpoints

    func onAppear() {
        quoteValidityWorker.setQuoteValidityDeadline(quote) { [weak self] in
            self?.quoteExpired = true
        }

        paymentsWorker.statePublisher
            .sink { [weak self] bookingState in
                // TODO: handle booking state
                print(bookingState)
            }
            .store(in: &cancellables)
    }

    // MARK: Get simple data to display

    func getDateScheduledDescription() -> String {
        let date = trip?.dateScheduled ?? Date()
        let dateFormatted = dateFormatter.display(
            date,
            dateStyle: .long,
            timeStyle: .none
        )
        let weekday = {
            guard let weekdayIndex = Calendar.current.dateComponents([.weekday], from: date).weekday else {
                return ""
            }
            return (Calendar.current.standaloneWeekdaySymbols[safe: weekdayIndex] ?? "") + ", "
        }()
        return "\(weekday)\(dateFormatted)".uppercased()
    }

    func getPrintedPickUpAddressLine1() -> String {
        journeyDetails.printedPickUpAddressLine1
    }

    func getPrintedPickUpAddressLine2() -> String {
        journeyDetails.printedPickUpAddressLine2
    }

    func getPrintedDropOffAddressLine1() -> String {
        journeyDetails.printedDropOffAddressLine1
    }

    func getPrintedDropOffAddressLine2() -> String {
        journeyDetails.printedDropOffAddressLine2
    }

    func getTimeLabelTextDescription() -> String {
        var scheduledTime: String {
            guard let date = journeyDetails.scheduledDate else {
                return ""
            }
            return dateFormatter.display(clockTime: date)
        }
        return journeyDetails.isScheduled ? scheduledTime : UITexts.Generic.now.uppercased()
    }

    // MARK: Interactions

    func didTapPassenger() {
        // TODO: - handle passenger flow
    }

    func didTapOptions() {
        // TODO: - handle options flow
    }

    func didTapFlightNumber() {
        // TODO: - handle flight number flow
    }

    func didSetTermsAndConditions(_ termsAndConditionsSelected: Bool) {
        // TODO: - handle t&c flow
    }

    func didSetComment(_ comment: String) {
        // TODO: - handle comment flow
    }

    func didTapConfirm() {
        // MARK: - Validate & proceed with payment flow
        guard validateIfAllRequiredDataAreProvided() else {
            return
        }
        submitBooking()
    }

    // MARK: - Booking

    private func submitBooking() {
        paymentsWorker.performBooking()
    }

    // MARK: - Analytics

    private func reportScreenOpened() {
        analytics.checkoutOpened(quote)
    }

    private func reportBookingEvent(quoteId: String) {
        analytics.bookingRequested(quoteId: quoteId)
    }

    private func reportBookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
        analytics.bookingSuccess(tripId: tripId, quoteId: quoteId, correlationId: correlationId)
    }

    private func reportBookingFailure(message: String, correlationId: String?) {
        analytics.bookingFailure(
            quoteId: quote.id,
            correlationId: correlationId ?? "",
            message: message,
            lastFourDigits: paymentsWorker.getPaymentNonce()?.lastFour ?? "",
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
    private func reportBookingConfirmationScreenOpened(tripId: String?, quoteId: String) {
        analytics.rideConfirmationScreenOpened(date: Date(), tripId: tripId, quoteId: quoteId)
    }

    // MARK: - Helpers

    private var isKarhooUser: Bool {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser: return true
        default: return false
        }
    }

    // MARK: Validation

    private func validateIfAllRequiredDataAreProvided() -> Bool {
        guard let details = passengerDetails,
              details.areValid
        else {
            return false
        }
        guard paymentsWorker.isReadyToPerformPayment() else {
            return false
        }

        return true

    }
}
