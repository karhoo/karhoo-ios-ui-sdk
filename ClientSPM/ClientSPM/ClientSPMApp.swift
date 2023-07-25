//
//  ClientSPMApp.swift
//  ClientSPM
//
//  Created by Aleksander Wedrychowski on 20/05/2022.
//

import KarhooSDK
import KarhooUISDK
import KarhooUISDKAdyen
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
        let guestSettings = GuestSettings(
            identifier: "",
            referer: "",
            organisationId: ""
        )
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = .sandbox
        KarhooConfig.paymentManager = AdyenPaymentManager()
    }
}

final class KarhooConfig: KarhooUISDKConfiguration {
    var useAddToCalendarFeature: Bool = true
    
    static var auth: AuthenticationMethod = .guest(
        settings: GuestSettings(
            identifier: "",
            referer: "",
            organisationId: ""
        )
    )
    static var environment: KarhooEnvironment = .sandbox
    static var isExplicitTermsAndConditionsApprovalRequired: Bool = false
    static var paymentManager: PaymentManager!
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }

    var isExplicitTermsAndConditionsConsentRequired: Bool {
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired
    }
    
    var paymentManager: PaymentManager {
        KarhooConfig.paymentManager
    }

    func environment() -> KarhooEnvironment {
        KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        KarhooConfig.auth
    }
    
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        print("Client: KarhooConfig.requireSDKAuthentication started")
        KarhooConfig.onUpdateAuthentication {
            print("Client: KarhooConfig.requireSDKAuthentication finished")
            callback()
        }
    }
}
