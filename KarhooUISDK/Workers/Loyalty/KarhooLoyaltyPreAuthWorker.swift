//
//  KarhooLoyaltyPreAuthWorker.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.01.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol LoyaltyPreAuthWorker {
    func setup(
        using currentMode: LoyaltyMode,
        model: LoyaltyViewModel,
        quoteId: String,
        getBurnAmountError: KarhooError?
    )
    func set(burnError: KarhooError?)
    func getLoyaltyPreAuthNonce(
        completion: @escaping (Result<LoyaltyNonce>) -> Void
    )
    func hasEnoughBalance() -> Bool
}

final class KarhooLoyaltyPreAuthWorker: LoyaltyPreAuthWorker {
    private let loyaltyService: LoyaltyService
    private let analytics: Analytics
    private var currentMode: LoyaltyMode = .none
    private var viewModel: LoyaltyViewModel?
    private var quoteId: String?
    private var getBurnAmountError: KarhooError?
    private var isPreparedForPreAuth = false

    init(
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.loyaltyService = loyaltyService
        self.analytics = analytics
    }

    func setup(
        using currentMode: LoyaltyMode,
        model: LoyaltyViewModel,
        quoteId: String,
        getBurnAmountError: KarhooError?
    ) {
        self.viewModel = model
        self.quoteId = quoteId
        self.getBurnAmountError = getBurnAmountError
        self.currentMode = currentMode
        isPreparedForPreAuth = true
    }

    func set(burnError: KarhooError?) {
        self.getBurnAmountError = burnError
    }
    
    func getLoyaltyPreAuthNonce(
        completion: @escaping (Result<LoyaltyNonce>) -> Void
    ) {
        guard isPreparedForPreAuth else {
            assertionFailure("Should not happeded, it's only a failsafe")
            let error = ErrorModel(message: UITexts.Errors.unknownLoyaltyError, code: "")
            completion(.failure(error: error, correlationId: nil))
            return
        }
        if !currentMode.isEligibleForPreAuth {
            // Loyalty related web-services return slug based errors, not error code based ones
            // this error does not coincide with any error returned by the backend
            // Although the message is not shown in the UISDK implementation it will serve DPs when integrating as a standalone component
            let error = ErrorModel(message: UITexts.Errors.loyaltyModeNotEligibleForPreAuth, code: "KP005")
            completion(.failure(error: error))
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

        loyaltyService.getLoyaltyPreAuth(preAuthRequest: request).execute { [weak self] result in
            if result.getSuccessValue() != nil, let currentMode = self?.currentMode {
                self?.reportLoyaltyPreAuthSuccess(
                    quoteId: self?.quoteId,
                    correlationId: result.getCorrelationId(),
                    preauthType: currentMode
                )
            }
            if let error = result.getErrorValue(), let currentMode = self?.currentMode {
                self?.reportLoyaltyPreAuthFailure(
                    quoteId: self?.quoteId,
                    correlationId: result.getCorrelationId(),
                    preauthType: currentMode,
                    errorSlug: error.slug,
                    errorMessage: error.message
                )
            }
            completion(result)
        }
    }
    
    func hasEnoughBalance() -> Bool {
        guard let viewModel = viewModel
        else {
            return false
        }
        return viewModel.balance >= viewModel.burnAmount
    }

    // MARK: - Helpers
    
    private func canPreAuth() -> Bool {
        guard let viewModel = viewModel,
              currentMode.isEligibleForPreAuth
        else {
            return false
        }

        switch currentMode {
        case .earn:
            return viewModel.canEarn
        case .burn:
            let canProceed = viewModel.canBurn && hasEnoughBalance() && getBurnAmountError == nil
            return canProceed
        default:
            return true
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
    
    // MARK: - Analytics
    
    private func reportLoyaltyPreAuthFailure(
        quoteId: String?,
        correlationId: String?,
        preauthType: LoyaltyMode,
        errorSlug: String?,
        errorMessage: String
    ) {
        analytics.loyaltyPreAuthFailure(
            quoteId: quoteId,
            correlationId: correlationId,
            preauthType: preauthType,
            errorSlug: errorSlug,
            errorMessage: errorMessage
        )
    }

    private func reportLoyaltyPreAuthSuccess(
        quoteId: String?,
        correlationId: String?,
        preauthType: LoyaltyMode
    ) {
        analytics.loyaltyPreAuthSuccess(
            quoteId: quoteId,
            correlationId: correlationId,
            preauthType: preauthType
        )
    }
}
