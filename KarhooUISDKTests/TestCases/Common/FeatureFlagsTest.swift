//
//  FeatureFlagsTest.swift
//  KarhooUISDKTests
//
//  Created by Bartlomiej Sopala on 16/04/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import Foundation
import KarhooUISDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class FeatureFlagsTest: KarhooTestCase {
    
    func testVersionFromList() {
        performTestForVersions(current: "2.0.1", expected: "2.0.1")
    }
    
    func testVersionMajorBetweenOther() {
        performTestForVersions(current: "7.0.1", expected: "4.0.0")
    }
    
    func testVersionMinorBetweenOther() {
        performTestForVersions(current: "2.1.2", expected: "2.0.1")
    }
    
    func testVersionGraterThanEverything() {
        performTestForVersions(current: "100.0.0", expected: "11.1.0")
    }
    
    func testVersionLowerThanEverything() {
        performTestForVersions(current: "1.0.0", expected: nil)
    }
    
    private func getFeatureFlagsSet() -> [FeatureFlagsModel] {
        return [
            getFeatureFlagsModel(withVersion: "2.1.4"),
            getFeatureFlagsModel(withVersion: "2.0.0"),
            getFeatureFlagsModel(withVersion: "11.1.0"),
            getFeatureFlagsModel(withVersion: "2.0.1"),
            getFeatureFlagsModel(withVersion: "2.1.10"),
            getFeatureFlagsModel(withVersion: "1.1.0"),
            getFeatureFlagsModel(withVersion: "4.0.0"),
        ]
        //            CORRECT ORDER:
        //            "1.1.0"
        //            "2.0.0"
        //            "2.0.1"
        //            "2.2.4"
        //            "2.1.10"
        //            "4.0.0"
        //            "11.1.0"
    }
    private func getFeatureFlagsModel(withVersion version: String) -> FeatureFlagsModel {
        return FeatureFlagsModel(version: version, flags: FeatureFlag(adyenAvailable: true, newRidePlaningScreen: true))
    }
    
    private func performTestForVersions(current: String, expected: String?) {
        let mockFeatureFlagsStore = MockFeatureFlagsStore()
        let featureFlagsUpdater = FeatureFlagsUpdater (
            currentSdkVersion: current,
            featureFlagsStore: mockFeatureFlagsStore
        )
        featureFlagsUpdater.handleFlagSets(getFeatureFlagsSet())
        XCTAssertEqual(expected, mockFeatureFlagsStore.savedModel?.version)
    }
    
    
}
