//
//  KarhooTestConfiguration.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
@testable import KarhooUISDK

class KarhooTestConfiguration: KarhooUISDKConfiguration {

    static var guestSettings = GuestSettings(identifier: "",
                                             referer: "", organisationId: "")
    static var tokenExchangeSettings = TokenExchangeSettings(clientId: "", scope: "")
    static var authenticationMethod: AuthenticationMethod = .karhooUser
    static var isExplicitTermsAndConditionsConsentRequired: Bool = false
    

    var isExplicitTermsAndConditionsConsentRequired: Bool {
        Self.isExplicitTermsAndConditionsConsentRequired
    }

    static var mockPaymentManager = MockPaymentManager(.adyen)
    var paymentManager: PaymentManager! {
        Self.mockPaymentManager
    }

    func logo() -> UIImage {
        UIImage(
            named: "mockImage",
            in: Bundle(for: KarhooTestConfiguration.self),
            compatibleWith: nil
        ) ?? UIImage()
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
