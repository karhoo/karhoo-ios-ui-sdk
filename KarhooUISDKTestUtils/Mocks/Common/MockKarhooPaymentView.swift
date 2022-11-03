//
//  MockKarhooPaymentView.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK
import KarhooSDK

final public class MockKarhooPaymentView: MockBaseView, AddPaymentView {

    public var baseViewController: BaseViewController?

    public var actions: AddPaymentViewDelegate?

    public var quote: Quote?

    public var nonceSet: Nonce?
    public func set(nonce: Nonce) {
        nonceSet = nonce
    }

    public var noPaymentMethodCalled = false
    public func noPaymentMethod() {
        noPaymentMethodCalled = true
    }

    public var startCardFlowCalled = false
    public func startRegisterCardFlow(showRetryAlert: Bool = true) {
        startCardFlowCalled = true
    }
}
