//
//  KarhooBookTripHandler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK

final class BraintreePaymentNonceProvider: PaymentNonceProvider {

    private let paymentService: PaymentService
    private let threeDSecureProvider: ThreeDSecureProvider
    var callbackResult: ((OperationResult<PaymentNonceProviderResult>) -> Void)?
    private var quoteToBook: Quote?
    private var sdkToken: PaymentSDKToken?
    private weak var baseViewController: BaseViewController?
    private let cardRegistrationFlow: CardRegistrationFlow

    init(
        paymentService: PaymentService = Karhoo.getPaymentService(),
        threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
        cardRegistrationFlow: CardRegistrationFlow = BraintreeCardRegistrationFlow()
    ) {
        self.paymentService = paymentService
        self.threeDSecureProvider = threeDSecureProvider
        self.cardRegistrationFlow = cardRegistrationFlow
    }

    func set(baseViewController: BaseViewController) {
        self.baseViewController = baseViewController
        threeDSecureProvider.set(baseViewController: baseViewController)
        cardRegistrationFlow.setBaseView(baseViewController)
    }

    func getPaymentNonce(
        user: UserInfo,
        organisationId: String,
        quote: Quote,
        result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    ) {
        self.callbackResult = result
        self.quoteToBook = quote

        let sdkTokenRequest = PaymentSDKTokenPayload(organisationId: organisationId,
                                                     currency: quote.price.currencyCode)

        paymentService.initialisePaymentSDK(paymentSDKTokenPayload: sdkTokenRequest).execute { [weak self] result in
            switch result {
            case .success(let sdkToken, _):
                self?.sdkToken = sdkToken
                self?.triggerAddCardFlow(
                    currencyCode: quote.price.currencyCode,
                    showUpdateCardAlert: false
                )
            case .failure:
                self?.callbackResult?(.completed(value: .failedToInitialisePaymentService(error: result.getErrorValue())))
                return
            }
        }
    }

    private func triggerAddCardFlow(
        currencyCode: String,
        showUpdateCardAlert: Bool
    ) {
        self.cardRegistrationFlow.start(
            cardCurrency: currencyCode,
            amount: 0,
            supplierPartnerId: "",
            showUpdateCardAlert: showUpdateCardAlert,
            dropInAuthenticationToken: sdkToken,
            callback: { [weak self] result in
            switch result {
            case .completed(let addCardResult): self?.handleAddCardResult(addCardResult)
            case .cancelledByUser: self?.callbackResult?(.cancelledByUser)
            }
        })
    }

    private func handleAddCardResult(_ result: CardFlowResult) {
        switch result {
        case .didAddPaymentMethod(let nonce): execute3dSecureCheckOnNonce(nonce)
        case .didFailWithError(let error): callbackResult?(.completed(value: .failedToAddCard(error: error)))
        case .cancelledByUser: self.callbackResult?(.cancelledByUser)
        }
    }

    private func execute3dSecureCheckOnNonce(_ nonce: Nonce) {
        if runningBookingUITest() == true {
            self.callbackResult?(.completed(value: .nonce(nonce: nonce)))
            return
        }

        guard let sdkToken else {
            self.callbackResult?(.completed(value: .failedToInitialisePaymentService(error: nil)))
            return
        }

        guard let quote = quoteToBook else {
            return
        }

        threeDSecureProvider.threeDSecureCheck(
            authToken: sdkToken,
            nonce: nonce.nonce,
            currencyCode: quote.price.currencyCode,
            paymentAmount: NSDecimalNumber(value: quote.price.highPrice),
            callback: { [weak self] result in
                switch result {
                case .completed(let result): handleThreeDSecureCheck(result)
                case .cancelledByUser: self?.callbackResult?(.cancelledByUser)
            }
        })

        func handleThreeDSecureCheck(_ result: ThreeDSecureCheckResult) {
            switch result {
            case .failedToInitialisePaymentService:
                self.callbackResult?(.completed(value: .failedToInitialisePaymentService(error: nil)))
            case .threeDSecureAuthenticationFailed:
                triggerAddCardFlow(currencyCode: quote.price.currencyCode, showUpdateCardAlert: true)
            case .success(let threeDSecureNonce):
                self.callbackResult?(.completed(value: .nonce(nonce: Nonce(nonce: threeDSecureNonce))))
            }
        }
    }
}

extension BraintreePaymentNonceProvider {
    func runningBookingUITest() -> Bool {
        return ProcessInfo().arguments.contains("booking-test")
    }
}
