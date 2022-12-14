//
//  MockTripScreen.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

final public class MockTripView: MockBaseViewController, TripView {

    public func currentTrip() -> TripInfo {
        return trip!
    }

    public var trip: TripInfo?
    public func set(trip: TripInfo) {
        self.trip = trip
    }

    public var userMovedMapCalled = false
    public func userMovedMap() {
        userMovedMapCalled = true
    }
    
    public var theLocateButtonHidden: Bool?
    public func set(locateButtonHidden: Bool) {
        theLocateButtonHidden = locateButtonHidden
    }

    public var focusOnUserLocationCalled = false
    public func focusOnUserLocation() {
        focusOnUserLocationCalled = true
    }

    public var setTripStatusCalled = false
    public func set(tripStatus: String?) {
        setTripStatusCalled = true
    }

    public var showLoadingCalled = false
    public func showLoading() {
        showLoadingCalled = true
    }
    
    public var hideLoadingCalled = false
    public func hideLoading() {
        hideLoadingCalled = true
    }
    
    public var setAddressBarCalled = false
    public func setAddressBar(with trip: TripInfo) {
        setAddressBarCalled = true
    }
    
    public var plotPinsOnMapCalled = false
    public func plotPinsOnMap() {
        plotPinsOnMapCalled = true
    }

    public var focusMapOnAllPOICalled = false
    public func focusMapOnAllPOI() {
        focusMapOnAllPOICalled = true
    }
    
    public var focusMapOnRouteCalled = false
    public func focusMapOnRoute() {
        focusMapOnRouteCalled = true
    }
    
    public var focusMapOnDriverAndPickupCalled = false
    public func focusMapOnDriverAndPickup() {
        focusMapOnDriverAndPickupCalled = true
    }
    
    public var focusMapOnDriverCalled = false
    public func focusMapOnDriver() {
        focusMapOnDriverCalled = true
    }
    
    public func update(driverLocation: CLLocation) {}

    public var userMarkerVisibleSet = false
    public func set(userMarkerVisible: Bool) {
        userMarkerVisibleSet = userMarkerVisible
    }

    public var showNoLocationPermissionsPopUpCalled = false
    public func showNoLocationPermissionsPopUp() {
        showNoLocationPermissionsPopUpCalled = true
    }

    public var focusMapOnPickupCalled = false
    public func focusMapOnPickup() {
        focusMapOnDriverAndPickupCalled = true
    }
}
