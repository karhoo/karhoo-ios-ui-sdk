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
    func save(_ rules: VehicleImageRules)
    func get() -> VehicleImageRules?
}

final class KarhooVehicleRulesStore: VehicleRulesStore {

    private let storeKey = "VehicleImageRules"
    private var userDefaults: UserDefaults {
        .standard
    }
    
    func save(_ rules: VehicleImageRules) {
        guard let encodedRules = try? JSONEncoder().encode(rules) else {
            assertionFailure()
            return
        }
        userDefaults.set(encodedRules, forKey: storeKey)
    }
    
    func get() -> VehicleImageRules? {
        guard let data = userDefaults.data(forKey: storeKey),
                let rules = try? JSONDecoder().decode(VehicleImageRules.self, from: data) else {
            return nil
        }
        return rules
    }
}
