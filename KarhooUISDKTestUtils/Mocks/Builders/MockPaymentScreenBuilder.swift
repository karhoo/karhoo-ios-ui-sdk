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

final public class MockPaymentScreenBuilder: PaymentScreenBuilder {

    public var paymentsTokenSet: PaymentSDKToken?
    public var paymentMethodAddedSet: ScreenResultCallback<Nonce>?
    public var flowItemCallbackSet: ScreenResultCallback<Screen>?

    public func buildAddCardScreen(paymentsToken: PaymentSDKToken,
                            paymentMethodAdded: ScreenResultCallback<Nonce>?,
                            flowItemCallback: ScreenResultCallback<Screen>?) {
        paymentsTokenSet = paymentsToken
        paymentMethodAddedSet = paymentMethodAdded
        flowItemCallbackSet = flowItemCallback
    }

    public func triggerBuilderResult(_ result: ScreenResult<Screen>) {
        flowItemCallbackSet?(result)
    }
}
