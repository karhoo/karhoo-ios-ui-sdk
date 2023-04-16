//
//  FeatureFlagsSaver.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol FeatureFlagsSaver {
    func save(_ model: FeatureFlagsModel)
}

class KarhooFeatureFlagsSaver: FeatureFlagsSaver {
    func save(_ model: FeatureFlagsModel) {
        print("SAVED")
    }
}
