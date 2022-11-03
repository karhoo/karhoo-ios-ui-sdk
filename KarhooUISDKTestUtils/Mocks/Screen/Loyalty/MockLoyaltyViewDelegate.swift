//
//  MockLoyaltyViewDelegate.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockLoyaltyViewDelegate: LoyaltyViewDelegate {
    private(set)var didCallToggleLoyaltyMode = false
    public func didChangeMode(newValue: LoyaltyMode) {
        didCallToggleLoyaltyMode = true
    }
    
    private(set)var didCallStartLoading = false
    public func didStartLoading() {
        didCallStartLoading = true
    }
    
    private(set)var didCallEndLoading = false
    public func didEndLoading() {
        didCallEndLoading = true
    }  
}
