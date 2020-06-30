//
//  UnitTestSetup.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class UnitTestSetup: NSObject {

    override init() {
        KarhooUI.set(configuration: KarhooTestConfiguration())
    }
}

class KarhooTestConfiguration: KarhooUISDKConfiguration {

    static var guestSettings = GuestSettings(identifier: "",
                                             referer: "", organisationId: "")
    static var authenticationMethod: AuthenticationMethod = .karhooUser

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
}
