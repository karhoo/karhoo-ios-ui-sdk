//
//  KarhooFeatureFlagProvider.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol FeatureFlagProvider {
    func get() -> FeatureFlagsModel?
}

class KarhooFeatureFlagProvider: FeatureFlagProvider {
    
    private let store: FeatureFlagsStore
    
    init(store: FeatureFlagsStore = KarhooFeatureFlagsStore()) {
        self.store = store
    }
    
    func get() -> FeatureFlagsModel? {
        store.get()
    }
}
