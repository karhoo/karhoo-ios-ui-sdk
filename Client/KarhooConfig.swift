//
//  KarhooConfig.swift
//  Client
//
//  Created by Jo Santamaria on 27/01/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import KarhooUISDK

final class KarhooConfig: KarhooUISDKConfiguration {

    static var auth: AuthenticationMethod = .karhooUser
    static var environment: KarhooEnvironment = .sandbox
    static var isExplicitTermsAndConfitionsAprovalRequired: Bool = false
    static var paymentManager: PaymentManager!


    var isExplicitTermsAndConditionsConsentRequired: Bool { KarhooConfig.isExplicitTermsAndConfitionsAprovalRequired }
    var paymentManager: PaymentManager { KarhooConfig.paymentManager }

    func environment() -> KarhooEnvironment {
        return KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        return KarhooConfig.auth
    }
}
