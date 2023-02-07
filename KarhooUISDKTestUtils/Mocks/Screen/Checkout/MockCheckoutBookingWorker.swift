//
//  MockCheckoutBookingWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK
@testable import KarhooUISDK

public class MockCheckoutBookingWorker: CheckoutBookingWorker {

    public var stateSubject = CurrentValueSubject<CheckoutBookingState, Never>(.idle)

    public var performBookingCalled = false
    public func performBooking() {
        performBookingCalled = true
    }

    public var updatePassengerDetailsCalled = false
    public var passengerDetails: PassengerDetails?
    public func update(passengerDetails: PassengerDetails?) {
        updatePassengerDetailsCalled = true
        self.passengerDetails = passengerDetails
    }

    public var updateTrainNumberCalled = false
    public var trainNumber: String?
    public func update(trainNumber: String?) {
        updateTrainNumberCalled = true
        self.trainNumber = trainNumber
    }

    public var updateFlightNumberCalled = false
    public var flightNumber: String?
    public func update(flightNumber: String?) {
        updateFlightNumberCalled = true
        self.flightNumber = flightNumber
    }

    public var updateCommentCalled = false
    public var comment: String?
    public func update(comment: String?) {
        updateCommentCalled = true
        self.comment = comment
    }
}
