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

}
