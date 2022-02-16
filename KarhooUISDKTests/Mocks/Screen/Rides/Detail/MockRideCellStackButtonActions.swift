//
//  MockRideCellStackButtonActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

import KarhooSDK

final class MockRideCellStackButtonActions: RideCellStackButtonActions {

    var trackTripCalled = false
    func track(_ trip: TripInfo) {
        trackTripCalled = true
    }

    private(set) var contactFleetCalled: TripInfo?
    func contactFleet(_ trip: TripInfo, number: String) {
        contactFleetCalled = trip
    }

    private(set) var contactDriverCalled: TripInfo?
    func contactDriver(_ trip: TripInfo, number: String) {
        contactDriverCalled = trip
    }
}
