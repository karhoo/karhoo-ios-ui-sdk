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

final public class MockThreeDSecureProvider: ThreeDSecureProvider {

    public var nonceSet: String?
    public var paymentAmountSet: NSDecimalNumber?
    public var currencyCodeSet: String?
    private var callback: ((OperationResult<ThreeDSecureCheckResult>) -> Void)?
    public var threeDSecureCalled = false
    public func threeDSecureCheck(nonce: String,
                           currencyCode: String,
                           paymentAmount: NSDecimalNumber,
                           callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void) {
        self.nonceSet = nonce
        self.paymentAmountSet = paymentAmount
        self.currencyCodeSet = currencyCode
        self.callback = callback
        self.threeDSecureCalled = true
    }

    public var setBaseViewControllerCalled = false
    public func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }

    public func triggerResult(_ result: OperationResult<ThreeDSecureCheckResult>) {
        self.callback?(result)
    }
}
