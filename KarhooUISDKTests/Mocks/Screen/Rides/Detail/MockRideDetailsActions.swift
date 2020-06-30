//
//  MockRideDetailsActions.swift
//  KarhooTests
//
//  Created by Jeevan on 01/10/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final class MockRideDetailsActions: RideDetailsActions {

    private(set) var trackTripCalled = false
    func trackTrip(_ trip: TripInfo) {
        trackTripCalled = true
    }

    private(set) var rebookTripCalled = false
    func rebookTrip(_ trip: TripInfo) {
        rebookTripCalled = true
    }

    private(set) var tripCancelledCalled = false
    func didCancelTrip(_ trip: TripInfo) {
        tripCancelledCalled = true
    }
}
