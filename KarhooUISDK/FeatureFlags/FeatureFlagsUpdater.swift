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
    
    func start(){
        let jsonUrl = "https://raw.githubusercontent.com/karhoo/karhoo-ios-ui-sdk/MOB-4757-feature-flag-file/KarhooUISDK/FeatureFlags/feature_flag.json"

        let url = URL(string: jsonUrl)!
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            if let data {
                do {
                    let flagSets = try decoder.decode([FeatureFlagsModel].self, from: data)
                    self?.handleFlagSets(flagSets)
                } catch {
                    // TODO: Add error to analytics
                }
            } else if let error = error {
                // TODO: Add error to analytics
            }
        }
        task.resume()
    }
    
    private func handleFlagSets(_ sets: [FeatureFlagsModel]) {
        if let selectedSet = selectProperSet(from: sets) {
            storeFeatureFlag(selectedSet.flags)
        }
    }
    
    private func selectProperSet(from sets:  [FeatureFlagsModel]) -> FeatureFlagsModel? {
        let currentSdkVersion = "1.12.0"
        let sortedSets = sets.sorted(by: {$0.version.compare($1.version, options: .numeric) == .orderedAscending})
        for set in sortedSets {
            // if ComparasionResult is .orderedSame or .orderedAscending
            if set.version.compare(currentSdkVersion, options: .numeric) != .orderedDescending {
                return set
            }
        }
        return nil
    }
    
    private func storeFeatureFlag(_ flag: FeatureFlag) {
        
    }
}
