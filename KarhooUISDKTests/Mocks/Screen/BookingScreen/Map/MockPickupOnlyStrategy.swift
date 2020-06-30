//
//  MockPickupOnlyStrategy.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockPickupOnlyStrategy: MockBookingMapStrategy, PickupOnlyStrategyProtocol {

    private(set) var pickupOnlyStrategyDelegateSet: PickupOnlyStrategyDelegate?
    func set(delegate: PickupOnlyStrategyDelegate?) {
        self.pickupOnlyStrategyDelegateSet = delegate
    }
}
