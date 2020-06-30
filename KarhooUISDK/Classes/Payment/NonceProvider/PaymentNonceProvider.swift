//
//  PaymentNonceProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

enum PaymentNonceProviderResult {
    case nonce(nonce: Nonce)
    case threeDSecureCheckFailed
    case failedToInitialisePaymentService
    case failedToAddCard(error: KarhooError?)
}

protocol PaymentNonceProvider {
    func getPaymentNonce(user: UserInfo,
                         organisation: Organisation,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void)

    func set(baseViewController: BaseViewController)
}
