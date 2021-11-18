//
//  KarhooLoyaltyPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyPresenter: LoyaltyPresenter {
    weak var delegate: LoyaltyViewDelegate?
    var view: LoyaltyView?
    var viewModel: LoyaltyViewModel?
    var earnAmount = 0
    var burnAmount = 0
    
    private var testBurnModeType: TestBurnMode = .valid
    
    private var currentMode: LoyaltyMode = .earn {
        didSet {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
        }
    }
    
    init(view: LoyaltyView) {
        self.view = view
    }
    
    func getCurrentMode() -> LoyaltyMode {
        return currentMode
    }
    
    func set(viewModel: LoyaltyViewModel) {
        self.viewModel = viewModel
    }
    
    func updateEarnedPoints() {}
    
    func updateBurnedPoints() {}
    
    func updateLoyaltyMode(with mode: LoyaltyMode) {
        currentMode = mode
        delegate?.didToggleLoyaltyMode(newValue: mode)
        testBurnMode()
    }
    
    private func getSubtitleText() -> String {
        switch currentMode {
        case .burn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsBurnedForTrip, comment: ""), "\(burnAmount)")
        case .earn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(earnAmount)")
        }
    }
    
    // TODO: remove this method and the related enum, var, etc. They are only for testing the UI in burn mode while under development
    private func testBurnMode() {
        guard currentMode == .burn else {
            return
        }
        
        switch testBurnModeType {
        case .valid:
            testBurnModeType = .errorInsufficientBalance
            
        case .errorInsufficientBalance:
            view?.showError(withMessage: UITexts.Errors.insufficientBalanceForLoyaltyBurning)
            testBurnModeType = .errorUnsupportedCurrency
            
        case .errorUnsupportedCurrency:
            view?.showError(withMessage: UITexts.Errors.unsupportedCurrency)
            testBurnModeType = .valid
        }
    }
    
    private enum TestBurnMode {
        case valid, errorInsufficientBalance, errorUnsupportedCurrency
    }
}
