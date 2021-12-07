//
//  KarhooLoyaltyPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooLoyaltyPresenter: LoyaltyPresenter {
    weak var delegate: LoyaltyViewDelegate?
    private var view: LoyaltyView?
    private var viewModel: LoyaltyViewModel?
    private let userService: UserService
    private var loyaltyService: LoyaltyService
    
    private var showcaseBurnModeType: ShowcaseBurnMode = .valid
    
    private var currentMode: LoyaltyMode = .none
    
    // MARK: - Init
    init(view: LoyaltyView,
         userService: UserService = Karhoo.getUserService(),
         loyaltyService: LoyaltyService = Karhoo.getLoyaltyService()) {
        self.view = view
        self.userService = userService
        self.loyaltyService = loyaltyService
    }
    
    // MARK: - Status
    func set(dataModel: LoyaltyViewDataModel) {
        // Note: An empty loyaltyId means loyalty as a whole is not enabled
        guard !dataModel.loyaltyId.isEmpty
        else {
            self.hideLoyaltyComponent()
            return
        }
        
        viewModel = LoyaltyViewModel(request: dataModel)
        
        if let status = loyaltyService.getCurrentLoyaltyStatus(identifier: dataModel.loyaltyId) {
            self.set(status: status)
        }
        
        updateViewFromViewModel()
        refreshStatus()
    }
    
    private func refreshStatus() {
        guard let id = viewModel?.loyaltyId
        else {
            hideLoyaltyComponent()
            return
        }
        
        loyaltyService.getLoyaltyStatus(identifier: id).execute { [weak self] result in
            guard let status = result.successValue()
            else {
                self?.hideLoyaltyComponent()
                return
            }
            
            self?.set(status: status)
            self?.updateViewFromViewModel()
            self?.updateEarnedPoints()
            self?.updateBurnedPoints()
        }
    }
    
    func set(status: LoyaltyStatus) {
        viewModel?.canEarn = status.canEarn && LoyaltyFeatureFlags.loyaltyCanEarn
        viewModel?.canBurn = status.canBurn && LoyaltyFeatureFlags.loyaltyCanBurn
        viewModel?.balance = status.balance
    }
    
    // MARK: - Earn
    func updateEarnedPoints() {
        guard let viewModel = viewModel,
              viewModel.canEarn
        else {
            return
        }

        // Convert $ amount to cents
        let amount = viewModel.tripAmount * 100
        loyaltyService.getLoyaltyEarn(identifier: viewModel.loyaltyId, currency: viewModel.currency, amount: Int(amount), burnPoints: 0).execute { [weak self] result in
            guard let value = result.successValue(),
                  let self = self
            else {
                self?.viewModel?.canEarn = false
                self?.updateViewFromViewModel()
                return
            }
            
            self.viewModel?.earnAmount = value.points
            self.view?.set(mode: self.currentMode, withSubtitle: self.getSubtitleText())
        }
    }
    
    // MARK: - Burn
    func updateBurnedPoints() {
        guard let viewModel = viewModel,
              viewModel.canBurn
        else {
            return
        }
        
        // TODO: Finish implementing
    }
    
    // MARK: - Mode
    func getCurrentMode() -> LoyaltyMode {
        return currentMode
    }
    
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
            updateViewFromViewModel()
        } else if currentMode == .burn, showcaseBurnModeType == .valid {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
            view?.updateLoyaltyFeatures(showEarnRelatedUI: true, showBurnRelatedUI: canBurn)
            showcaseBurnModeType = .errorInsufficientBalance
        } else {
            showcaseBurnMode()
        }
        
        delegate?.didToggleLoyaltyMode(newValue: mode)
    }
    
    // MARK: - Utils
    private func getSubtitleText() -> String {
        switch currentMode {
        case .none:
            return ""
        case .burn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsBurnedForTrip, comment: ""), "\(viewModel?.burnAmount ?? 0)")
        case .earn:
            if viewModel?.canEarn ?? false {
                return String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(viewModel?.earnAmount ?? 0)")
            } else {
                return ""
            }
        }
    }
    
    private func updateViewFromViewModel() {
        let canEarn = viewModel?.canEarn ?? false
        let canBurn = viewModel?.canBurn ?? false
        
        view?.updateLoyaltyFeatures(showEarnRelatedUI: canEarn, showBurnRelatedUI: canBurn)
    }
    
    private func hideLoyaltyComponent() {
        view?.updateLoyaltyFeatures(showEarnRelatedUI: false, showBurnRelatedUI: false)
    }
    
    // TODO: remove this method and the related enum, var, etc. They are only for testing the UI in burn mode while under development
    private func showcaseBurnMode() {
        guard currentMode == .burn else {
            return
        }
        
        switch showcaseBurnModeType {
        case .valid:
            updateViewFromViewModel()
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
