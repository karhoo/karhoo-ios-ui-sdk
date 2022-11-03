//
//  MockPhoneNumberCaller.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

class MockPhoneNumberCaller: PhoneNumberCallerProtocol {
    private(set) var numberCalled: String?

    func call(number: String) {
        numberCalled = number
    }
}
