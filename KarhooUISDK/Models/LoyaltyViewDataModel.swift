//
//  LoyaltyViewDataModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

public struct KarhooBasicLoyaltyInfo: BookingConfirmationLoyaltyInfo {
    var shouldShowLoyalty: Bool
    var loyaltyPoints: Int
    var loyaltyMode: LoyaltyMode
}

extension KarhooBasicLoyaltyInfo {
    static func loyaltyDisabled() -> KarhooBasicLoyaltyInfo {
        KarhooBasicLoyaltyInfo(shouldShowLoyalty: false, loyaltyPoints: 0, loyaltyMode: .none)
    }
}
