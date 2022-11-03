//
//  MockMapViewDelegate.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
@testable import KarhooUISDK

class MockMapViewActions: MapViewActions {

    private(set) var gestureDetectedCalled = false
    func mapGestureDetected() {
        gestureDetectedCalled = true
    }

    func userStartedMovingTheMap() {}
    func userStoppedMovingTheMap(center: CLLocation?) {}
}
