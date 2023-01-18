//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 17/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import Combine

protocol NewCheckoutPaymentWorker: AnyObject {
    func setup(using quote: Quote)
    func getStoredPaymentNonce() -> Nonce?
    func getPaymentNonce(
        organisationId: String,
        completion: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    )
    func requestNewPaymentMethod(
        showRetryAlert: Bool,
        addCardResultCompletion: @escaping (CardFlowResult) -> Void
    )
    func threeDSecureNonceCheck(
        passengerDetails: PassengerDetails,
        resultCompletion: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void
    )
}
extension NewCheckoutPaymentWorker {
    func requestNewPaymentMethod(addCardResultCompletion: @escaping (CardFlowResult) -> Void) {
        requestNewPaymentMethod(showRetryAlert: false, addCardResultCompletion: addCardResultCompletion)
    }
}

final class KarhooNewCheckoutPaymentWorker: NewCheckoutPaymentWorker {

    private var quote: Quote!
    private let threeDSecureProvider: ThreeDSecureProvider?
    private var cardRegistrationFlow: CardRegistrationFlow
    private let paymentNonceProvider: PaymentNonceProvider
    private let userService: UserService
    private let analytics: Analytics

    private var paymentNonce: Nonce?

    private var addCardResultCompletion: ((CardFlowResult) -> Void)?

    init(
        threeDSecureProvider: ThreeDSecureProvider? = nil,
        cardRegistrationFlow: CardRegistrationFlow = PaymentFactory().getCardFlow(),
        paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
        userService: UserService = Karhoo.getUserService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.threeDSecureProvider = threeDSecureProvider
        self.cardRegistrationFlow = cardRegistrationFlow
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

    func getPaymentNonce(organisationId: String, completion: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        guard let user = userService.getCurrentUser() else {
            assertionFailure()
            return
        }
        paymentNonceProvider.getPaymentNonce(
            user: user,
            organisationId: organisationId,
            quote: quote
        ) { result in
            switch result {
            case .completed(value: let result):
                completion(.completed(value: result))
            case .cancelledByUser:
                completion(.cancelledByUser)
            }
        }
    }

    func requestNewPaymentMethod(
        showRetryAlert: Bool = false,
        addCardResultCompletion: @escaping (CardFlowResult) -> Void
    ) {
        let topMostVC = UIApplication.shared.topMostViewController() as? BaseViewController

        cardRegistrationFlow.setBaseView(topMostVC)

        let currencyCode = quote.price.currencyCode
        let amount = quote.price.intHighPrice
        let supplierPartnerId = quote.fleet.id

        cardRegistrationFlow.start(
            cardCurrency: currencyCode,
            amount: amount,
            supplierPartnerId: supplierPartnerId,
            showUpdateCardAlert: showRetryAlert,
            callback: { [weak self] result in
                guard let cardFlowResult = result.completedValue() else {
                    assertionFailure()
                    return
                }
                self?.handleAddCardFlow(result: cardFlowResult)
        })
    }

    func threeDSecureNonceCheck(
        passengerDetails: PassengerDetails,
        resultCompletion: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void
    ) {
        guard let nonce = getStoredPaymentNonce() else {
            resultCompletion(.completed(value: .failedToInitialisePaymentService))
            return
        }
        threeDSecureProvider?.threeDSecureCheck(
            nonce: nonce.nonce,
            currencyCode: quote.price.currencyCode,
            paymentAmount: NSDecimalNumber(value: quote.price.highPrice),
            callback: { result in
                resultCompletion(result)
            }
        )
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
        default: break
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
