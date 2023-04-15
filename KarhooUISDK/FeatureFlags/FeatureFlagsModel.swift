//
//  FeatureFlagsModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct FeatureFlag: Codable {
    var adyenAvailable: Bool
    var newRidePlaningScreen: Bool
    
    static var defaultFlags: FeatureFlag {
        FeatureFlag(adyenAvailable: false, newRidePlaningScreen: true)
    }
}

struct FeatureFlagsModel: Codable {
    var version: String
    var flags: FeatureFlag

}
