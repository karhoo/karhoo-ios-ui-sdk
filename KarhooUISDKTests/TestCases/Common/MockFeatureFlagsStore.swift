//
//  MockFeatureFlagsStore.swift
//  KarhooUISDKTests
//
//  Created by Bartlomiej Sopala on 16/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockFeatureFlagsStore: FeatureFlagsStore {
    
    var savedModel: FeatureFlagsModel?
    func save(_ model: FeatureFlagsModel) {
        savedModel = model
    }
    
    func get() -> FeatureFlagsModel? {
        return savedModel
    }
}
