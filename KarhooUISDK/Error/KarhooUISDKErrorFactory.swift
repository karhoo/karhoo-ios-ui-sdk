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

    static func unexpectedError() -> KarhooUIError {
        return KarhooUISDKError(code: "KUISDK00", message: "Unexpected Error")
    }
}

internal struct KarhooUISDKError: KarhooUIError {

    let code: String
    let message: String
}
