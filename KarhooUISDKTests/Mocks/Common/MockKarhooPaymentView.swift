//
//  MockKarhooPaymentView.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK
import KarhooSDK

final class MockKarhooPaymentView: MockBaseView, PaymentView {

    var baseViewController: BaseViewController?

    var actions: PaymentViewActions?

    var quote: Quote?

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

    private(set) var startCardFlowCalled = false
    func startRegisterCardFlow(showRetryAlert: Bool = true) {
        startCardFlowCalled = true
    }
}
