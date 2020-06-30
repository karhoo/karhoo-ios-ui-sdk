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

final class MockPaymentNonceProvider: PaymentNonceProvider {

    private var callback: ((OperationResult<PaymentNonceProviderResult>) -> Void)?
    private(set) var userSet: UserInfo?
    private(set) var organisationSet: Organisation?
    private(set) var quoteSet: Quote?
    private(set) var getNonceCalled = false
    func getPaymentNonce(user: UserInfo,
                         organisation: Organisation,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        self.callback = result
        userSet = user
        organisationSet = organisation
        quoteSet = quote
        getNonceCalled = true
    }

    func triggerResult(_ result: OperationResult<PaymentNonceProviderResult>) {
        callback?(result)
    }
    private(set) var setBaseViewControllerCalled = false
    func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }
}
