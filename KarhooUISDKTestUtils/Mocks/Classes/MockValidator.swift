//
//  MockValidator.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

public class MockValidatorListener: ValidatorListener {

    public var invalidCalled = false
    public var invalidReason: String?
    public func invalid(reason: String?) {
        invalidCalled = true
        invalidReason = reason
    }

    public var validCalled = false
    public func valid() {
        validCalled = true
    }
}

public class MockValidator: Validator {

    public var listenerSet: ValidatorListener?
    public func set(listener: ValidatorListener?) {
        listenerSet = listener
    }

    public var validateTextSet: String?
    public func validate(text: String) {
        validateTextSet = text
    }
}
