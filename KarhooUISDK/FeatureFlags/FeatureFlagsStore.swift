//
//  FeatureFlagsStore.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol FeatureFlagsStore {
    func save(_ model: FeatureFlagsModel)
    func get() -> FeatureFlagsModel?
}

final class KarhooFeatureFlagsStore: FeatureFlagsStore {
    
    private let storeKey = "KarhooUISDKFeatureFlags"
    private var userDefaults: UserDefaults {
        .standard
    }
    
    
    func save(_ model: FeatureFlagsModel) {
        guard let encodedModel = try? JSONEncoder().encode(model) else {
            assertionFailure()
            return
        }
        userDefaults.set(encodedModel, forKey: storeKey)
    }
    
    func get() -> FeatureFlagsModel? {
        guard let data = userDefaults.data(forKey: storeKey),
                let flags = try? JSONDecoder().decode(FeatureFlagsModel.self, from: data) else {
            return nil
        }
        return flags
    }
}
