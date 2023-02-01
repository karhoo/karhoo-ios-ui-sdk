//
//  LoyaltyUIModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

/// Structure containing all required data for UI to setup and prepare for user interactions
struct LoyaltyUIModel {
    var loyaltyId: String
    var currency: String
    var tripAmount: Double
    var canEarn: Bool
    var canBurn: Bool
    var burnAmount: Int
    var earnAmount: Int
    var balance: Int

    init(
        loyaltyId: String,
        currency: String,
        tripAmount: Double,
        canEarn: Bool = false,
        canBurn: Bool = false,
        burnAmount: Int = 0,
        earnAmount: Int = 0,
        balance: Int = 0
    ) {
        self.loyaltyId = loyaltyId
        self.currency = currency
        self.tripAmount = tripAmount
        self.canEarn = canEarn
        self.canBurn = canBurn
        self.burnAmount = burnAmount
        self.earnAmount = earnAmount
        self.balance = balance
    }
    
    init(request: LoyaltyViewDataModel) {
        self.loyaltyId = request.loyaltyId
        self.currency = request.currency
        self.tripAmount = request.tripAmount
        self.canEarn = false
        self.canBurn = false
        self.burnAmount = 0
        self.earnAmount = 0
        self.balance = 0
    }
}
