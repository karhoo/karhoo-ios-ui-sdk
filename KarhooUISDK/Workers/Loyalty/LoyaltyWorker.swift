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
    var loyaltyStatusSubject: CurrentValueSubject<LoyaltyStatus?, Error> { get }
    var currentBalanceSubject: CurrentValueSubject<Int?, Never> { get }
    func refreshStatus()
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

    var isLoyaltyEnabled: Bool { getIsLoyaltyEnabled() }
    var loyaltyStatusSubject = CurrentValueSubject<LoyaltyStatus?, Error>(nil)
    var currentBalanceSubject = CurrentValueSubject<Int?, Never>(nil)

    // MARK: Private properties

    private let quote: Quote
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    init(
        quote: Quote,
        userService: UserService = Karhoo.getUserService(),
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        loyaltyPreAuthWorker: LoyaltyPreAuthWorker = KarhooLoyaltyPreAuthWorker(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.quote = quote
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.analytics = analytics

        refreshStatus()
    }
    // MARK: - Endpoints

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        if loyaltyPreAuthWorker == nil {

        }
        loyaltyPreAuthWorker?.getLoyaltyPreAuthNonce(completion: completion)
    }

    func refreshStatus() {
        getLoyaltyStatus()
    }

    // MARK: - Private methods

    private bindPreAuthWorkerUpdate() {
        loyaltyStatusSubject
            .sink { [weak self] status in
                guard let self else { return }
                self.loyaltyPreAuthWorker.setup(
                    using: .earn,
                    viewModel: .init(
                        loyaltyId: self.loyaltyId() ?? "",
                        currency: self.quote.price.currencyCode,
                        tripAmount: self.quote.price.highPrice
                    ),
                    quoteId: self.quote.id,
                    getBurnAmountError: nil
                )
            }
            .store(in: &cancellables)
    }

    private func getLoyaltyStatus() {
        guard let id = loyaltyId() else {
            return
        }

        loyaltyService.getLoyaltyStatus(identifier: id).execute { [weak self] result in
            self?.reportLoyaltyStatusRequested(
                quoteId: self?.quote.id,
                correlationId: result.getCorrelationId(),
                loyaltyName: id,
                loyaltyStatus: result.getSuccessValue(),
                error: result.getErrorValue()
            )

            guard let status = result.getSuccessValue() else {
                let error = result.getErrorValue() ?? ErrorModel(message: UITexts.Errors.unknownLoyaltyError)
                self?.loyaltyStatusSubject.send(completion: .failure(error))
                return
            }
            self?.loyaltyStatusSubject.send(status)
        }
    }

    // MARK: - Helpers

    private func getLoyaltyDataModel(using status: )
    private func getIsLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }

    private func loyaltyId() -> String? {
        userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
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
