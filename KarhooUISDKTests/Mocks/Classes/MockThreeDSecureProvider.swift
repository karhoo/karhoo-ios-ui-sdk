//
//  MockThreeDSecureProvider.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockThreeDSecureProvider: ThreeDSecureProvider {

    private(set) var nonceSet: String?
    private(set) var paymentAmountSet: NSDecimalNumber?
    private(set) var currencyCodeSet: String?
    private var callback: ((OperationResult<ThreeDSecureCheckResult>) -> Void)?

    func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmout: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void) {
        self.nonceSet = nonce
        self.paymentAmountSet = paymentAmout
        self.currencyCodeSet = currencyCode
        self.callback = callback
    }

    private(set) var setBaseViewControllerCalled = false
    func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }

    func triggerResult(_ result: OperationResult<ThreeDSecureCheckResult>) {
        self.callback?(result)
    }
}
