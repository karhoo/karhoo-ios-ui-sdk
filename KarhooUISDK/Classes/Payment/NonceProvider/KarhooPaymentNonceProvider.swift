//
//  KarhooBookTripHandler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooPaymentNonceProvider: PaymentNonceProvider {

    private let paymentService: PaymentService
    private let threeDSecureProvider: ThreeDSecureProvider
    var callbackResult: ((OperationResult<PaymentNonceProviderResult>) -> Void)?
    private var quoteToBook: Quote?
    private var sdkToken: PaymentSDKToken?
    private weak var baseViewController: BaseViewController?
    private let cardRegistrationFlow: CardRegistrationFlow

    init(paymentService: PaymentService = Karhoo.getPaymentService(),
         threeDSecureProvider: ThreeDSecureProvider = BraintreeThreeDSecureProvider(),
         cardRegistrationFlow: CardRegistrationFlow = KarhooCardRegistrationFlow()) {
        self.paymentService = paymentService
        self.threeDSecureProvider = threeDSecureProvider
        self.cardRegistrationFlow = cardRegistrationFlow
    }

    func set(baseViewController: BaseViewController) {
        self.baseViewController = baseViewController
        threeDSecureProvider.set(baseViewController: baseViewController)
        cardRegistrationFlow.setBaseView(baseViewController)
    }

    func getPaymentNonce(user: UserInfo,
                         organisation: Organisation,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        self.callbackResult = result
        self.quoteToBook = quote

        let sdkTokenRequest = PaymentSDKTokenPayload(organisationId: organisation.id,
                                                     currency: quote.currencyCode)

        paymentService.initialisePaymentSDK(paymentSDKTokenPayload: sdkTokenRequest).execute {[weak self] result in
            switch result {
            case .success(let sdkToken):
                self?.sdkToken = sdkToken
            case .failure:
                self?.callbackResult?(.completed(value: .failedToInitialisePaymentService))
                return
            }
        }

        let payer = Payer(id: user.userId,
                          firstName: user.firstName,
                          lastName: user.lastName,
                          email: user.email)
        let nonceRequestPayload = NonceRequestPayload(payer: payer,
                                                      organisationId: organisation.id)

        getNonce(payload: nonceRequestPayload, currencyCode: quote.currencyCode)
    }

    private func getNonce(payload: NonceRequestPayload, currencyCode: String) {
        paymentService.getNonce(nonceRequestPayload: payload).execute { [weak self] result in
            switch result {
            case .success(let nonce): self?.execute3dSecureCheckOnNonce(nonce)
            case .failure: self?.triggerAddCardFlow(currencyCode: currencyCode)
            }
        }
    }

    private func triggerAddCardFlow(currencyCode: String) {
        self.cardRegistrationFlow.start(cardCurrency: currencyCode,
                                        showUpdateCardAlert: true,
                                        callback: { [weak self] result in
            switch result {
            case .completed(let addCardResult): self?.handleAddCardResult(addCardResult)
            case .cancelledByUser: self?.callbackResult?(.cancelledByUser)
            }
        })
    }

    private func handleAddCardResult(_ result: CardFlowResult) {
        switch result {
        case .didAddPaymentMethod(let method): execute3dSecureCheckOnNonce(Nonce(nonce: method.nonce))
        case .didFailWithError(let error): callbackResult?(.completed(value: .failedToAddCard(error: error)))
        case .cancelledByUser: self.callbackResult?(.cancelledByUser)
        }
    }

    private func execute3dSecureCheckOnNonce(_ nonce: Nonce) {
        if runningBookingUITest() == true {
            self.callbackResult?(.completed(value: .nonce(nonce: nonce)))
            return
        }

        guard self.sdkToken != nil else {
            self.callbackResult?(.completed(value: .failedToInitialisePaymentService))
            return
        }

        guard let quote = quoteToBook else {
            return
        }

        threeDSecureProvider.threeDSecureCheck(nonce: nonce.nonce,
                                               currencyCode: quote.currencyCode,
                                               paymentAmout: NSDecimalNumber(value: quote.highPrice),
                                               callback: { [weak self] result in
                                                switch result {
                                                case .completed(let result): handleThreeDSecureCheck(result)
                                                case .cancelledByUser: self?.callbackResult?(.cancelledByUser)
                                                }
        })

        func handleThreeDSecureCheck(_ result: ThreeDSecureCheckResult) {
            switch result {
            case .failedToInitialisePaymentService:
                self.callbackResult?(.completed(value: .failedToInitialisePaymentService))
            case .threeDSecureAuthenticationFailed:
                triggerAddCardFlow(currencyCode: quote.currencyCode)
            case .success(let threeDSecureNonce):
                self.callbackResult?(.completed(value: .nonce(nonce: Nonce(nonce: threeDSecureNonce))))
            }
        }
    }
}

extension KarhooPaymentNonceProvider {
    func runningBookingUITest() -> Bool {
        return ProcessInfo().arguments.contains("booking-test")
    }
}
