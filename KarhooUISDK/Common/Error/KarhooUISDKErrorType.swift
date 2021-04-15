//
//  KarhooUISDKErrorType.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum KarhooUIErrorType: Equatable {

    case missingCLLocationPermission
    case unknownError

    public init(error: KarhooUIError) {
        switch error.code {

        case "KUISDK01": self = .missingCLLocationPermission
        default: self = .unknownError
        }
    }
}
