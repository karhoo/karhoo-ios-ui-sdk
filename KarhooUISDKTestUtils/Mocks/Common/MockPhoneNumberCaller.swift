//
//  MockPhoneNumberCaller.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

public class MockPhoneNumberCaller: PhoneNumberCallerProtocol {
    public init() {}

    public var numberCalled: String?

    public func call(number: String) {
        numberCalled = number
    }
}
