//
//  MockError.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

struct MockError: KarhooError, Equatable {
    let code: String
    let message: String
    let userMessage: String

    static func == (lhs: MockError, rhs: MockError) -> Bool {
        return lhs.code == rhs.code
            && lhs.message == rhs.message
            && lhs.userMessage == rhs.userMessage
    }
}
