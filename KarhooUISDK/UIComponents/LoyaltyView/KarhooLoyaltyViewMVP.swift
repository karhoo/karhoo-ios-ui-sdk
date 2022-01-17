//
//  KarhooLoyaltyViewMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

protocol LoyaltyView: AnyObject {
    func getCurrentMode() -> LoyaltyMode
    func set(mode: LoyaltyMode, withSubtitle text: String)
    func set(dataModel: LoyaltyViewDataModel)
    func set(delegate: LoyaltyViewDelegate)
    func updateLoyaltyFeatures(showEarnRelatedUI: Bool, showBurnRelatedUI: Bool)
    func showError(withMessage message: String)
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
    func hasError() -> Bool
}

protocol LoyaltyBalanceView: AnyObject {
    func set(balance: Int)
    func set(mode: LoyaltyBalanceMode)
}

protocol LoyaltyViewDelegate: AnyObject {
    func didToggleLoyaltyMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}

protocol LoyaltyPresenter {
    var delegate: LoyaltyViewDelegate? { get set }
    func getCurrentMode() -> LoyaltyMode
    func getBalance() -> Int
    func set(dataModel: LoyaltyViewDataModel)
    func updateEarnedPoints(completion: ((_ success: Bool) -> Void)?)
    func updateBurnedPoints(completion: ((_ success: Bool) -> Void)?)
    func updateLoyaltyMode(with mode: LoyaltyMode)
    func set(status: LoyaltyStatus)
    func getLoyaltyPreAuthNonce(completion: @escaping  (Result<LoyaltyNonce>) -> Void)
    func hasError() -> Bool
}

enum LoyaltyMode {
    case none, earn, burn
}

enum LoyaltyBalanceMode {
    case success, error
    
    // TODO: update colors based on new design palette colors for succeess and error
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.green//UIColor(red: 173, green: 239, blue: 209, alpha: 1) //#ADEFD1
        case .error:
            return UIColor.red
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .success:
            return KarhooUI.colors.primaryTextColor
        case .error:
            return KarhooUI.colors.white
        }
    }
}
