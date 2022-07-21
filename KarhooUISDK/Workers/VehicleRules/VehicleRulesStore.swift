//
//  VehicleRulesStore.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol VehicleRulesStore: AnyObject {
    func save(_ rules: VehicleRules)
    func get() -> VehicleRules?
}

final class KarhooVehicleRulesStore: VehicleRulesStore {

    private let storeKey = "vahicleRules"
    private var userDefaults: UserDefaults {
        .standard
    }
    
    func save(_ rules: VehicleRules) {
        guard let encodedRules = try? JSONEncoder().encode(rules) else {
            assertionFailure()
            return
        }
        userDefaults.set(encodedRules, forKey: storeKey)
    }
    
    func get() -> VehicleRules? {
        guard let data = userDefaults.data(forKey: storeKey),
                let rules = try? JSONDecoder().decode(VehicleRules.self, from: data) else {
            return nil
        }
        return rules
    }
}
