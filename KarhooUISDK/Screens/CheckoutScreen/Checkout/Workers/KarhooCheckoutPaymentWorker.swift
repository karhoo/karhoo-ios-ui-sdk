//
//  KarhooCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 17/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import Foundation
import KarhooSDK
import UIKit

protocol CheckoutPaymentWorker: AnyObject {
    func setup(using quote: Quote)
    func getStoredPaymentNonce() -> Nonce?
    func clearStoredPaymentNonce()
    func getPaymentNonce(
        organisationId: String,
        completion: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    )
}

final class KarhooCheckoutPaymentWorker: CheckoutPaymentWorker {

    private var quote: Quote!
    private let paymentNonceProvider: PaymentNonceProvider
    private let userService: UserService
    private let analytics: Analytics

    private var paymentNonce: Nonce?

    private var addCardResultCompletion: ((CardFlowResult) -> Void)?

    init(
        paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
        userService: UserService = Karhoo.getUserService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.paymentNonceProvider = paymentNonceProvider
        self.userService = userService
        self.analytics = analytics
    }

    func setup(using quote: Quote) {
        self.quote = quote
    }

    func getStoredPaymentNonce() -> Nonce? {
        paymentNonce
    }
    
    func clearStoredPaymentNonce() {
        paymentNonce = nil
    }

    func getPaymentNonce(organisationId: String, completion: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        guard
            let user = userService.getCurrentUser(),
            let topMostVC = UIApplication.shared.topMostBaseViewController()
        else {
            assertionFailure()
            completion(.cancelledByUser)
            return
        }
        paymentNonceProvider.set(baseViewController: topMostVC)
        paymentNonceProvider.getPaymentNonce(
            user: user,
            organisationId: organisationId,
            quote: quote
        ) { [weak self] result in
            switch result {
            case .completed(value: let result):
                switch result {
                case .nonce(nonce: let nonce):
                    self?.paymentNonce = nonce
                default: break
                }
                completion(.completed(value: result))
            case .cancelledByUser:
                completion(.cancelledByUser)
            }
        }
    }

    // MARK: - Result handling

    private func handleAddCardFlow(result: CardFlowResult) {
        switch result {
        case .didAddPaymentMethod(let nonce):
            reportCardAuthorisationSuccess()
            paymentNonce = nonce
            addCardResultCompletion?(.didAddPaymentMethod(nonce: nonce))
        case .didFailWithError(let error):
            reportCardAuthorisationFailure(message: error?.message ?? "")
            let currentProviderType = userService.getCurrentUser()?.paymentProvider?.provider.type ?? PaymentProviderType.unknown
            let isAdyenPayment = currentProviderType == PaymentProviderType.adyen
            let errorMessage = isAdyenPayment ? error?.localizedAdyenMessage : error?.localizedMessage

            addCardResultCompletion?(.didFailWithError(ErrorModel(message: errorMessage ?? UITexts.Errors.somethingWentWrong, code: "")))
        default:
            addCardResultCompletion?(.cancelledByUser)
        }
    }

    // MARK: - Analytics

    private func reportCardAuthorisationSuccess() {
        analytics.cardAuthorisationSuccess(quoteId: quote.id)
    }

    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote.id,
            errorMessage: message,
            lastFourDigits: userService.getCurrentUser()?.nonce?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }
}
