//
//  PaymentFactory.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 06/10/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import Adyen

final class PaymentFactory {

    private let userService: UserService

    init(userService: UserService = Karhoo.getUserService()) {
        self.userService = userService
    }

    func getCardFlow() -> CardRegistrationFlow {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            return AdyenCardRegistrationFlow()
        } else {
            return BraintreeCardRegistrationFlow()
        }
    }

    func nonceProvider() -> PaymentNonceProvider {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            return AdyenPaymentNonceProvider()
        }

        return BraintreePaymentNonceProvider()
    }

    func adyenEnvironment() -> Adyen.Environment {
        return .test
    }
}
