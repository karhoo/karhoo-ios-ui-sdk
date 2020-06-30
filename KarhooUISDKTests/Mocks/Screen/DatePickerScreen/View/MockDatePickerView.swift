//
//  MockDatePickerView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockDatePickerView: MockBaseViewController, DatePickerView {
    
    private(set) var theTimeZoneSet: TimeZone?
    func setDatePicker(timeZone: TimeZone) {
        theTimeZoneSet = timeZone
    }

    private(set) var theTimeZoneMessageText: String?
    func set(timeZoneMessageText: String) {
        theTimeZoneMessageText = timeZoneMessageText
    }

    private(set) var timeZoneMessageHiddenSet: Bool = false
    func set(timeZoneMessageHidden: Bool) {
        timeZoneMessageHiddenSet = timeZoneMessageHidden
    }

    private(set) var dateSet: Date?
    func set(date: Date) {
        dateSet = date
    }

    private(set) var minDateSet: Date?
    private(set) var maxDateSet: Date?
    func setBoundries(min: Date, max: Date) {
        minDateSet = min
        maxDateSet = max
    }
}
