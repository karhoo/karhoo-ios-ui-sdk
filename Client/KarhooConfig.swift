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

    func environment() -> KarhooEnvironment {
        return Keys.staging()
    }

    func authenticationMethod() -> AuthenticationMethod {
        return KarhooConfig.auth
    }
}
