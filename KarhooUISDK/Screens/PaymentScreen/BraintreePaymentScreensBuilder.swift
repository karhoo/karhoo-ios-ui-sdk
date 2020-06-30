//
//  BraintreePaymentScreensBuilder.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import BraintreeDropIn
import Braintree

final class BraintreePaymentScreenBuilder: PaymentScreenBuilder {

    func buildAddCardScreen(paymentsToken: PaymentSDKToken,
                            paymentMethodAdded: ScreenResultCallback<PaymentMethod>?,
                            flowItemCallback: ScreenResultCallback<Screen>?) {
        let request = BTDropInRequest()

        guard let flowItem = BTDropInController(authorization: paymentsToken.token,
                                                request: request,
                                                handler: {( _, result: BTDropInResult?, error: Error?) in
            if error != nil {
                paymentMethodAdded?(.failed(error: error as? KarhooError))
            } else if result?.isCancelled == true {
                paymentMethodAdded?(.cancelled(byUser: true))
            } else {
                let paymentMethod = PaymentMethod(nonce: result!.paymentMethod!.nonce,
                                                  nonceType: result!.paymentMethod!.type,
                                                  icon: result!.paymentIcon,
                                                  paymentDescription: result!.paymentDescription)

                paymentMethodAdded?(ScreenResult.completed(result: paymentMethod))
            }
        }) else {
            flowItemCallback?(.failed(error: nil))
            return
        }

        flowItemCallback?(.completed(result: flowItem))
    }
}
