//
//  UnitTestSetup.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
@testable import KarhooUISDK

final class UnitTestSetup: NSObject {

    override init() {
        KarhooUI.set(configuration: KarhooTestConfiguration())
    }
}

class KarhooTestConfiguration: KarhooUISDKConfiguration {

    static var guestSettings = GuestSettings(identifier: "",
                                             referer: "", organisationId: "")
    static var tokenExchangeSettings = TokenExchangeSettings(clientId: "", scope: "")
    static var authenticationMethod: AuthenticationMethod = .karhooUser
    static var isExplicitTermsAndConditionsConsentRequired: Bool = false

    var isExplicitTermsAndConditionsConsentRequired: Bool {
        Self.isExplicitTermsAndConditionsConsentRequired
    }

    var mockPaymentManager = MockPaymentManager()
    var paymentManager: PaymentManager! {
        mockPaymentManager
    }

    func logo() -> UIImage {
        return UIImage(named: "mockImage",
                       in: Bundle(for: UnitTestSetup.self),
                       compatibleWith: nil)!
    }

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return Self.authenticationMethod
    }

    var mockAnalytics = MockAnalytics()
    func analytics() -> Analytics {
        mockAnalytics
    }
}
