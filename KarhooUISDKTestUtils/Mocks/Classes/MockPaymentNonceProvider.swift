//
//  MockPaymentNonceProvider.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final public class MockPaymentNonceProvider: PaymentNonceProvider {

    private var callback: ((OperationResult<PaymentNonceProviderResult>) -> Void)?
    public var userSet: UserInfo?
    public var organisationSet: String = ""
    public var quoteSet: Quote?
    public var getNonceCalled = false
    public func getPaymentNonce(user: UserInfo,
                         organisationId: String,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        self.callback = result
        userSet = user
        organisationSet = organisationId
        quoteSet = quote
        getNonceCalled = true
    }

    public func triggerResult(_ result: OperationResult<PaymentNonceProviderResult>) {
        callback?(result)
    }
    public var setBaseViewControllerCalled = false
    public func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }
}
