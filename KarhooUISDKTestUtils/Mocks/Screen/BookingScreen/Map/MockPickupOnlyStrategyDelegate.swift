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

final public class MockPickupOnlyStrategyDelegate: PickupOnlyStrategyDelegate {
    public init() {}

    public var locationDetailsSetFromMap: LocationInfo?
    public func setFromMap(pickup: LocationInfo?) {
        locationDetailsSetFromMap = pickup
    }

    public var pickupFailedToSetCalled = false
    public var pickupFailedError: KarhooError?
    public func pickupFailedToSetFromMap(error: KarhooError?) {
        pickupFailedToSetCalled = true
        pickupFailedError = error
    }
}
