//
//  MockMapViewActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
@testable import KarhooUISDK

public class MockMapViewActions: MapViewActions {
    public init() {}

    public var gestureDetectedCalled = false
    public func mapGestureDetected() {
        gestureDetectedCalled = true
    }

    public func userStartedMovingTheMap() {}
    public func userStoppedMovingTheMap(center: CLLocation?) {}
}
