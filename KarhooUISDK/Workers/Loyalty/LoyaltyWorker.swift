//
//  LoyaltyWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK

protocol LoyaltyWorker: AnyObject {
    var isLoyaltyEnabled: Bool { get }
    var modelSubject: CurrentValueSubject<Result<LoyaltyViewModel?>, Never> { get }
    var modeSubject: CurrentValueSubject<LoyaltyMode, Never> { get }
    func setup(using quote: Quote)
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
}

final class KarhooLoyaltyWorker: LoyaltyWorker {

    // MARK: - Dependecies

    private let userService: UserService
    private let loyaltyService: LoyaltyService
    private let loyaltyPreAuthWorker: LoyaltyPreAuthWorker
    private let analytics: Analytics

    // MARK: - Properties

    // MARK: Internal properties

    static let shared = KarhooLoyaltyWorker()

    var isLoyaltyEnabled: Bool { getIsLoyaltyEnabled() }
    var modelSubject = CurrentValueSubject<Result<LoyaltyViewModel?>, Never>(.success(result: nil))
    var modeSubject = CurrentValueSubject<LoyaltyMode, Never>(.none)

    // MARK: Private properties

    var canBurnSubject = CurrentValueSubject<Bool, Never>(false)
    var canEarnSubject = CurrentValueSubject<Bool, Never>(false)
    var earnPointsSubject = CurrentValueSubject<Int?, Never>(nil)
    var burnPointsSubject = CurrentValueSubject<Int?, Never>(nil)
    var currentBalanceSubject = CurrentValueSubject<Int?, Never>(nil)

    private var quote: Quote?
    /// Error returned by `getBurnPoints` method, indicating the burn is not possible. It should be used to update PreAuth worker.
    private var burnError: KarhooError?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    init(
        userService: UserService = Karhoo.getUserService(),
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        loyaltyPreAuthWorker: LoyaltyPreAuthWorker = KarhooLoyaltyPreAuthWorker(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.loyaltyPreAuthWorker = loyaltyPreAuthWorker
        self.analytics = analytics

        setupPublishers()
    }
    // MARK: - Endpoints

    func setup(using quote: Quote) {
        self.quote = quote
        getData()
    }

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        loyaltyPreAuthWorker.getLoyaltyPreAuthNonce(completion: completion)
    }

    // MARK: - Private methods

    private func getData() {
        getLoyaltyStatus()
        getEarnedPoints()
        getBurnedPoints()
    }

    private func setupPublishers() {
        
        let zippedEarnBurn = Publishers.Zip4(
            earnPointsSubject,
            burnPointsSubject,
            canEarnSubject,
            canBurnSubject
        )
        Publishers.Zip(
            currentBalanceSubject,
            zippedEarnBurn
        )
        .sink(receiveValue: { [weak self] values in
            let earnBurnValues = values.1

            guard
                let self,
                let quote = self.quote,
                let loyaltyId = self.loyaltyId(),
                let burnAmount = earnBurnValues.1,
                let earnAmount = earnBurnValues.0,
                let balance = values.0
            else {
                return
            }

            let model = LoyaltyViewModel(
                loyaltyId: loyaltyId,
                currency: quote.price.currencyCode,
                tripAmount: quote.price.highPrice,
                canEarn: earnBurnValues.2,
                canBurn: earnBurnValues.3,
                burnAmount: burnAmount,
                earnAmount: earnAmount,
                balance: balance
            )

            self.modelSubject.send(.success(result: model))
            self.updatePreAuthWorker(using: model)
        }
        )
        .store(in: &cancellables)
    }

    private func updatePreAuthWorker(using model: LoyaltyViewModel) {
        guard let quote else {
            assertionFailure("Quote should be assigned before any other logic is called")
            return
        }
        loyaltyPreAuthWorker.setup(
            using: modeSubject.value,
            model: model,
            quoteId: quote.id,
            getBurnAmountError: nil // TODO: - what is it for?
        )
    }

    // MARK: - BE API calls

    private func getLoyaltyStatus() {
        guard let id = loyaltyId() else {
            return
        }

        loyaltyService.getLoyaltyStatus(identifier: id).execute { [weak self] result in
            self?.reportLoyaltyStatusRequested(
                quoteId: self?.quote?.id,
                correlationId: result.getCorrelationId(),
                loyaltyName: id,
                loyaltyStatus: result.getSuccessValue(),
                error: result.getErrorValue()
            )

            guard let status = result.getSuccessValue() else {
                let error = result.getErrorValue() ?? ErrorModel(message: UITexts.Errors.unknownLoyaltyError, code: "")
                self?.modelSubject.send(.failure(error: error))
                return
            }
            self?.currentBalanceSubject.send(status.balance)
            self?.canEarnSubject.send(status.canBurn)
            self?.canBurnSubject.send(status.canEarn)
        }
    }

    private func getEarnedPoints() {
        guard
            let loyaltyId = loyaltyId(),
            let quote
        else {
            return
        }

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: quote.price.highPrice,
            currencyCode: quote.price.currencyCode
        )

        loyaltyService.getLoyaltyEarn(
            identifier: loyaltyId,
            currency: quote.price.currencyCode,
            amount: amount,
            burnPoints: 0
        ).execute { [weak self] result in

            guard let value = result.getSuccessValue()
            else {
                let error = result.getErrorValue() ?? ErrorModel(message: UITexts.Errors.unknownLoyaltyError, code: "")
                self?.modelSubject.send(.failure(error: error, correlationId: result.getCorrelationId()))
                return
            }
            self?.earnPointsSubject.send(value.points)
        }
    }

    private func getBurnedPoints() {
        guard
            let loyaltyId = loyaltyId(),
            let quote
        else {
            return
        }

        // Convert $ amount to minor units (cents)
        let amount = CurrencyCodeConverter.minorUnitAmount(
            from: quote.price.highPrice,
            currencyCode: quote.price.currencyCode
        )

        loyaltyService.getLoyaltyBurn(
            identifier: loyaltyId,
            currency: quote.price.currencyCode,
            amount: amount
        ).execute { [weak self] result in
            guard let value = result.getSuccessValue()
            else {
                let error = result.getErrorValue() ?? ErrorModel(message: UITexts.Errors.unknownLoyaltyError, code: "")
                self?.burnError = error
                self?.loyaltyPreAuthWorker.set(burnError: error)
                // To be verified but seems like get burn failure should not result in loyalty failure. We just need to inform PreAuth worker the burn is not possible.
//                self?.modelSubject.send(completion: .failure(error))
                return
            }

            self?.burnPointsSubject.send(value.points)

            self?.getHasEnougntBalance { [weak self] isBallanceSufficient in
                if isBallanceSufficient == false {
                    self?.modelSubject.send(.failure(error: LoyaltyErrorType.insufficientBalance))
                }
            }
        }
    }

    // MARK: - Helpers

    private func getIsLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }

    private func loyaltyId() -> String? {
        userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
    }

    private func getHasEnougntBalance(completion: @escaping (Bool) -> Void) {
        Publishers.Zip(
            currentBalanceSubject,
            burnPointsSubject
        )
        .sink(receiveValue: { value in
                guard
                    let balance = value.0,
                    let burnPoints = value.1
                else {
                    completion(false)
                    return
                }
                completion(balance >= burnPoints)
            }
        )
        .store(in: &cancellables)
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
