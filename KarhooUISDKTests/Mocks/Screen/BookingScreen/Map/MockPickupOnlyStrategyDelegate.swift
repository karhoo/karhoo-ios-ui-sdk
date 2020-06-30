//
//  MockPickupOnlyStrategyDelegate.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockPickupOnlyStrategyDelegate: PickupOnlyStrategyDelegate {

    var locationDetailsSetFromMap: LocationInfo?
    func setFromMap(pickup: LocationInfo?) {
        locationDetailsSetFromMap = pickup
    }

    var pickupFailedToSetCalled = false
    var pickupFailedError: KarhooError?
    func pickupFailedToSetFromMap(error: KarhooError?) {
        pickupFailedToSetCalled = true
        pickupFailedError = error
    }
}
