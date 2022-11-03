//
//  MockValidator.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockValidatorListener: ValidatorListener {

    var invalidCalled = false
    var invalidReason: String?
    func invalid(reason: String?) {
        invalidCalled = true
        invalidReason = reason
    }

    var validCalled = false
    func valid() {
        validCalled = true
    }
}

class MockValidator: Validator {

    var listenerSet: ValidatorListener?
    func set(listener: ValidatorListener?) {
        listenerSet = listener
    }

    var validateTextSet: String?
    func validate(text: String) {
        validateTextSet = text
    }
}
