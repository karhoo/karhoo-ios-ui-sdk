//
//  LoyaltyViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct LoyaltyViewModel {
    var loyaltyId: String
    var currency: String
    var tripAmount: Double
    var canEarn: Bool
    var canBurn: Bool
    var burnAmount: Int
    var earnAmount: Int
    var balance: Int
    
    init(loyaltyId: String, currency: String, tripAmount: Double) {
        self.loyaltyId = loyaltyId
        self.currency = currency
        self.tripAmount = tripAmount
        self.canEarn = false
        self.canBurn = false
        self.burnAmount = 0
        self.earnAmount = 0
        self.balance = 0
    }
    
    init(request: LoyaltyViewRequest) {
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
