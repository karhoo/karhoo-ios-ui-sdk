//
//  MockBookingMapStrategy.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

public class MockBookingMapStrategy: BookingMapStrategy {

    public func functionsCalled() -> Bool {
        return locateUserCalled
    }

    public var loadMapCalled = false
    public var mapLoaded: MapView?
    public func load(map: MapView?, reverseGeolocate: Bool, onLocationPermissionDenied: (() -> Void)?) {
        loadMapCalled = true
        mapLoaded = map
    }

    public var startCalled = false
    public var startJourneyDetails: JourneyDetails?
    public func start(journeyDetails: JourneyDetails?) {
        startCalled = true
        startJourneyDetails = journeyDetails
    }

    public var locateUserCalled = false
    public func focusMap() {
        locateUserCalled = true
    }

    public var stopCalled = false
    public func stop() {
        stopCalled = true
    }

    public func reset() {
        loadMapCalled = false
        locateUserCalled = false
        startCalled = false
        stopCalled = false
    }

    public var detailsChangedCalled = false
    public var detailsChangedTo: JourneyDetails?
    public func changed(journeyDetails: JourneyDetails?) {
        detailsChangedCalled = true
        detailsChangedTo = journeyDetails
    }

    public var appDidBecomeActiveCalled = false
    public func appDidBecomeActive() {
        appDidBecomeActiveCalled = true
    }
}
