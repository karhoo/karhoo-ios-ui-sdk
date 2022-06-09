//
//  PaymentNonceProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public enum PaymentNonceProviderResult {
    case nonce(nonce: Nonce)
    case threeDSecureCheckFailed
    case failedToInitialisePaymentService(error: KarhooError?)
    case failedToAddCard(error: KarhooError?)
    case cancelledByUser
}

public protocol PaymentNonceProvider {
    func getPaymentNonce(user: UserInfo,
                         organisationId: String,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void)

    func set(baseViewController: BaseViewController)
}
