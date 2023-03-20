//
//  MockDatePickerView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockDatePickerView: MockBaseViewController, DatePickerView {
    
    public var theTimeZoneSet: TimeZone?
    public func setDatePicker(timeZone: TimeZone) {
        theTimeZoneSet = timeZone
    }

    public var theTimeZoneMessageText: String?
    public func set(timeZoneMessageText: String) {
        theTimeZoneMessageText = timeZoneMessageText
    }

    public var timeZoneMessageHiddenSet: Bool = false
    public func set(timeZoneMessageHidden: Bool) {
        timeZoneMessageHiddenSet = timeZoneMessageHidden
    }

    public var dateSet: Date?
    public func set(date: Date) {
        dateSet = date
    }

    public var minDateSet: Date?
    public var maxDateSet: Date?
    public func setBoundries(min: Date, max: Date) {
        minDateSet = min
        maxDateSet = max
    }
    
    public var localeSet: Locale?
    public func set(locale: Locale) {
        localeSet = locale
    }
}
