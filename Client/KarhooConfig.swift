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
    static var isExplicitTermsAndConditionsApprovalRequired: Bool = false
    static var paymentManager: PaymentManager!
    static var useAddToCalendarFeature = true
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }

    var isExplicitTermsAndConditionsConsentRequired: Bool { KarhooConfig.isExplicitTermsAndConditionsApprovalRequired }

    func environment() -> KarhooEnvironment {
        KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        KarhooConfig.auth
    }
    
    var paymentManager: PaymentManager {
        KarhooConfig.paymentManager
    }

    func analytics() -> Analytics {
        KarhooAnalytics(base: KarhooAnalitycsServiceWithNotifications())
    }

    var useAddToCalendarFeature: Bool {
        KarhooConfig.useAddToCalendarFeature
    }

    func requireSDKAuthentication(callback: @escaping () -> Void) {
        print("Client: KarhooConfig.requireSDKAuthentication started")
        KarhooConfig.onUpdateAuthentication {
            print("Client: KarhooConfig.requireSDKAuthentication finished")
            callback()
        }
    }
}
