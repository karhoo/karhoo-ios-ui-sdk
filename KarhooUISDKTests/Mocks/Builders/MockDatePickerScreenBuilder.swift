//
//  MockDatePickerScreenFactory.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final class MockDatePickerScreenBuilder: DatePickerScreenBuilder {

    private(set) var startDateSet: Date?
    private(set) var timeZoneSet: TimeZone?
    private(set) var callbackSet: ScreenResultCallback<Date>?
    let returnViewController = UIViewController()

    func buildDatePickerScreen(startDate: Date?,
                               timeZone: TimeZone,
                               callback: @escaping ScreenResultCallback<Date>) -> Screen {
        startDateSet = startDate
        timeZoneSet = timeZone
        callbackSet = callback

        return returnViewController
    }

    func triggerScreenResult(_ result: ScreenResult<Date>) {
        self.callbackSet?(result)
    }
}
