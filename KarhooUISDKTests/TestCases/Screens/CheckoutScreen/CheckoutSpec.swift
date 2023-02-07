//
//  CheckoutSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import SwiftUI
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class ChackoutSpec: QuickSpec {

    override func spec() {
        describe("Checkout") {
            var sut: KarhooCheckoutViewModel!
            var mockQuoteValidityWorker: QuoteValidityWorker!
            var mockTripService: MockTripService!
            var mockUserService: MockUserService!
            var mockAnalytics: MockAnalytics!
            var mockSdkConfiguration: KarhooTestConfiguration!
            var mockBookingWoker: CheckoutBookingWorker!
            var mockDateFormatter: MockDateFormatterType!
            var mockVehicleRuleProvider: VehicleRulesProvider

            beforeEach {
                sut =
            }
        }
    }
}



// MARK: = mocks


class MockQuoteValidityWorker: QuoteValidityWorker {
    private(set) var invalidateCallCount = 0
    func invalidate() {
        invalidateCallCount += 1
    }

    private(set) var setQuoteValidityDeadlineCallCount = 0
    private(set) var setQuoteValidityDeadlineReceivedArguments: (quote: Quote, deadlineCompletion: () -> Void)?
    func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    ) {
        setQuoteValidityDeadlineCallCount += 1
        setQuoteValidityDeadlineReceivedArguments = (quote: quote, deadlineCompletion: deadlineCompletion)
    }
}

class MockCheckoutBookingWorker: CheckoutBookingWorker {
    var statePublisher: Published<CheckoutBookingState>.Publisher = Published<CheckoutBookingState>.empty.eraseToAnyPublisher()
    var state: CheckoutBookingState = .initial
    var passengerDetails: PassengerDetails?
    var trainNumber: String?
    var flightNumber: String?
    var comment: String?

    func performBooking() {
        // Dummy implementation
    }

    func update(passengerDetails: PassengerDetails?) {
        self.passengerDetails = passengerDetails
    }

    func update(trainNumber: String?) {
        self.trainNumber = trainNumber
    }

    func update(flightNumber: String?) {
        self.flightNumber = flightNumber
    }

    func update(comment: String?) {
        self.comment = comment
    }
}
