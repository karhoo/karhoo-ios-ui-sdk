//
//  MockLoyaltyViewDelegate.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockLoyaltyViewDelegate: LoyaltyViewDelegate {
    
    private(set)var didCallToggleLoyaltyMode = false
    func didToggleLoyaltyMode(newValue: LoyaltyMode) {
        didCallToggleLoyaltyMode = true
    }
    
    private(set)var didCallStartLoading = false
    func didStartLoading() {
        didCallStartLoading = true
    }
    
    private(set)var didCallEndLoading = false
    func didEndLoading() {
        didCallEndLoading = true
    }  
}
