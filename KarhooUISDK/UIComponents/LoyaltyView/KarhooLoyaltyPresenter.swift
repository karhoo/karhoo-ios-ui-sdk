//
//  KarhooLoyaltyPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//
//  swiftlint:disable file_length

import Foundation
import KarhooSDK

final class KarhooLoyaltyPresenter: LoyaltyPresenter {
    
    enum LoyaltyState {
        case noError, earnPointsError, burnPointsError
    }

    weak var delegate: LoyaltyViewDelegate?
    weak var presenterDelegate: LoyaltyPresenterDelegate?

    private var viewModel: LoyaltyUIModel?
    private let userService: UserService
    private var loyaltyService: LoyaltyService
    private var currentMode: LoyaltyMode = .none
    private var isSwitchOn: Bool = false
    private let analytics: Analytics
    private var quoteIdForAnalytics: String?

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
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.analytics = analytics
    }

    // MARK: - Status
    func set(dataModel: LoyaltyViewDataModel, quoteId: String = "") {
        self.quoteIdForAnalytics = quoteId
        // Note: An empty loyaltyId means loyalty as a whole is not enabled
        guard !dataModel.loyaltyId.isEmpty
        else {
            self.hideLoyaltyComponent()
            return
        }
        viewModel = LoyaltyUIModel(request: dataModel)
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
            self?.reportLoyaltyStatusRequested(
                quoteId: self?.quoteIdForAnalytics,
                correlationId: result.getCorrelationId(),
                loyaltyName: self?.viewModel?.loyaltyId,
                loyaltyStatus: result.getSuccessValue(),
                error: result.getErrorValue()
            )

            guard let status = result.getSuccessValue()
            else {
                self?.getStatusError = result.getErrorValue()
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

            guard let value = result.getSuccessValue()
            else {
                let error = result.getErrorValue()
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

            guard let value = result.getSuccessValue()
            else {
                let error = result.getErrorValue()
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
        case .error:
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
        let worker = getLoyaltyPreAuthWorker()
        return worker.hasEnoughBalance()
    }
    
    private func getLoyaltyPreAuthWorker() -> LoyaltyPreAuthWorker {
        return KarhooLoyaltyPreAuthWorker()
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
        case .none, .error:
            return ""
        case .burn:
            return canEarn ? getLocalizedEarnPointsText(for: 0) : ""
        case .earn:
            guard let earnAmount = viewModel?.earnAmount, earnAmount > 0 else { return "" }
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
        case .none, .earn, .error:
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
    
    func getCurrentNumberOfPointsDisplayed() -> Int {
        switch currentMode {
        case .burn:
            return viewModel?.burnAmount ?? 0
        case .earn:
            return viewModel?.earnAmount ?? 0
        default:
            return 0
        }
    }

    // MARK: - Pre-Auth
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        let worker = getLoyaltyPreAuthWorker()
        worker.getLoyaltyPreAuthNonce { result in
            completion(result)
        }
    }

    // MARK: - Analytics
    
    private func reportLoyaltyStatusRequested(
        quoteId: String?,
        correlationId: String?,
        loyaltyName: String?,
        loyaltyStatus: LoyaltyStatus?,
        error: KarhooError?
    ) {
        analytics.loyaltyStatusRequested(
            quoteId: quoteId,
            correlationId: correlationId,
            loyaltyName: loyaltyName,
            loyaltyStatus: loyaltyStatus,
            errorSlug: error?.slug,
            errorMessage: error?.message
        )
    }
}
