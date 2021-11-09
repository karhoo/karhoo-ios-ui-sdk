//
//  MockPaymentScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockPaymentScreenBuilder: PaymentScreenBuilder {

    private(set) var paymentsTokenSet: PaymentSDKToken?
    private(set) var paymentMethodAddedSet: ScreenResultCallback<Nonce>?
    private(set) var flowItemCallbackSet: ScreenResultCallback<Screen>?

    func buildAddCardScreen(paymentsToken: PaymentSDKToken,
                            paymentMethodAdded: ScreenResultCallback<Nonce>?,
                            flowItemCallback: ScreenResultCallback<Screen>?) {
        paymentsTokenSet = paymentsToken
        paymentMethodAddedSet = paymentMethodAdded
        flowItemCallbackSet = flowItemCallback
    }

    func triggerBuilderResult(_ result: ScreenResult<Screen>) {
        flowItemCallbackSet?(result)
    }
}
