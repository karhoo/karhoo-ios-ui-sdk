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
    private(set) var paymentMethodAddedSet: ScreenResultCallback<PaymentMethod>?
    private(set) var flowItemCallbackSet: ScreenResultCallback<Screen>?

    func buildAddCardScreen(paymentsToken: PaymentSDKToken,
                            paymentMethodAdded: ScreenResultCallback<PaymentMethod>?,
                            flowItemCallback: ScreenResultCallback<Screen>?) {
        paymentsTokenSet = paymentsToken
        paymentMethodAddedSet = paymentMethodAdded
        flowItemCallbackSet = flowItemCallback
    }

    func triggerBuilderResult(_ result: ScreenResult<Screen>) {
        flowItemCallbackSet?(result)
    }
}
