//
//  BraintreePaymentScreensBuilder.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK
#if canImport(BraintreeDropIn)
import BraintreeDropIn
#endif
#if canImport(Braintree)
import Braintree
#endif
#if canImport(BraintreePaymentFlow)
import BraintreePaymentFlow
#endif


final public class BraintreePaymentScreenBuilder: PaymentScreenBuilder {
    
    public init(){}

    public func buildAddCardScreen(paymentsToken: PaymentSDKToken,
                            paymentMethodAdded: ScreenResultCallback<Nonce>?,
                            flowItemCallback: ScreenResultCallback<Screen>?) {
        let request = BTDropInRequest()

        guard let flowItem = BTDropInController(authorization: paymentsToken.token,
                                                request: request,
                                                handler: {( _, result: BTDropInResult?, error: Error?) in
            /// TODO: remove when Cocoapods version of Braintree will be updated
            ///
            /// In Braintree version < 9.0.0 property name is 'isCancelled' and strarting from v 9.0.0 is updated to 'isCanceled'.
            /// We are using for now version 8.2.0 for Cocoapods so we need to compute this value based on Braintree version
            var isResultCanceled: Bool? {
                #if SWIFT_PACKAGE
                result?.isCanceled
                #else
                result?.isCancelled
                #endif
            }
            
            if error != nil {
                paymentMethodAdded?(.failed(error: error as? KarhooError))
            } else if isResultCanceled == true {
                paymentMethodAdded?(.cancelled(byUser: true))
            } else {
                let nonce = Nonce(nonce: result!.paymentMethod!.nonce, cardType: result!.paymentMethod!.type, lastFour: String(result!.paymentDescription.suffix(2)))
                paymentMethodAdded?(ScreenResult.completed(result: nonce))
            }
        }) else {
            flowItemCallback?(.failed(error: nil))
            return
        }

        flowItemCallback?(.completed(result: flowItem))
    }
}
