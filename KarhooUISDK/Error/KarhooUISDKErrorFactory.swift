//
//  KarhooUISDKErrorFactory.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

class UISDKErrorFactory {

    static func missingCLLocationPermission() -> KarhooUIError {
        return KarhooUISDKError(code: "KUISDK01", message: "Missing CLLocation permission.")
    }
}

internal struct KarhooUISDKError: KarhooUIError {

    let code: String
    let message: String

    init(code: String,
         message: String) {
        self.code = code
        self.message = message
    }
}
