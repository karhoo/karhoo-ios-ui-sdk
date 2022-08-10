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
    private(set) var threeDSecureCalled = false
    func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmount: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void) {
        self.nonceSet = nonce
        self.paymentAmountSet = paymentAmount
        self.currencyCodeSet = currencyCode
        self.callback = callback
        self.threeDSecureCalled = true
    }

    private(set) var setBaseViewControllerCalled = false
    func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }

    func triggerResult(_ result: OperationResult<ThreeDSecureCheckResult>) {
        self.callback?(result)
    }
}
