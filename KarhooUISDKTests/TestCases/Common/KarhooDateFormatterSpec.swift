//
//  KarhooDateFormatterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooUISDK
import KarhooUISDKTestUtils

// NOTE: These tests are assuming the simulator's region is set to UK - not USA.
class KarhooDateFormatterSpec: KarhooTestCase {
    private let locale = Locale(identifier: "en_GB")

    /**
     * Given: A date object is given to DateFormatter date function: Fri, 12 May 2017 10:12:13
     * When: The timezone is Timezone == UTC + 0
     * Then: A string should be returned that equals 10:12
     */
    func testPrebookDateTimeFormatter() {
        let date = Date(timeIntervalSince1970: 1494583933)

        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(secondsFromGMT: 0)!, locale: locale)
        let timeString = prebookFormatter.display(shortStyleTime: date)

        XCTAssert(timeString == "10:12")
    }

    /**
     * Given: A date object is given to DateFormatter date function: Fri, 12 May 2017 10:12:13 London
     * When: The timezone is Timezone == UTC + 0
     * Then: A string should be returned that equals '12 May 2017'
     */
    func testPrebookDateFormatInLondon() {
        let date = Date(timeIntervalSince1970: 1494583933)

        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(secondsFromGMT: 0)!, locale: locale)
        let dateString = prebookFormatter.display(mediumStyleDate: date)
       XCTAssert(dateString == "12 May 2017")
    }

    /**
     * Given: A date object is given to DateFormatter date function Fri, 12 May 2017 10:12:13
     * When: The timezone is CET (Paris)
     * Then: A string should be returned that equals 12:12
     */
    func testPrebookDateTimeFormatterInParis() {
        let date = Date(timeIntervalSince1970: 1494583933)

        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(abbreviation: "CET")!, locale: locale)
        let timeString = prebookFormatter.display(shortStyleTime: date)

        XCTAssert(timeString == "12:12")
    }

    /**
     * Given: A date object is given to DateFormatter MEDIUM STYLE function: Fri, 12 May 2017 23:59:13 +00
     * When: The timezone is Timezone == UTC + 10 (Sydny)
     * Then: A string should be returned that equals '13 May 2017'
     */
    func testPrebookDateInSydney() {
        let date = Date(timeIntervalSince1970: 1494633563)

        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(identifier: "Australia/Sydney")!, locale: locale)
        let dateString = prebookFormatter.display(mediumStyleDate: date)
        XCTAssert(dateString == "13 May 2017")
    }

    /**
     * Given: A date object is given to DateFormatter DETAIL DATE function: Fri, 12 May 2017 23:59:13 +00
     * When: The timezone is Timezone == UTC + 10 (Sydny)
     * Then: A string should be returned that equals '13 May 2017 at 09:59'
     */
    func testDetailDateDisplay() {
        let date = Date(timeIntervalSince1970: 1494633563)

        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(identifier: "Australia/Sydney")!, locale: locale)
        let dateString = prebookFormatter.display(detailStyleDate: date)

        XCTAssert(dateString == "13 May 2017 at 09:59")
    }

    /**
     * Given: A date that is nil (an optional)
     * And:   A time that is nil
     * Then:  An empty string should be returned
     */
    func testNilDate() {
        let prebookFormatter = KarhooDateFormatter(timeZone: TimeZone(secondsFromGMT: 0)!, locale: locale)
        let timeString = prebookFormatter.display(shortStyleTime: nil)
        let dateString = prebookFormatter.display(mediumStyleDate: nil)

        XCTAssert(timeString == "")
        XCTAssert(dateString == "")
    }
 }
