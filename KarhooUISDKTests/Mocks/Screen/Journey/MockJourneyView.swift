//
//  MockJourneyScreen.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

final class MockJourneyView: MockBaseViewController, JourneyView {

    func currentTrip() -> TripInfo {
        return trip!
    }

    private(set) var trip: TripInfo?
    func set(trip: TripInfo) {
        self.trip = trip
    }

    private(set) var userMovedMapCalled = false
    func userMovedMap() {
        userMovedMapCalled = true
    }
    
    private(set) var theLocateButtonHidden: Bool?
    func set(locateButtonHidden: Bool) {
        theLocateButtonHidden = locateButtonHidden
    }
    
    private(set) var focusMapOnDriverAndDestinationCalled = false
    func focusMapOnDriverAndDestination() {
        focusMapOnDriverAndDestinationCalled = true
    }

    private(set) var setTripStatusCalled = false
    func set(tripStatus: String?) {
        setTripStatusCalled = true
    }

    private(set) var showLoadingCalled = false
    func showLoading() {
        showLoadingCalled = true
    }
    
    private(set) var hideLoadingCalled = false
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    private(set) var setAddressBarCalled = false
    func setAddressBar(with trip: TripInfo) {
        setAddressBarCalled = true
    }
    
    private(set) var plotPinsOnMapCalled = true
    func plotPinsOnMap() {
        plotPinsOnMapCalled = false
    }
    
    private(set) var focusMapOnRouteCalled = false
    func focusMapOnRoute() {
        focusMapOnRouteCalled = true
    }
    
    private(set) var focusMapOnDriverAndPickupCalled = false
    func focusMapOnDriverAndPickup() {
        focusMapOnDriverAndPickupCalled = true
    }
    
    private(set) var focusMapOnDriverCalled = false
    func focusMapOnDriver() {
        focusMapOnDriverCalled = true
    }
    
    func update(driverLocation: CLLocation) {}

    private(set) var userMarkerVisibleSet = false
    func set(userMarkerVisible: Bool) {
        userMarkerVisibleSet = userMarkerVisible
    }
}
