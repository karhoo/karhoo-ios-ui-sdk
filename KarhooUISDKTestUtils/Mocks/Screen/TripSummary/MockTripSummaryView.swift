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

final public class MockTripSummaryView: TripSummaryView {

    public var tripSet: TripInfo?
    public func set(trip: TripInfo) {
        tripSet = trip
    }

    public var dismissViewCalled = false
    public func dismissView() {
        dismissViewCalled = true
    }
}
