//
//  3DSecureProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
#if canImport(Braintree)
import Braintree
#endif
#if canImport(BraintreeThreeDSecure)
import BraintreeThreeDSecure
#endif


enum ThreeDSecureCheckResult {
    case success(nonce: String)
    case threeDSecureAuthenticationFailed
    case failedToInitialisePaymentService
}

protocol ThreeDSecureUtils {
    var userAgent: String { get }
    var acceptHeader: String { get }
    var current3DSReturnUrl: String { get }
    var current3DSReturnUrlScheme: String { get }
}

protocol ThreeDSecureProvider {

    func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmout: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void)

    func set(baseViewController: BaseViewController)
}
