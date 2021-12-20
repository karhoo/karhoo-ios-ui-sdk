//
//  KarhooLoyaltyViewMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol LoyaltyView: AnyObject {
    func getCurrentMode() -> LoyaltyMode
    func set(mode: LoyaltyMode, withSubtitle text: String)
    func set(dataModel: LoyaltyViewDataModel)
    func set(delegate: LoyaltyViewDelegate)
    func updateLoyaltyFeatures(showEarnRelatedUI: Bool, showBurnRelatedUI: Bool)
    func showError(withMessage message: String)
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
}

protocol LoyaltyViewDelegate: AnyObject {
    func didToggleLoyaltyMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}

protocol LoyaltyPresenter {
    var delegate: LoyaltyViewDelegate? { get set }
    func getCurrentMode() -> LoyaltyMode
    func set(dataModel: LoyaltyViewDataModel)
    func updateEarnedPoints()
    func updateBurnedPoints()
    func updateLoyaltyMode(with mode: LoyaltyMode)
    func set(status: LoyaltyStatus)
    func getLoyaltyPreAuthNonce(completion: @escaping  (Result<LoyaltyNonce>) -> Void)
}

enum LoyaltyMode {
    case none, earn, burn
}
