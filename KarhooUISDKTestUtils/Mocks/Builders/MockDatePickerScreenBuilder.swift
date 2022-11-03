//
//  MockDatePickerScreenFactory.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit
@testable import KarhooUISDK

final public class MockDatePickerScreenBuilder: DatePickerScreenBuilder {

    public var startDateSet: Date?
    public var timeZoneSet: TimeZone?
    public var callbackSet: ScreenResultCallback<Date>?
    public let returnViewController = UIViewController()

    public func buildDatePickerScreen(startDate: Date?,
                               timeZone: TimeZone,
                               callback: @escaping ScreenResultCallback<Date>) -> Screen {
        startDateSet = startDate
        timeZoneSet = timeZone
        callbackSet = callback

        return returnViewController
    }

    public func triggerScreenResult(_ result: ScreenResult<Date>) {
        self.callbackSet?(result)
    }
}
