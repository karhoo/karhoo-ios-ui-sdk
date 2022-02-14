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
    weak var presenterDelegate: LoyaltyPresenterDelegate?
    
    private var viewModel: LoyaltyViewModel?
    private let userService: UserService
    private var loyaltyService: LoyaltyService
    private var currentMode: LoyaltyMode = .none
    private var isSwitchOn: Bool = false
    
    private var getBurnAmountError: KarhooError? {
        didSet {
            didSetLoyaltyError(getBurnAmountError)
        }
    }
    private var getEarnAmountError: KarhooError? {
        didSet {
            didSetLoyaltyError(getEarnAmountError)
        }
    }
    
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
        
        delegate?.didStartLoading()
        
        loyaltyService.getLoyaltyStatus(identifier: id).execute { [weak self] result in
            guard let status = result.successValue()
            else {
                self?.delegate?.didEndLoading()
                self?.hideLoyaltyComponent()
                #if DEBUG
                print("Hiding loyalty component due to server error")
                #endif
                return
            }
            
            self?.handleGetStatusResponse(status: status)
        }
    }
    
    private func handleGetStatusResponse(status: LoyaltyStatus) {
        set(status: status)
        updateViewVisibilityFromViewModel()
        
        updateEarnedPoints(completion: { [weak self] success in
            self?.updateUI()
            
            self?.updateBurnedPoints { success in
                self?.delegate?.didEndLoading()
                self?.handleInitialGetBurnPointsResponse(success: success)
            }
        })
    }
    
//    private func handleInitialGetEarnPointsResponse(success: Bool?) {
//        guard let success = success else { return }
//
//        if !success {
//            handlePointsCallError(for: .earn)
//        } else {
//            presenterDelegate?.updateWith(
//                mode: currentMode,
//                earnSubtitle: getEarnText(),
//                burnSubtitle: getBurnText()
//            )
//        }
//    }
    
    private func handleInitialGetBurnPointsResponse(success: Bool?) {
        guard let success = success else { return }
        
        if success, !hasEnoughBalance() {
            updateLoyaltyMode(with: .error(type: .insufficientBalance))
        } else if success {
            updateLoyaltyMode(with: isSwitchOn ? .burn : .earn)
        }
    }
    
    func set(status: LoyaltyStatus) {
        viewModel?.canEarn = status.canEarn && LoyaltyFeatureFlags.loyaltyCanEarn
        viewModel?.canBurn = status.canBurn && LoyaltyFeatureFlags.loyaltyCanBurn
        viewModel?.balance = status.balance
    }
    
    // MARK: - Earn
    func updateEarnedPoints(completion: ((_ success: Bool?) -> Void)? = nil) {
        guard let viewModel = viewModel,
              viewModel.canEarn
        else {
            completion?(nil)
            return
        }

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: viewModel.tripAmount,
            currencyCode: viewModel.currency
        )
        
        delegate?.didStartLoading()
        loyaltyService.getLoyaltyEarn(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            amount: amount,
            burnPoints: 0
        ).execute { [weak self] result in
            self?.delegate?.didEndLoading()
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getEarnAmountError = error
                completion?(false)
                return
            }
            
            self?.viewModel?.earnAmount = value.points
            self?.getEarnAmountError = nil
            completion?(true)
        }
    }
    
    // MARK: - Burn
    func updateBurnedPoints(completion: ((_ success: Bool?) -> Void)?) {
        guard let viewModel = viewModel,
              viewModel.canBurn
        else {
            completion?(nil)
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
        ).execute { [weak self] result in
                
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
        
        switch mode {
        case .none:
            currentMode = .none
        case .burn:
            if !canBurn {
                return
            } else if !hasEnoughBalance() {
                currentMode = .error(type: .insufficientBalance)
            } else {
                currentMode = .burn
            }
        case .earn:
            currentMode = canEarn ? .earn : .none
        case .error(let type):
            currentMode = .error(type: type)
        }
        
        delegate?.didChangeMode(newValue: currentMode)
        handleModeChanged()
    }
    
    private func handleModeChanged() {
        switch currentMode {
        case .none, .earn, .burn:
            updateUI()
        case .error(_):
            if getEarnAmountError != nil {
                updateEarnedPoints { [weak self] success in
                    self?.updateUI()
                }
            } else if getBurnAmountError != nil {
                updateBurnedPoints { [weak self] success in
                    self?.updateUI()
                }
            } else {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        switch currentMode {
        case .error(let type):
            presenterDelegate?.updateWith(mode: currentMode, earnSubtitle: nil, burnSubtitle: nil, errorMessage: getErrorMessage(for: type))
        default:
            presenterDelegate?.updateWith(mode: currentMode, earnSubtitle: getEarnText(), burnSubtitle: getBurnText(), errorMessage: nil)
        }
       
        updateViewVisibilityFromViewModel()
    }
    
    // MARK: - Utils
    var hasBalance: Bool?
    private func hasEnoughBalance() -> Bool {
        if hasBalance == nil {
           let random = Int.random(in: 0...2)
           if random % 2 == 0 {
              hasBalance = true
           } else {
              hasBalance = false
           }
        }
        return hasBalance!
    }
//    private func hasEnoughBalance() -> Bool {
//        guard let viewModel = viewModel
//        else {
//            return false
//        }
//
//        return viewModel.balance >= viewModel.burnAmount
//    }
    
    private func didSetLoyaltyError(_ error: KarhooError?) {
        if let error = error {
            let type: LoyaltyErrorType = error.type == .unknownCurrency ? .unsupportedCurrency : .unknownError
            updateLoyaltyMode(with: .error(type: type))
        } else {
            updateLoyaltyMode(with: .earn)
        }
    }
    
    private func getEarnText() -> String {
        let canEarn = viewModel?.canEarn ?? false
        switch currentMode {
        case .none, .error(_):
            return ""
        case .burn:
            return canEarn ? getLocalizedEarnPointsText(for: 0) : ""
        case .earn:
            let earnAmount = viewModel?.earnAmount ?? 0
            return canEarn ? getLocalizedEarnPointsText(for: earnAmount) : ""
        }
    }
    
    private func getLocalizedEarnPointsText(for amount: Int) -> String {
        String(
            format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""),
            "\(amount)"
        )
    }
    
    private func getBurnText() -> String {
        switch currentMode {
        case .none, .earn, .error(_):
            let canBurn = viewModel?.canBurn ?? false
            return canBurn ? UITexts.Loyalty.burnOffSubtitle : ""
        case .burn:
            let amount = viewModel?.tripAmount.amountString ?? "0"
            return String(
                format: NSLocalizedString(UITexts.Loyalty.burnOnSubtitle, comment: ""),
                amount,
                "\(viewModel?.currency ?? "-")",
                "\(viewModel?.burnAmount ?? 0)"
            )
        }
    }
    
    private func getErrorMessage(for error: LoyaltyErrorType) -> String {
        switch error {
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
    
    private func updateViewVisibilityFromViewModel() {
        let canEarn = viewModel?.canEarn ?? false
        let canBurn = viewModel?.canBurn ?? false
        presenterDelegate?.togglefeatures(earnOn: canEarn, burnOn: canBurn)
    }
    
    private func hideLoyaltyComponent() {
        presenterDelegate?.togglefeatures(earnOn: false, burnOn: false)
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
}
