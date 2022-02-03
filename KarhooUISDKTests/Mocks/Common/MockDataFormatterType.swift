//
//  MockDataFormatterType.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockDateFormatterType: DateFormatterType {

    private(set) var timeZoneSet: TimeZone?
    func set(timeZone: TimeZone) {
        timeZoneSet = timeZone
    }

    private(set) var localeSet: Locale?
    func set(locale: Locale) {
        localeSet = locale
    }

    private(set) var shortStyleTimeSet: Date?
    var shortStyleTimeReturnString: String = TestUtil.getRandomString()
    func display(shortStyleTime date: Date?) -> String {
        shortStyleTimeSet = date
        return shortStyleTimeReturnString
    }

    private(set) var mediumStyleDateSet: Date?
    var mediumStyleDateReturnString: String = TestUtil.getRandomString()
    func display(mediumStyleDate date: Date?) -> String {
        mediumStyleDateSet = date
        return mediumStyleDateReturnString
    }

    private(set) var shortDateSet: Date?
    var shortDateReturnString: String = TestUtil.getRandomString()
    func display(shortDate date: Date?) -> String {
        shortDateSet = date
        return shortDateReturnString
    }

    private(set) var detailStyleDateSet: Date?
    var detailStyleDateReturnString: String = TestUtil.getRandomString()
    func display(detailStyleDate date: Date?) -> String {
        detailStyleDateSet = date
        return detailStyleDateReturnString
    }

    private(set) var fullTimeSet: Date?
    var fullTimeReturnString: String = TestUtil.getRandomString()
    public func display(fullDate date: Date?) -> String {
        fullTimeSet = date
        return fullTimeReturnString
    }

    private(set) var clockTimeSet: Date?
    var clockTimeReturnString: String = TestUtil.getRandomString()
    func display(clockTime date: Date?) -> String {
        clockTimeSet = date
        return clockTimeReturnString
    }
}
