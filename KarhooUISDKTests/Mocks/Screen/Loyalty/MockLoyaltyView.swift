//
//  MockLoyaltyView.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK
@testable import KarhooUISDK

final class MockLoyaltyView: LoyaltyView {
    var getLoyaltyNonceCalled = false
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        getLoyaltyNonceCalled = true
        let nonce = LoyaltyNonce(loyaltyNonce: TestUtil.getRandomString())
        completion(Result.success(result: nonce))
    }
    
    private(set)var hasErrorsCalled = false
    func hasError() -> Bool {
        hasErrorsCalled = true
        return false
    }
    
    private(set)var hasErrorsCalled = false
    func hasError() -> Bool {
        hasErrorsCalled = true
        return false
    }
    
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
