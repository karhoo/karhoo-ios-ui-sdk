//
//  FeatureFlagsUpdater.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 15/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class FeatureFlagsUpdater {
    
    private let currentSdkVersion: String
    private let featureFlagsStore: FeatureFlagsStore
    
    init(
        currentSdkVersion: String,
        featureFlagsStore: FeatureFlagsStore = KarhooFeatureFlagsStore()
    ) {
        self.currentSdkVersion = currentSdkVersion
        self.featureFlagsStore = featureFlagsStore
    }
    
    func update() {
        let jsonUrl = "https://raw.githubusercontent.com/karhoo/karhoo-ios-ui-sdk/MOB-4757-feature-flag-file/KarhooUISDK/FeatureFlags/feature_flag.json"

        let url = URL(string: jsonUrl)!
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            if let data {
                do {
                    let flagSets = try decoder.decode([FeatureFlagsModel].self, from: data)
                    self?.handleFlagSets(flagSets)
                } catch {
                    // TODO: Add error to analytics
                }
            } else if let error {
                // TODO: Add error to analytics
            }
        }
        task.resume()
    }
    
    func handleFlagSets(_ sets: [FeatureFlagsModel]) {
        if let selectedSet = selectProperSet(forVersion: currentSdkVersion, from: sets) {
            storeFeatureFlag(selectedSet)
        }
    }
    
    private func selectProperSet(forVersion version: String, from sets: [FeatureFlagsModel]) -> FeatureFlagsModel? {
        // sort versions descending
        let sortedSets = sets.sorted(by: {$0.version.compare($1.version, options: .numeric) == .orderedDescending})
        // look for first equal or smaller
        for set in sortedSets where set.version.compare(currentSdkVersion, options: .numeric) != .orderedDescending {
            return set
        }
        return nil
    }
    
    private func storeFeatureFlag(_ model: FeatureFlagsModel) {
        featureFlagsStore.save(model)
    }
}
