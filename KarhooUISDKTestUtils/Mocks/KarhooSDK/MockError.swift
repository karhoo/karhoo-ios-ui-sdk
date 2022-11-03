//
//  MockError.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public struct MockError: KarhooError, Equatable {
    public init(code: String, message: String, userMessage: String) {
        self.code = code
        self.message = message
        self.userMessage = userMessage
    }

    public let code: String
    public let message: String
    public let userMessage: String

    public static func == (lhs: MockError, rhs: MockError) -> Bool {
        return lhs.code == rhs.code
            && lhs.message == rhs.message
            && lhs.userMessage == rhs.userMessage
    }
}
