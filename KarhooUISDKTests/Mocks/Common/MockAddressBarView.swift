//
//  MockAddressBarView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import KarhooSDK

@testable import KarhooUISDK

class MockBaseView: UIView, BaseView {

    var parentViewController: UIViewController? {
        return MockViewController()
    }
}

final class MockAddressBarView: MockBaseView, AddressBarView {

    var prebookDateStringSet: String?
    var prebookTimeStringSet: String?
    func set(prebookDate: String, prebookTime: String) {
        prebookDateStringSet = prebookDate
        prebookTimeStringSet = prebookTime
    }

    var defaultPrebookStateSet = false
    func setDefaultPrebookState() {
        defaultPrebookStateSet = true
    }

    var destinationSetStateCalled = false
     func destinationSetState(disableClearButton: Bool) {
        destinationSetStateCalled = true
    }
    
    var destinationNotSetStateCalled = false
    func destinationNotSetState() {
        destinationNotSetStateCalled = true
    }

    var pickupSetStateCalled = false
    func pickupSetState() {
        pickupSetStateCalled = true
    }

    var pickupNotSetStateCalled = false
    func pickupNotSetState() {
        pickupNotSetStateCalled = true
    }

    var showPickupSpinnerCalled = false
    func showPickupSpinner() {
        showPickupSpinnerCalled = true
    }

    var hidePickupSpinnerCalled = false
    func hidePickupSpinner() {
        hidePickupSpinnerCalled = true
    }

    var pickupDisplayAddressSet: String?
    var setPickupCalled = false
    func set(pickupDisplayAddress: String?) {
        pickupDisplayAddressSet = pickupDisplayAddress
        setPickupCalled = true
    }

    var destinationDisplayAddressSet: String?
    var setDestinationCalled = false
    func set(destinationDisplayAddress: String?) {
        destinationDisplayAddressSet = destinationDisplayAddress
        setDestinationCalled = true
    }

    var setDisplayJourneyStateCalled = false
    func setDisplayJourneyState() {
        setDisplayJourneyStateCalled = true
    }
}
