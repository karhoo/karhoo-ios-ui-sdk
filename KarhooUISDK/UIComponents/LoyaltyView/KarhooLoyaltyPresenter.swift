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

    enum LoyaltyState {
        case noError, earnPointsError, burnPointsError
    }
    
    weak var delegate: LoyaltyViewDelegate?
    private weak var view: LoyaltyView?
    private var viewModel: LoyaltyViewModel?
    private let userService: UserService
    private var loyaltyService: LoyaltyService
    private var getBurnAmountError: KarhooError?
    private var getEarnAmountError: KarhooError?
    
    private var currentMode: LoyaltyMode = .none
    
    var balance: Int {
        viewModel?.balance ?? 0
    }
    
    // MARK: - Init
    init(
        userService: UserService = Karhoo.getUserService(),
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService()
    ) {
        self.userService = userService
        self.loyaltyService = loyaltyService
    }
    
    func set(view: LoyaltyView) {
        self.view = view
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
                #if DEBUG
                print("Hiding loyalty component due to server error")
                #endif
                return
            }
            
            self?.set(status: status)
            self?.updateViewVisibilityFromViewModel()
            self?.updateEarnedPoints(completion: { success in
                if !success {
                    self?.handlePointsCallError(for: .earn)
                } else {
                    self?.view?.set(mode: self?.currentMode ?? .none, withSubtitle: self?.getSubtitleText() ?? "")
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
    
    // MARK: - Earn
    func updateEarnedPoints(completion: ((_ success: Bool) -> Void)? = nil) {
        guard let viewModel = viewModel,
              viewModel.canEarn
        else {
            completion?(false)
            return
        }

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: viewModel.tripAmount,
            currencyCode: viewModel.currency
        )
        
        loyaltyService.getLoyaltyEarn(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            amount: amount,
            burnPoints: 0
        )
            .execute { [weak self] result in
                
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getEarnAmountError = error
                completion?(false)
                return
            }
            
            self?.getEarnAmountError = nil
            self?.viewModel?.earnAmount = value.points
            completion?(true)
        }
    }
    
    // MARK: - Burn
    func updateBurnedPoints(completion: ((_ success: Bool) -> Void)?) {
        guard let viewModel = viewModel,
              viewModel.canBurn
        else {
            completion?(false)
            return
        }
        
        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: viewModel.tripAmount,
            currencyCode: viewModel.currency
        )
        
        loyaltyService.getLoyaltyBurn(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            amount: amount
        )
            .execute { [weak self] result in
                
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getBurnAmountError = error
                completion?(false)
                return
            }
            
            self?.getBurnAmountError = nil
            self?.viewModel?.burnAmount = value.points
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
        
        if currentMode == .burn, !hasEnoughBalance() {
            updateUIWithError(message: UITexts.Errors.insufficientBalanceForLoyaltyBurning)
            delegate?.didToggleLoyaltyMode(newValue: currentMode)
            return

        }
        
        handleUpdateLoyaltyMode()
    }
    
    private func handleUpdateLoyaltyMode(state: LoyaltyState? = nil) {
        let s = state ?? .earnPointsError
        
        switch s {
        case .earnPointsError:
            if currentMode == .earn, getEarnAmountError != nil {
                updateEarnedPoints { [weak self] success in
                    if success {
                        self?.handleUpdateLoyaltyMode(state: .burnPointsError)
                    } else {
                        self?.handlePointsCallError(for: .earn)
                        self?.delegate?.didToggleLoyaltyMode(newValue: self?.currentMode ?? .none)
                    }
                }
            } else {
                self.handleUpdateLoyaltyMode(state: .burnPointsError)
            }
            
        case .burnPointsError:
            if currentMode == .burn, getBurnAmountError != nil {
                updateBurnedPoints { [weak self] success in
                    if success {
                        self?.handleUpdateLoyaltyMode(state: .noError)
                    } else {
                        self?.handlePointsCallError(for: .burn)
                        self?.delegate?.didToggleLoyaltyMode(newValue: self?.currentMode ?? .none)
                    }
                }
            } else {
                self.handleUpdateLoyaltyMode(state: .noError)
            }
            
        case .noError:
            updateUIWithSuccess()
            delegate?.didToggleLoyaltyMode(newValue: currentMode)
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
        if currentMode == .burn, !hasEnoughBalance() {
            return true
        }
        
        if currentMode == .burn, getBurnAmountError != nil {
            return true
        }
        
        if currentMode == .earn, getEarnAmountError != nil {
            return true
        }
        
        return false
    }
    
    // MARK: - Pre-Auth
    private func canPreAuth() -> Bool {
        guard let viewModel = viewModel
        else {
            return false
        }
        
        if currentMode == .burn,
           viewModel.canBurn,
           hasEnoughBalance(),
           getBurnAmountError == nil {
            return true
        }
        
        if currentMode == .earn, viewModel.canEarn {
            return true
        }

        return false
    }
    
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        if currentMode == .none {
            completion(.success(result: LoyaltyNonce(loyaltyNonce: "")))
            return
        }
        
        guard canPreAuth(),
              let viewModel = viewModel
        else {
            let error = ErrorModel(message: UITexts.Loyalty.noAllowedToBurnPoints, code: "K002")
            completion(Result.failure(error: error))
            return
        }
        
        let flexPay = canFlexPay()
        let points = getLoyaltyBurnPointsForPreAuth()
        let request = LoyaltyPreAuth(identifier: viewModel.loyaltyId, currency: viewModel.currency, points: points, flexpay: flexPay, membership: "")
        loyaltyService.getLoyaltyPreAuth(preAuthRequest: request).execute { result in
            completion(result)
        }
    }
    
    private func canFlexPay() -> Bool {
        return currentMode == .earn // This will be adapted when we integrate flexPay
    }
    
    private func getLoyaltyBurnPointsForPreAuth() -> Int {
        guard let viewModel = viewModel
        else {
            return 0
        }
        
        // https://karhoo.atlassian.net/wiki/spaces/PAY/pages/4343201851/Loyalty
        return currentMode == .burn ? viewModel.burnAmount : 0
    }
    
    private func getSubtitleText() -> String {
        switch currentMode {
        case .none:
            return ""
        case .burn:
            return String(format: NSLocalizedString(UITexts.Loyalty.burnOnSubtitle, comment: ""), "\(viewModel?.tripAmount ?? 0)", "\(viewModel?.currency ?? "-")", "\(viewModel?.burnAmount ?? 0)")
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
    
    private func updateViewForErrorCase() {
        let canBurn = viewModel?.canBurn ?? false
        
        view?.updateLoyaltyFeatures(showEarnRelatedUI: false, showBurnRelatedUI: canBurn)
    }
    
    private func hideLoyaltyComponent() {
        view?.updateLoyaltyFeatures(showEarnRelatedUI: false, showBurnRelatedUI: false)
    }
    
    private func handlePointsCallError(for mode: LoyaltyMode) {
        if mode != currentMode {
            return
        }
        
        let error = mode == .burn ? getBurnAmountError : getEarnAmountError
        
        switch error?.type {
        case .unknownCurrency:
            self.updateUIWithError(message: UITexts.Errors.unsupportedCurrency)

        default:
            self.updateViewForErrorCase()
        }
    }
}
