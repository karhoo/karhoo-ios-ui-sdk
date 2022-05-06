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
    private let sdkConfiguration: KarhooUISDKConfiguration

    init(userService: UserService = Karhoo.getUserService(),
         sdkConfiguration: KarhooUISDKConfiguration =  KarhooUISDKConfigurationProvider.configuration) {
        self.userService = userService
        self.sdkConfiguration = sdkConfiguration
    }

    func getCardFlow() -> CardRegistrationFlow {
        sdkConfiguration.pspCore.getCardFlow()
        // MULTIPSP
//        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
//            return AdyenCardRegistrationFlow()
//        } else {
//            return BraintreeCardRegistrationFlow()
//        }
    }

    func nonceProvider() -> PaymentNonceProvider {
        sdkConfiguration.pspCore.getNonceProvider()
        // MULTIPSP
//        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
//            return AdyenPaymentNonceProvider()
//        }
//
//        return BraintreePaymentNonceProvider()
    }

    func adyenEnvironment() -> Adyen.Environment {
        switch Karhoo.configuration.environment() {
            case .production: return .live
            default: return .test
        }
    }
}
