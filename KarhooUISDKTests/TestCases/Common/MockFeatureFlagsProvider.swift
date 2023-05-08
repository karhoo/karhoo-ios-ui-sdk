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
    func get() -> FeatureFlags {
        return FeatureFlags(adyenAvailable: true, newRidePlaningScreen: false)
    }
}
