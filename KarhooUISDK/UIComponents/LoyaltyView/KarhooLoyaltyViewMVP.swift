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
}

public protocol LoyaltyViewDelegate: AnyObject {
    func didChangeMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}

protocol LoyaltyPresenter: AnyObject {
    var delegate: LoyaltyViewDelegate? { get set }
    var presenterDelegate: LoyaltyPresenterDelegate? { get set }
    var balance: Int { get }
    func getCurrentMode() -> LoyaltyMode
    func set(dataModel: LoyaltyViewDataModel)
    func set(status: LoyaltyStatus)
    func updateEarnedPoints() //remove completion?
    func updateBurnedPoints() //remove completion?
    func updateLoyaltyMode(with mode: LoyaltyMode)
    func getLoyaltyPreAuthNonce(completion: @escaping  (Result<LoyaltyNonce>) -> Void)
}

protocol LoyaltyPresenterDelegate: AnyObject {
    func updateWith(mode: LoyaltyMode, earnSubtitle: String?, burnSubtitle: String?, errorMessage: String?)
    func togglefeatures(earnOn: Bool, burnOn: Bool)
}

protocol LoyaltyBalanceView: AnyObject {
    func set(balance: Int)
    func set(mode: LoyaltyBalanceMode)
}

public enum LoyaltyErrorType {
    case none, insufficientBalance, unsupportedCurrency, unknownError
    
    var text: String {
        switch self {
        case .none:
            return ""
        case .insufficientBalance:
            return UITexts.Errors.insufficientBalanceForLoyaltyBurning
        case .unsupportedCurrency:
            return UITexts.Errors.unsupportedCurrency
        case .unknownError:
            return UITexts.Errors.unknownLoyaltyError
        }
    }
}

public enum LoyaltyMode {
    case none
    case earn
    case burn
    case error(type: LoyaltyErrorType)
    
    static func ==(lhs: LoyaltyMode, rhs: LoyaltyMode) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none) :
            return true
        case (.earn, .earn):
            return true
        case (.burn, .burn):
            return true
        case (let .error(type1), let.error(type2)):
            return type1 == type2
        default:
            return false
        }
    }
    
    static func !=(lhs: LoyaltyMode, rhs: LoyaltyMode) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none) :
            return false
        case (.earn, .earn):
            return false
        case (.burn, .burn):
            return false
        case (let .error(type1), let.error(type2)):
            return type1 != type2
        default:
            return true
        }
    }
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
