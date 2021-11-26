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
    
    private var showcaseBurnModeType: ShowcaseBurnMode = .valid
    
    private var currentMode: LoyaltyMode = .none
    
    init(view: LoyaltyView) {
        self.view = view
    }
    
    func getCurrentMode() -> LoyaltyMode {
        return currentMode
    }
    
    func set(viewModel: LoyaltyViewModel) {
        self.viewModel = viewModel
        view?.updateLoyaltyFeatures(showEarnRelatedUI: viewModel.canEarn, showBurnRelatedUI: viewModel.canBurn)
    }
    
    func updateEarnedPoints() {}
    
    func updateBurnedPoints() {}
    
    func updateLoyaltyMode(with mode: LoyaltyMode) {
        if mode == currentMode {
            return
        }
        
        let canEarn = viewModel?.canEarn ?? false
        let canBurn = viewModel?.canBurn ?? false
        
        if mode == .burn, !canBurn {
            return
        }
        
        if mode == .earn, !canEarn {
            currentMode = .none
        } else {
            currentMode = mode
        }
        
        if currentMode == .earn || currentMode == .none {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
            view?.updateLoyaltyFeatures(showEarnRelatedUI: viewModel?.canEarn ?? false, showBurnRelatedUI: viewModel?.canBurn ?? false)
        } else if currentMode == .burn, showcaseBurnModeType == .valid {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
            view?.updateLoyaltyFeatures(showEarnRelatedUI: true, showBurnRelatedUI: viewModel?.canBurn ?? false)
            showcaseBurnModeType = .errorInsufficientBalance
        } else {
            showcaseBurnMode()
        }
        
        delegate?.didToggleLoyaltyMode(newValue: mode)
    }
    
    private func getSubtitleText() -> String {
        switch currentMode {
        case .none:
            return ""
        case .burn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsBurnedForTrip, comment: ""), "\(burnAmount)")
        case .earn:
            if viewModel?.canEarn ?? false {
                return String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(earnAmount)")
            } else {
                return ""
            }
        }
    }
    
    // TODO: remove this method and the related enum, var, etc. They are only for testing the UI in burn mode while under development
    private func showcaseBurnMode() {
        guard currentMode == .burn else {
            return
        }
        
        switch showcaseBurnModeType {
        case .valid:
            view?.updateLoyaltyFeatures(showEarnRelatedUI: viewModel?.canEarn ?? false, showBurnRelatedUI: viewModel?.canBurn ?? false)
            showcaseBurnModeType = .errorInsufficientBalance
            
        case .errorInsufficientBalance:
            view?.showError(withMessage: UITexts.Errors.insufficientBalanceForLoyaltyBurning)
            view?.updateLoyaltyFeatures(showEarnRelatedUI: true, showBurnRelatedUI: viewModel?.canBurn ?? false)
            showcaseBurnModeType = .errorUnsupportedCurrency
            
        case .errorUnsupportedCurrency:
            view?.showError(withMessage: UITexts.Errors.unsupportedCurrency)
            view?.updateLoyaltyFeatures(showEarnRelatedUI: true, showBurnRelatedUI: viewModel?.canBurn ?? false)
            showcaseBurnModeType = .valid
        }
    }
    
    private enum ShowcaseBurnMode {
        case valid, errorInsufficientBalance, errorUnsupportedCurrency
    }
}
