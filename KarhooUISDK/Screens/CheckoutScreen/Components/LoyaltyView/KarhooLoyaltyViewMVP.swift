//
//  KarhooLoyaltyViewMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol LoyaltyView: AnyObject {
    func getCurrentMode() -> LoyaltyMode
    func set(mode: LoyaltyMode)
    func showError(_ show: Bool)
    func set(earnAmount: Int)
    func set(burnAmount: Int)
}

protocol LoyaltyViewDelegate {
    func didToggleLoyaltyMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}

protocol LoyaltyPresenter {
    var delegate: LoyaltyViewDelegate? { get set }
    func updateEarnedPoints()
    func updateBurnedPoints()
    func updateLoyaltyMode(with mode: LoyaltyMode)
}

enum LoyaltyMode {
    case burn, earn
}
