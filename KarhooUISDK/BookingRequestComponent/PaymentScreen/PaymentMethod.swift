//
//  PaymentMethod.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

public struct PaymentMethod: Equatable {

    let nonce: String
    let nonceType: String
    let icon: UIView
    let paymentDescription: String

    init(nonce: String = "",
         nonceType: String = "",
         icon: UIView = UIView(),
         paymentDescription: String = "") {
        self.nonce = nonce
        self.nonceType = nonceType
        self.icon = icon
        self.paymentDescription = paymentDescription
    }
}
