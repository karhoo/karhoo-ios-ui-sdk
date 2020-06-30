//
//  DatePickerMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol DatePickerView: BaseViewController {
    typealias DateSetCallback = (Date) -> Void
    typealias CancelCallback = () -> Void

    func set(date: Date)

    func setDatePicker(timeZone: TimeZone)

    func setBoundries(min: Date, max: Date)

    func set(timeZoneMessageText: String)

    func set(timeZoneMessageHidden: Bool)
}

protocol DatePickerPresenter {

    func viewShown()

    func viewWillShow()

    func dateDidChange(newDate: Date)

    func setDate()

    func cancel()

    func set(view: DatePickerView?)
}
