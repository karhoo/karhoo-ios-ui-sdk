//
//  MockLoyaltyView.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final class MockLoyaltyView: LoyaltyView {
    
    private(set)var didCallGetUpdateLoyaltyFeatures = false
    func updateLoyaltyFeatures(showEarnRelatedUI: Bool, showBurnRelatedUI: Bool) {
        didCallGetUpdateLoyaltyFeatures = true
    }
    
    private(set)var didCallGetCurrentMode = false
    func getCurrentMode() -> LoyaltyMode {
        didCallGetCurrentMode = true
        return .none
    }
    
    private(set)var didCallSetLoyaltyMode = false
    func set(mode: LoyaltyMode, withSubtitle text: String) {
        didCallSetLoyaltyMode = true
    }
    
    private(set)var didSetRequest = false
    func set(dataModel: LoyaltyViewDataModel) {
        didSetRequest = true
    }
    
    private(set)var didSetDelegate = false
    func set(delegate: LoyaltyViewDelegate) {
        didSetDelegate = true
    }
    
    private(set)var didShowError = false
    func showError(withMessage message: String) {
        didShowError = true
    }
}
