//
//  MockPickupOnlyStrategy.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockPickupOnlyStrategy: MockBookingMapStrategy, PickupOnlyStrategyProtocol {
    public override init() {}

    public var pickupOnlyStrategyDelegateSet: PickupOnlyStrategyDelegate?
    public func set(delegate: PickupOnlyStrategyDelegate?) {
        self.pickupOnlyStrategyDelegateSet = delegate
    }
}
