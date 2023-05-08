//
//  FeatureFlagsModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct FeatureFlags: Codable {
    var adyenAvailable: Bool?
    var newRidePlaningScreen: Bool?
    var loyaltyEnabled: Bool { true }
    var loyaltyCanEarn: Bool { loyaltyEnabled && true }
    var loyaltyCanBurn: Bool { loyaltyEnabled && true }
}

struct FeatureFlagsModel: Codable {
    var version: String
    var flags: FeatureFlags
}
