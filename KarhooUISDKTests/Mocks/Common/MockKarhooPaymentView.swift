//
//  MockKarhooPaymentView.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK
import KarhooSDK

final class MockKarhooPaymentView: MockBaseView, AddPaymentView {

    var baseViewController: BaseViewController?

    var actions: AddPaymentViewDelegate?

    var quote: Quote?

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
