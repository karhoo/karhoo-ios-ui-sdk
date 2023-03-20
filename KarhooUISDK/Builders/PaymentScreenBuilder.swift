//
//  PaymentScreenBuilder.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol PaymentScreenBuilder {
    func buildAddCardScreen(
        allowToSaveCard: Bool,
        paymentsToken: PaymentSDKToken,
        paymentMethodAdded: ScreenResultCallback<Nonce>?,
        flowItemCallback: ScreenResultCallback<Screen>?
    )
}
