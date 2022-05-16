//
//  MockBookingMapStrategy.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockBookingMapStrategy: BookingMapStrategy {

    func functionsCalled() -> Bool {
        return locateUserCalled
    }

    var loadMapCalled = false
    var mapLoaded: MapView?
    func load(map: MapView?, reverseGeolocate: Bool) {
        loadMapCalled = true
        mapLoaded = map
    }

    var startCalled = false
    var startJourneyDetails: JourneyDetails?
    func start(journeyDetails: JourneyDetails?) {
        startCalled = true
        startJourneyDetails = journeyDetails
    }

    var locateUserCalled = false
    func focusMap() {
        locateUserCalled = true
    }

    var stopCalled = false
    func stop() {
        stopCalled = true
    }

    func reset() {
        loadMapCalled = false
        locateUserCalled = false
        startCalled = false
        stopCalled = false
    }

    var detailsChangedCalled = false
    var detailsChangedTo: JourneyDetails?
    func changed(journeyDetails: JourneyDetails?) {
        detailsChangedCalled = true
        detailsChangedTo = journeyDetails
    }

    private(set) var appDidBecomeActiveCalled = false
    func appDidBecomeActive() {
        appDidBecomeActiveCalled = true
    }
}
