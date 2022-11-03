//
//  MockRideCellStackButtonActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

import KarhooSDK

final public class MockRideCellStackButtonActions: RideCellStackButtonActions {

    public var trackTripCalled = false
    public func track(_ trip: TripInfo) {
        trackTripCalled = true
    }

    public var contactFleetCalled: TripInfo?
    public func contactFleet(_ trip: TripInfo, number: String) {
        contactFleetCalled = trip
    }

    public var contactDriverCalled: TripInfo?
    public func contactDriver(_ trip: TripInfo, number: String) {
        contactDriverCalled = trip
    }
}
