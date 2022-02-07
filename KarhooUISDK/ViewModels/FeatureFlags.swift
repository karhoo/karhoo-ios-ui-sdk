//
//  FeatureFlags.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 07.12.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct LoyaltyFeatureFlags {
    static let loyaltyEnabled = true
    static let loyaltyCanEarn = loyaltyEnabled && false
    static let loyaltyCanBurn = loyaltyEnabled && true
}
