//
//  QtaStringFormatterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import Foundation
import KarhooUISDK

final class QtaStringFormatterSpec: KarhooTestCase {

    /**
      * When: A minimum eta of 2 mins and a maximum of 5
      * Then: The formatter should return "2-5 min"
      */
    func testExpectedFormatting() {
        let formatted = QtaStringFormatter().qtaString(min: 2, max: 5)
        XCTAssertEqual(formatted, "2-5 \(UITexts.Generic.minutes)")
    }

    /**
      * When: A minimum eta of 2 mins a nil maximum eta
      * Then: The formatter should return "2 min"
      */
    func testSingleNilValueFormatting() {
        let formatted = QtaStringFormatter().qtaString(min: 2, max: nil)
        XCTAssertEqual(formatted, "2 \(UITexts.Generic.minutes)")
    }

    /**
      * When: a nil minimum and a nil maximum eta
      * Then the formatter should return a blank string
      */
    func testNilValueFormatting() {
        let formatted = QtaStringFormatter().qtaString(min: nil, max: nil)
        XCTAssertEqual(formatted, "")
    }

    /**
      * When: a minimum eta of 0 mins and a maximum of 3 min
      * Then: the formatter should return "3 min"
      */
    func testZeroMinFormatting() {
        let formatted = QtaStringFormatter().qtaString(min: 0, max: 3)
        XCTAssertEqual(formatted, "3 \(UITexts.Generic.minutes)")
    }
    
    /**
     * When: a minimum eta of 0 mins and a maximum of 0 mins (returned for prebook quotes)
     * Then: the formatter should return a blank string
     */
    func testZeroMinAndMaxFormatting() {
        let formatted = QtaStringFormatter().qtaString(min: 0, max: 0)
        XCTAssertEqual(formatted, "")
    }
}
