//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 17/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooNewCheckoutPaymentWorker {

    private let threeDSecureProvider: ThreeDSecureProvider? = nil

    func getPaymentNonceAccordingToAuthState() -> Nonce? {
        .init(nonce: "", cardType: "", lastFour: "")
    }

    func getPaymentNonce() -> Nonce? {
        .init(nonce: "", cardType: "", lastFour: "")
    }

    func requestNewPaymentMethod(showRetryAlert: Bool = false) {
        // TODO: start add payment method flow
//        cardRegistrationFlow.setBaseView(view)
//
//        let currencyCode = quote.price.currencyCode
//        let amount = quote.price.intHighPrice
//        let supplierPartnerId = quote.fleet.id
//
//        cardRegistrationFlow.start(
//            cardCurrency: currencyCode,
//            amount: amount,
//            supplierPartnerId: supplierPartnerId,
//            showUpdateCardAlert: showRetryAlert,
//            callback: { [weak self] result in
//                guard let cardFlowResult = result.completedValue() else {
//                    return
//                }
//                self?.handleAddCardFlow(result: cardFlowResult)
//        })
    }

    func threeDSecureNonceCheck(
        quote: Quote,
        passengerDetails: PassengerDetails,
        resultCompletion: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void
    ) {
        guard let nonce = getPaymentNonceAccordingToAuthState() else {
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
}
