//
//  MockFeatureFlagsProvider.swift
//  KarhooUISDKTests
//
//  Created by Bartlomiej Sopala on 28/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockFeatureFlagProvider: FeatureFlagProvider {
    func getRemoteFlags() -> FeatureFlagsModel? {
        return FeatureFlagsModel(version: "1.12.0", flags: FeatureFlags(adyenAvailable: true, newRidePlaningScreen: false))
    }
    
    func getLoyaltyFlags() -> LoyaltyFeatureFlags {
        return LoyaltyFeatureFlags(loyaltyEnabled: true, loyaltyCanEarn: true, loyaltyCanBurn: true)
    }
}
