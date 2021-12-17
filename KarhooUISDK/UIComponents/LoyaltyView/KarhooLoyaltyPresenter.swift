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
    private var getBurnAmountError: KarhooError?
    private var getEarnAmountError: KarhooError?
    
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
        
        updateViewVisibilityFromViewModel()
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
            self?.updateViewVisibilityFromViewModel()
            self?.updateEarnedPoints(completion: { success in
                if !success {
                    self?.handleEarnPointsCallError()
                }
                
                self?.updateBurnedPoints(completion: nil)
            })
        }
    }
    
    func set(status: LoyaltyStatus) {
        viewModel?.canEarn = status.canEarn && LoyaltyFeatureFlags.loyaltyCanEarn
        viewModel?.canBurn = status.canBurn && LoyaltyFeatureFlags.loyaltyCanBurn
        viewModel?.balance = status.balance
    }
    
    var currency = "GHC"
    // MARK: - Earn
    func updateEarnedPoints(completion: ((_ success: Bool) -> Void)? = nil) {
        guard let viewModel = viewModel,
              viewModel.canEarn
        else {
            completion?(false)
            return
        }

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(from: viewModel.tripAmount, currencyCode: viewModel.currency)
        loyaltyService.getLoyaltyEarn(identifier: viewModel.loyaltyId, currency: currency, amount: amount, burnPoints: 0).execute { [weak self] result in
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getEarnAmountError = error
                self?.currency = viewModel.currency
                completion?(false)
                return
            }
            
            self?.getEarnAmountError = nil
            self?.viewModel?.earnAmount = value.points
            self?.view?.set(mode: self?.currentMode ?? .none, withSubtitle: self?.getSubtitleText() ?? "")
            completion?(true)
        }
    }
    
    var burnCurrency = "GHC"
    // MARK: - Burn
    func updateBurnedPoints(completion: ((_ success: Bool) -> Void)?) {
        guard let viewModel = viewModel,
              viewModel.canBurn
        else {
            completion?(false)
            return
        }
        
        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(from: viewModel.tripAmount, currencyCode: viewModel.currency)
        loyaltyService.getLoyaltyBurn(identifier: viewModel.loyaltyId, currency: viewModel.currency, amount: amount).execute { [weak self] result in
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getBurnAmountError = error
                self?.burnCurrency = viewModel.currency
                completion?(false)
                return
            }
            
            self?.getBurnAmountError = nil
            self?.viewModel?.burnAmount = value.points
            if self?.currentMode == .burn {
                self?.view?.set(mode: self?.currentMode ?? .none, withSubtitle: self?.getSubtitleText() ?? "")
            }
            completion?(true)
        }
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
        
        if hasError() {
            checkGetEarnAmountError()
            checkGetBurnAmountError()
        } else {
            if currentMode == .burn, !hasEnoughBalance() {
                updateUIWithError(message: UITexts.Errors.insufficientBalanceForLoyaltyBurning)
                return
            }
            
            updateUIWithSuccess()
            delegate?.didToggleLoyaltyMode(newValue: mode)
        }
    }
    
    private func checkGetBurnAmountError() {
        if currentMode == .burn, getBurnAmountError != nil {
            updateBurnedPoints { [weak self] success in
                self?.handleBurnPointsCallError()
                self?.delegate?.didToggleLoyaltyMode(newValue: self?.currentMode ?? .none)
            }
        }
    }
    
    private func checkGetEarnAmountError() {
        if currentMode == .earn, getEarnAmountError != nil {
            updateEarnedPoints { [weak self] success in
                if !success {
                    self?.handleEarnPointsCallError()
                }
                
                self?.delegate?.didToggleLoyaltyMode(newValue: self?.currentMode ?? .none)
            }
        }
    }
    
    private func hasEnoughBalance() -> Bool {
        guard let viewModel = viewModel
        else {
            return false
        }
        
        return viewModel.balance >= viewModel.burnAmount
    }
    
    private func updateUIWithSuccess() {
        view?.set(mode: currentMode, withSubtitle: getSubtitleText())
        switch currentMode {
        case .none:
            updateViewVisibilityFromViewModel()
        case .earn:
            updateViewVisibilityFromViewModel()
        case .burn:
            updateViewVisibilityFromViewModelForBurnMode()
        }
    }
    
    private func updateUIWithError(message: String) {
        view?.showError(withMessage: message)
        updateViewVisibilityFromViewModelForBurnMode()
    }
    
    // MARK: - Utils
    func hasError() -> Bool {
        if currentMode == .burn, getBurnAmountError != nil {
            return true
        }
        
        if currentMode == .earn, getEarnAmountError != nil {
            return true
        }
        
        return false
    }
    
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
    
    private func updateViewVisibilityFromViewModel() {
        let canEarn = viewModel?.canEarn ?? false
        let canBurn = viewModel?.canBurn ?? false
        
        view?.updateLoyaltyFeatures(showEarnRelatedUI: canEarn, showBurnRelatedUI: canBurn)
    }
    
    private func updateViewVisibilityFromViewModelForBurnMode() {
        let canBurn = viewModel?.canBurn ?? false
        
        view?.updateLoyaltyFeatures(showEarnRelatedUI: true, showBurnRelatedUI: canBurn)
    }
    
    private func updateViewForGetEarnAmountError() {
        let canBurn = viewModel?.canBurn ?? false
        
        view?.updateLoyaltyFeatures(showEarnRelatedUI: false, showBurnRelatedUI: canBurn)
    }
    
    private func hideLoyaltyComponent() {
        view?.updateLoyaltyFeatures(showEarnRelatedUI: false, showBurnRelatedUI: false)
    }
    
    private func handleEarnPointsCallError() {
        // TODO: Once the slug is added to the error returned from the server, uncomment and update the snippet below
        // to show the unsupported currency error only when it is indeed the case
        // and delete the call to updateUIWithError on the next line
        if currentMode == .earn, (viewModel?.canEarn ?? false) {
            updateUIWithError(message: UITexts.Errors.unsupportedCurrency)
        }
//                switch error?.type {
//                case .invalidRequestPayload:
//                    self?.updateUIWithError(message: UITexts.Errors.unsupportedCurrency)
//
//                default:
//                    self?.updateViewForGetEarnAmountError()
//                }
    }
    
    private func handleBurnPointsCallError() {
        // TODO: Once the slug is added to the error returned from the server, uncomment and update the snippet below
        // to show the unsupported currency error only when it is indeed the case
        // and delete the call to updateUIWithError on the next line
        if currentMode == .burn {
            updateUIWithError(message: UITexts.Errors.unsupportedCurrency)
        }
//                switch error?.type {
//                case .invalidRequestPayload:
//                    self?.updateUIWithError(message: UITexts.Errors.unsupportedCurrency)
//
//                default:
//                    self?.updateViewVisibilityFromViewModelForBurnMode()
//                }
    }
}
