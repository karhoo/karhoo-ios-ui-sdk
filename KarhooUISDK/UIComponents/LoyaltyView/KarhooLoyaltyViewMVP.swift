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
    var delegate: LoyaltyViewDelegate? { get set }
    var currentMode: LoyaltyMode { get }
    func set(dataModel: LoyaltyViewDataModel)
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

protocol LoyaltyPresenter: AnyObject {
    var delegate: LoyaltyViewDelegate? { get set }
    var internalDelegate: LoyaltyPresenterDelegate? { get set }
    var balance: Int { get }
    func getCurrentMode() -> LoyaltyMode
    func set(dataModel: LoyaltyViewDataModel)
    func set(status: LoyaltyStatus)
    func updateEarnedPoints(completion: ((_ success: Bool) -> Void)?)
    func updateBurnedPoints(completion: ((_ success: Bool) -> Void)?)
    func updateLoyaltyMode(with mode: LoyaltyMode)
    func getLoyaltyPreAuthNonce(completion: @escaping  (Result<LoyaltyNonce>) -> Void)
    func hasError() -> Bool
}

protocol LoyaltyPresenterDelegate: AnyObject {
    func updateWith(mode: LoyaltyMode, earnText: String, burnText: String)
    func updateWith(error: LoyaltyError, errorMessage: String)
    func togglefeatures(earnOn: Bool, burnOn: Bool)
}

enum LoyaltyError {
    case none, insufficientBalance, unsupportedCurrency, unknownError
}

enum LoyaltyMode {
    case none, earn, burn
}

enum LoyaltyBalanceMode {
    case success, error
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return KarhooUI.colors.primary
        case .error:
            return KarhooUI.colors.error
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .success:
            return backgroundColor.isLight ? KarhooUI.colors.text : KarhooUI.colors.white
        case .error:
            return KarhooUI.colors.white
        }
    }
}
