//
//  MockAddressBarView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import KarhooSDK
import UIKit
@testable import KarhooUISDK

public class MockBaseView: UIView, BaseView {

    public var parentViewController: UIViewController? {
        return MockViewController()
    }
}

final public class MockAddressBarView: MockBaseView, AddressBarView {

    public var prebookDateStringSet: String?
    public var prebookTimeStringSet: String?
    public func set(prebookDate: String, prebookTime: String) {
        prebookDateStringSet = prebookDate
        prebookTimeStringSet = prebookTime
    }

    public var defaultPrebookStateSet = false
    public func setDefaultPrebookState() {
        defaultPrebookStateSet = true
    }

    public var destinationSetStateCalled = false
     public func destinationSetState(disableClearButton: Bool) {
        destinationSetStateCalled = true
    }
    
    public var destinationNotSetStateCalled = false
    public func destinationNotSetState() {
        destinationNotSetStateCalled = true
    }

    public var pickupSetStateCalled = false
    public func pickupSetState() {
        pickupSetStateCalled = true
    }

    public var pickupNotSetStateCalled = false
    public func pickupNotSetState() {
        pickupNotSetStateCalled = true
    }

    public var showPickupSpinnerCalled = false
    public func showPickupSpinner() {
        showPickupSpinnerCalled = true
    }

    public var hidePickupSpinnerCalled = false
    public func hidePickupSpinner() {
        hidePickupSpinnerCalled = true
    }

    public var pickupDisplayAddressSet: String?
    public var setPickupCalled = false
    public func set(pickupDisplayAddress: String?) {
        pickupDisplayAddressSet = pickupDisplayAddress
        setPickupCalled = true
    }

    public var destinationDisplayAddressSet: String?
    public var setDestinationCalled = false
    public func set(destinationDisplayAddress: String?) {
        destinationDisplayAddressSet = destinationDisplayAddress
        setDestinationCalled = true
    }

    public var setDisplayTripStateCalled = false
    public func setDisplayTripState() {
        setDisplayTripStateCalled = true
    }
}

public class MockLocationPermissionProvider: LocationPermissionProvider {
    public init() {}

    public var isLocationPermissionGrantedReturn = true
    public var isLocationPermissionGranted: Bool { isLocationPermissionGrantedReturn }
}
