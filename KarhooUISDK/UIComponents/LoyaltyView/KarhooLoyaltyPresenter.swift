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
    
    private var didStartLoading: Bool = false {
        didSet {
            if didStartLoading {
                delegate?.didStartLoading()
            }
        }
    }
    
    private var isLoadingStatus: Bool = false {
        didSet {
            if isLoadingStatus, !didStartLoading {
                didStartLoading = true
            }
            isLoadingDidChange()
        }
    }
    
    private var isLoadingGetEarnPoints: Bool = false {
        didSet {
            if isLoadingGetEarnPoints, !didStartLoading {
                didStartLoading = true
            }
            isLoadingDidChange()
        }
    }
    
    private var isLoadingGetBurnPoints: Bool = false {
        didSet {
            if isLoadingGetBurnPoints, !didStartLoading {
                didStartLoading = true
            }
            isLoadingDidChange()
        }
    }
    
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
    
    private var getStatusError: KarhooError? {
        didSet {
            didSetLoyaltyError(getStatusError)
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
        
        isLoadingStatus = true
        loyaltyService.getLoyaltyStatus(identifier: id).execute { [weak self] result in
            self?.isLoadingStatus = false
            
            guard let status = result.successValue()
            else {
                self?.getStatusError = result.errorValue()
                self?.updateUI()
                return
            }
            
            self?.getStatusError = nil
            self?.handleGetStatusResponse(status: status)
        }
    }
    
    private func handleGetStatusResponse(status: LoyaltyStatus) {
        set(status: status)
        updateViewVisibilityFromViewModel()
        updateEarnedPoints()
        updateBurnedPoints()
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

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: viewModel.tripAmount,
            currencyCode: viewModel.currency
        )
        
        isLoadingGetEarnPoints = true
        loyaltyService.getLoyaltyEarn(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            amount: amount,
            burnPoints: 0
        ).execute { [weak self] result in
            self?.isLoadingGetEarnPoints = false
            
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getEarnAmountError = error
                self?.updateUI()
                return
            }
            
            self?.viewModel?.earnAmount = value.points
            self?.getEarnAmountError = nil
            self?.updateUI()
        }
    }
    
    // MARK: - Burn
    func updateBurnedPoints() {
        guard let viewModel = viewModel,
              viewModel.canBurn
        else {
            return
        }
        
        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: viewModel.tripAmount,
            currencyCode: viewModel.currency
        )
        
        isLoadingGetBurnPoints = true
        loyaltyService.getLoyaltyBurn(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            amount: amount
        ).execute { [weak self] result in
            self?.isLoadingGetBurnPoints = false
            
            guard let value = result.successValue()
            else {
                let error = result.errorValue()
                self?.getBurnAmountError = error
                self?.updateUI()
                return
            }
            
            self?.getBurnAmountError = nil
            self?.viewModel?.burnAmount = value.points
            
            if !(self?.hasEnoughBalance() ?? false) {
                self?.updateLoyaltyMode(with: .error(type: .insufficientBalance))
            }
            
            self?.updateUI()
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
            if getStatusError != nil {
                refreshStatus()
            } else if getEarnAmountError != nil {
                updateEarnedPoints()
            } else if getBurnAmountError != nil {
                updateBurnedPoints()
            } else {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        updateViewVisibilityFromViewModel()
        switch currentMode {
        case .error(let type):
            presenterDelegate?.updateWith(mode: currentMode, earnSubtitle: nil, burnSubtitle: nil, errorMessage: getErrorMessage(for: type))
        default:
            presenterDelegate?.updateWith(mode: currentMode, earnSubtitle: getEarnText(), burnSubtitle: getBurnText(), errorMessage: nil)
        }
    }
    
    // MARK: - Utils
    private func hasEnoughBalance() -> Bool {
        guard let viewModel = viewModel
        else {
            return false
        }

        return viewModel.balance >= viewModel.burnAmount
    }
    
    private func didSetLoyaltyError(_ error: KarhooError?) {
        if let error = error {
            let type: LoyaltyErrorType = error.type == .unknownCurrency ? .unsupportedCurrency : .unknownError
            updateLoyaltyMode(with: .error(type: type))
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
        
        switch currentMode {
        case .none, .earn, .burn:
            presenterDelegate?.togglefeatures(earnOn: canEarn, burnOn: canBurn)
        case .error(let type):
            switch type {
            case .insufficientBalance:
                presenterDelegate?.togglefeatures(earnOn: canEarn, burnOn: canBurn)
            default:
                presenterDelegate?.togglefeatures(earnOn: false, burnOn: true)
            }
        }
    }
    
    private func hideLoyaltyComponent() {
        presenterDelegate?.togglefeatures(earnOn: false, burnOn: false)
    }
    
    private func isLoadingDidChange() {
        let isLoading = isLoadingStatus || isLoadingGetEarnPoints || isLoadingGetBurnPoints
        if !isLoading {
            didStartLoading = false
            delegate?.didEndLoading()
        }
    }
    
    // MARK: - Pre-Auth
    private func canPreAuth() -> Bool {
        guard let viewModel = viewModel
        else {
            return false
        }
        
        switch currentMode {
        case .none:
            return true
        case .earn:
            return viewModel.canEarn
        case .burn:
            let canProceed = viewModel.canBurn && hasEnoughBalance() && getBurnAmountError == nil
            return canProceed
        case .error:
            // Note: When in error mode the component is considered to be in earn / none mode
            // as far as the loyalty nonce retrival is concerned
            // The error mode only prevents the user from burning points, not earning (when available)
            return true
        }
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
        let request = LoyaltyPreAuth(
            identifier: viewModel.loyaltyId,
            currency: viewModel.currency,
            points: points,
            flexpay: flexPay, membership: ""
        )
        
        loyaltyService.getLoyaltyPreAuth(preAuthRequest: request).execute { result in
            completion(result)
        }
    }
    
    private func canFlexPay() -> Bool {
        return currentMode != .burn // This will be adapted when we integrate flexPay
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
