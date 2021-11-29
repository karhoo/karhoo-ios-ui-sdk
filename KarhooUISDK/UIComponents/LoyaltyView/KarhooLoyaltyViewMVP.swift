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
    func set(mode: LoyaltyMode, withSubtitle text: String)
    func set(request: LoyaltyViewRequest)
    func set(delegate: LoyaltyViewDelegate)
    func updateLoyaltyFeatures(showEarnRelatedUI: Bool, showBurnRelatedUI: Bool)
    func showError(withMessage message: String)
}

protocol LoyaltyViewDelegate: AnyObject {
    func didToggleLoyaltyMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}

protocol LoyaltyPresenter {
    var delegate: LoyaltyViewDelegate? { get set }
    func getCurrentMode() -> LoyaltyMode
    func set(request: LoyaltyViewRequest)
    func updateEarnedPoints()
    func updateBurnedPoints()
    func updateLoyaltyMode(with mode: LoyaltyMode)
}

enum LoyaltyMode {
    case none, earn, burn
}
