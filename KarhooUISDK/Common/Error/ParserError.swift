//
//  ParserError.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

enum ParserError: KarhooError {
    case infoMissing(String)
    case infoTypeUnexpected(String)

    static func == (lhs: ParserError, rhs: ParserError) -> Bool {
        switch (lhs, rhs) {
        case (let .infoMissing(lhsString), let .infoMissing(rhsString)):
            return lhsString == rhsString
        case (let .infoTypeUnexpected(lhsString), let .infoTypeUnexpected(rhsString)):
            return lhsString == rhsString
        default:
            return false
        }
    }
}
