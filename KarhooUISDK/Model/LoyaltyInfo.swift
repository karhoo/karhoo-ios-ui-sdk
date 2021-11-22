//
//  LoyaltyInfo.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 22.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public struct LoyaltyInfo: KarhooCodableModel {
    var canEarn: Bool
    var canBurn: Bool
    
    public init(canEarn: Bool, canBurn: Bool) {
        self.canEarn = canEarn
        self.canBurn = canBurn
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.canEarn = try container.decode(Bool.self, forKey: .canEarn)
        self.canBurn = try container.decode(Bool.self, forKey: .canBurn)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(canEarn, forKey: .canEarn)
        try container.encode(canBurn, forKey: .canBurn)
    }
    
    enum CodingKeys: String, CodingKey {
        case canEarn = "can_earn"
        case canBurn = "can_burn"
    }
}
