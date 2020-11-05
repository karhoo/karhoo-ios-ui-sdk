//
//  MockTripSummaryScreen.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockTripSummaryView: TripSummaryView {

    private(set) var tripSet: TripInfo?
    func set(trip: TripInfo) {
        tripSet = trip
    }

    private(set) var dismissViewCalled = false
    func dismissView() {
        dismissViewCalled = true
    }
}
