//
//  MockKarhooPaymentView.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK
import KarhooSDK

final class MockKarhooPaymentView: PaymentView {

    var actions: PaymentViewActions?

    var baseViewController: BaseViewController? {
        return MockBaseViewController()
    }

    var quoteToReturn: Quote?
    var quote: Quote? {
        return quoteToReturn
    }

    private(set) var paymentMethodSet: PaymentMethod?
    func set(paymentMethod: PaymentMethod) {
        paymentMethodSet = paymentMethod
    }

    private(set) var nonceSet: Nonce?
    func set(nonce: Nonce) {
        nonceSet = nonce
    }

    private(set) var noPaymentMethodCalled = false
    func noPaymentMethod() {
        noPaymentMethodCalled = true
    }
}
