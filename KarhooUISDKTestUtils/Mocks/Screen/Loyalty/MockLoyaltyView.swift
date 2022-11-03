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

final public class MockLoyaltyView: LoyaltyView {
    private(set)var mode: LoyaltyMode?
    private(set)var earnText: String?
    private(set)var burnText: String?
    private(set)var errorMessage: String?
    private(set)var earnOn: Bool?
    private(set)var burnOn: Bool?
    private(set)var didCallSetLoyaltyMode = false
    private(set)var didShowError = false
    private(set)var didCallGetCurrentMode = false
    private(set)var didSetDelegate = false
    private(set)var didCallGetUpdateLoyaltyFeatures = false
    
    public var delegate: LoyaltyViewDelegate? {
        didSet {
            didSetDelegate = true
        }
    }
    
    public var currentMode: LoyaltyMode = .none {
        didSet {
            didCallGetCurrentMode = true
        }
    }
    
    public var getLoyaltyNonceCalled = false
    public func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        getLoyaltyNonceCalled = true
        let nonce = LoyaltyNonce(loyaltyNonce: TestUtil.getRandomString())
        completion(Result.success(result: nonce))
    }
    
    private(set)var hasErrorsCalled = false
    public func hasError() -> Bool {
        hasErrorsCalled = true
        return false
    }

    private(set)var didSetRequest = false
    public func set(dataModel: LoyaltyViewDataModel, quoteId: String) {
        didSetRequest = true
    }
}

extension MockLoyaltyView: LoyaltyPresenterDelegate {
    public func updateWith(mode: LoyaltyMode, earnSubtitle: String?, burnSubtitle: String?, errorMessage: String?) {
        self.mode = mode
        self.earnText = earnSubtitle
        self.burnText = burnSubtitle
        self.errorMessage = errorMessage
        didCallSetLoyaltyMode = true
    }
    
    public func togglefeatures(earnOn: Bool, burnOn: Bool) {
        self.earnOn = earnOn
        self.burnOn = burnOn
        didCallGetUpdateLoyaltyFeatures = true
    }
}
