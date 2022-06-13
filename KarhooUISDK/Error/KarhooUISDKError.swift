//
//  KarhooUISDKError.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol KarhooUIError: Error {
    var code: String { get }
    var message: String { get }
    var type: KarhooUIErrorType { get }
}

extension KarhooUIError {

    public var code: String { return "KUISDK" }
    public var message: String { return "" }

    public func equals(_ error: KarhooError?) -> Bool {
        return self.code == error?.code &&
            self.message == error?.message
    }

    public var type: KarhooUIErrorType {
        return KarhooUIErrorType(error: self)
    }
}

public struct ErrorModel: KarhooError {

    public let message: String
    public let code: String

    public init(message: String, code: String) {
        self.message = message
        self.code = code
    }
}
