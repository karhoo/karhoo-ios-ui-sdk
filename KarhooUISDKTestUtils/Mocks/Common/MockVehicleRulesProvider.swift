//
//  MockVehicleRulesProvider.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

public class MockVehicleRulesProvider: VehicleRulesProvider {
    private(set) public var updateCalled = false
    public func update() {
        updateCalled = true
    }

    public var quoteVehicleImageRule: VehicleImageRule?
    public var getRuleCalled = false
    public func getRule(for quote: Quote, completion: @escaping (VehicleImageRule?) -> Void) {
        getRuleCalled = true
        completion(quoteVehicleImageRule)
    }

    public func setRule(quote: Quote, rule: VehicleImageRule?) {
        quoteVehicleImageRule = rule
    }
}

