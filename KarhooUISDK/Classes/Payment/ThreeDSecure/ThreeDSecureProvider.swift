//
//  3DSecureProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import Braintree

enum ThreeDSecureCheckResult {
    case success(nonce: String)
    case threeDSecureAuthenticationFailed
    case failedToInitialisePaymentService
}

protocol ThreeDSecureProvider {

    func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmout: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void)

    func set(baseViewController: BaseViewController)
}
