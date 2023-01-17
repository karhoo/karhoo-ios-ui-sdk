//
//  3DSecureProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public enum ThreeDSecureCheckResult {
    case success(nonce: String)
    case threeDSecureAuthenticationFailed
    case failedToInitialisePaymentService
    case canceledByUser
}

public protocol ThreeDSecureUtils {
    var userAgent: String { get }
    var acceptHeader: String { get }
    var current3DSReturnUrl: String { get }
    var current3DSReturnUrlScheme: String { get }
}

public protocol ThreeDSecureProvider {

    func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmount: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void)

    func set(baseViewController: BaseViewController)
}
