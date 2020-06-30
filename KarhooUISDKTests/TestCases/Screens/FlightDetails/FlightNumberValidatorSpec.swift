//
//  FlightNumberValidatorSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooUISDK

final class FlightNumberValidatorSpec: XCTestCase {

    private var testObject: FlightNumberValidator!
    private var mockValidatorListener: MockValidatorListener!

    override func setUp() {
        super.setUp()
        mockValidatorListener = MockValidatorListener()
        testObject = FlightNumberValidator()
        testObject.set(listener: mockValidatorListener)
    }

    /**
      * When: Validating an empty string
      * Then: No validation should take place
      */
    func testEmptyStringValidation() {
        testObject.validate(text: "")
        XCTAssertFalse(mockValidatorListener.validCalled)
    }

    /**
      * When: Validating an invalid flight number
      * Then: Invalid should be called
      *  And: No reason should be provided
      */
    func testInvalidFlightNumber() {
        testObject.validate(text: "1")
        XCTAssertTrue(mockValidatorListener.invalidCalled)
        XCTAssertTrue(mockValidatorListener.invalidReason!.isEmpty)
    }

    /**
      * When: Validating a valid flight number
      * Then: Valid should be called
      */
    func testValidFlightNumber() {
        testObject.validate(text: "LH4232")
        XCTAssertTrue(mockValidatorListener.validCalled)
    }
}
