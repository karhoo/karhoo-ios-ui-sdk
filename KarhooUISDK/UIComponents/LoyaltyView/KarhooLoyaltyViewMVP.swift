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
    var currentNumberOfPointsDisplayed: Int { get }
    func set(dataModel: LoyaltyViewDataModel, quoteId: String)
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
    func getCurrentNumberOfPointsDisplayed() -> Int
    func set(dataModel: LoyaltyViewDataModel, quoteId: String)
    func set(status: LoyaltyStatus)
    func updateEarnedPoints()
    func updateBurnedPoints()
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
