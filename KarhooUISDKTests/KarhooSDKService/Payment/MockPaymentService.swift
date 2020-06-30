//
//  MockPaymentService.swift
//  Karhoo
//
//  Created by Yaser on 2017-05-26.
//  Copyright © 2017 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import Karhoo

class MockPaymentService: PaymentService {

    let paymentSDKTokenCall = MockCall<PaymentsToken>()
    func initialisePaymentSDK() -> Call<PaymentsToken> {
        return paymentSDKTokenCall
    }

    let addPaymentMethodCall = MockCall<KarhooVoid>()
    var nonceToAdd: String?
    func addPaymentMethod(nonce: String) -> Call<KarhooVoid> {
        nonceToAdd = nonce
        return addPaymentMethodCall
    }
}
