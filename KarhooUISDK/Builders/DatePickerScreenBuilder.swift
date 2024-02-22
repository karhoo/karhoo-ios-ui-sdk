//
//  DatePickerScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol DatePickerScreenBuilder {
    func buildDatePickerScreen(startDate: Date?,
                               timeZone: TimeZone,
                               callback: @escaping ScreenResultCallback<Date>) -> Screen
}
