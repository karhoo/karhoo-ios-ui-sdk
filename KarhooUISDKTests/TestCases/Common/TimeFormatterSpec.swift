//
//  TimeFormatterSpec.swift
//  KarhooUISDKTests
//
//  Created by Cosmin Badulescu on 09.04.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import Foundation

import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class TimeFormatterSpec: KarhooTestCase {

    /**
      * When: Minutes are 30
      * Then: The formatter should return "30 minutes"
      */
    func testMinutesExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 30)
        XCTAssertEqual(formatted, "30 minutes")
    }
    
    /**
      * When: Minutes are 1
      * Then: The formatter should return "1 minute"
      */
    func testMinuteExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 1)
        XCTAssertEqual(formatted, "1 minute")
    }
    
    /**
      * When: Minutes are 0
      * Then: The formatter should return "0 minutes"
      */
    func testNoMinutesExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 0)
        XCTAssertEqual(formatted, "0 minutes")
    }
    
    /**
      * When: Minutes are 60
      * Then: The formatter should return "1 hour"
      */
    func testHourExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 60)
        XCTAssertEqual(formatted, "1 hour")
    }
    
    /**
      * When: Minutes are 61
      * Then: The formatter should return "1 hour and 1 minute"
      */
    func testHourMinuteExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 61)
        XCTAssertEqual(formatted, "1 hour and 1 minute")
    }
    
    /**
      * When: Minutes are 601
      * Then: The formatter should return "10 hours and 1 minute"
      */
    func testHoursMinuteExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 601)
        XCTAssertEqual(formatted, "10 hours and 1 minute")
    }
    
    /**
      * When: Minutes are 70
      * Then: The formatter should return "1 hour and 10 minutes"
      */
    func testHourMinutesExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 70)
        XCTAssertEqual(formatted, "1 hour and 10 minutes")
    }
    /**
      * When: Minutes are 610
      * Then: The formatter should return "10 hours and 10 minutes"
      */
    func testHoursMinutesExpectedFormatting() {
        let formatted = TimeFormatter().minutesAndHours(timeInMinutes: 610)
        XCTAssertEqual(formatted, "10 hours and 10 minutes")
    }
}
