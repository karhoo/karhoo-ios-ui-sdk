//
//  ClientSPMApp.swift
//  ClientSPM
//
//  Created by Aleksander Wedrychowski on 20/05/2022.
//

import KarhooSDK
import KarhooUISDK
import AdyenPSP
import SwiftUI

@main
struct ClientSPMApp: App {

    init() {
        setupKarhooConfig()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func setupKarhooConfig() {
        KarhooUI.set(configuration: KarhooConfig())
        let guestSettings = GuestSettings(identifier: "",
                                          referer: "",
                                          organisationId: "")
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = .sandbox
        KarhooConfig.paymentManager = AdyenPaymentManager()
    }
}

final class KarhooConfig: KarhooUISDKConfiguration {
    static var auth: AuthenticationMethod = .karhooUser
    static var environment: KarhooEnvironment = .sandbox
    static var isExplicitTermsAndConditionsApprovalRequired: Bool = false
    static var paymentManager: PaymentManager!


    var isExplicitTermsAndConditionsConsentRequired: Bool {
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired
    }

    func environment() -> KarhooEnvironment {
        KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        KarhooConfig.auth
    }
    
    var paymentManager: PaymentManager! {
        KarhooConfig.paymentManager
    }
}
