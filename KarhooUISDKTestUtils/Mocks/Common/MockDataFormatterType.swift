//
//  MockDataFormatterType.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

public class MockDateFormatterType: DateFormatterType {

    public init() { }

    public var timeZoneSet: TimeZone?
    public func set(timeZone: TimeZone) {
        timeZoneSet = timeZone
    }

    public var localeSet: Locale?
    public func set(locale: Locale) {
        localeSet = locale
    }

    public var shortStyleTimeSet: Date?
    public var shortStyleTimeReturnString: String = TestUtil.getRandomString()
    public func display(shortStyleTime date: Date?) -> String {
        shortStyleTimeSet = date
        return shortStyleTimeReturnString
    }

    public var mediumStyleDateSet: Date?
    public var mediumStyleDateReturnString: String = TestUtil.getRandomString()
    public func display(mediumStyleDate date: Date?) -> String {
        mediumStyleDateSet = date
        return mediumStyleDateReturnString
    }

    public var shortDateSet: Date?
    public var shortDateReturnString: String = TestUtil.getRandomString()
    public func display(shortDate date: Date?) -> String {
        shortDateSet = date
        return shortDateReturnString
    }

    public var detailStyleDateSet: Date?
    public var detailStyleDateReturnString: String = TestUtil.getRandomString()
    public func display(detailStyleDate date: Date?) -> String {
        detailStyleDateSet = date
        return detailStyleDateReturnString
    }

    public var fullDateSet: Date?
    public var fullDateReturnString: String = TestUtil.getRandomString()
    public func display(fullDate date: Date?) -> String {
        fullDateSet = date
        return fullDateReturnString
    }

    public var clockTimeSet: Date?
    public var clockTimeReturnString: String = TestUtil.getRandomString()
    public func display(clockTime date: Date?) -> String {
        clockTimeSet = date
        return clockTimeReturnString
    }

    public var displayCustomDateTimeSet: Date?
    public var displayCustomDateTimeReturnString: String = TestUtil.getRandomString()
    public func display(_ date: Date?, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        displayCustomDateTimeSet = date
        return displayCustomDateTimeReturnString
    }
    
    public var fullLocalizedTimeSet: Date?
    public var fullLocalizedTimeReturnString: String = TestUtil.getRandomString()
    public func display(fullLocalizedTime date: Date?) -> String {
        fullLocalizedTimeSet = date
        return fullLocalizedTimeReturnString
    }
}
