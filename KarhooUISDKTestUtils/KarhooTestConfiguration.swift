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

public class KarhooTestConfiguration: KarhooUISDKConfiguration {
    public init() {}

    public static var guestSettings = GuestSettings(identifier: "", referer: "", organisationId: "")
    public static var tokenExchangeSettings = TokenExchangeSettings(clientId: "", scope: "")
    public static var authenticationMethod: AuthenticationMethod = .karhooUser
    public static var isExplicitTermsAndConditionsConsentRequired: Bool = false

    public static func setGuest() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
    }

    public var isExplicitTermsAndConditionsConsentRequired: Bool {
        Self.isExplicitTermsAndConditionsConsentRequired
    }

    public static var mockPaymentManager = MockPaymentManager(.adyen)
    public var paymentManager: PaymentManager {
        Self.mockPaymentManager
    }

    public func logo() -> UIImage {
        UIImage(
            named: "mockImage",
            in: Bundle(for: KarhooTestConfiguration.self),
            compatibleWith: nil
        ) ?? UIImage()
    }

    public func environment() -> KarhooEnvironment {
        return .sandbox
    }

    public func authenticationMethod() -> AuthenticationMethod {
        return Self.authenticationMethod
    }

    public var mockAnalytics = MockAnalytics()
    public func analytics() -> Analytics {
        mockAnalytics
    }

    public var onRequiredSDKAuthentication: (()->Void) -> Void = { $0() }
    public func requireSDKAuthentication(callback: @escaping () -> Void) {
        onRequiredSDKAuthentication { callback() }
    }

    public var bookingMetadataToReturn: [String: Any]?
    public var bookingMetadata: [String: Any]? {
        bookingMetadataToReturn
    }

    public var useAddToCalendarFeatureToReturn: Bool = true
    public var useAddToCalendarFeature: Bool { useAddToCalendarFeatureToReturn }
}
