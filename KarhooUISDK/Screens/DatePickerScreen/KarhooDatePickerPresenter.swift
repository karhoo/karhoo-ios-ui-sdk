//
//  KarhooDatePickerPresenter.swift
//  Karhoo
//
//
//  Copyright © 2016 Karhoo Ltd. All rights reserved.
//

import Foundation

private let SEC_PER_HOUR: TimeInterval = 60 * 60
private let SEC_PER_YEAR: TimeInterval = SEC_PER_HOUR * 24 * 365
private let MAX_PREBOOK_TIME: TimeInterval =  SEC_PER_YEAR

final class KarhooDatePickerPresenter: DatePickerPresenter {

    private let callback: ScreenResultCallback<Date>
    private let analytics: Analytics
    private weak var view: DatePickerView?
    private var initialDate: Date = Date()
    private var minDate: Date = Date()
    private var maxDate: Date = Date()
    private let timeZone: TimeZone
    private var now: Date
    private let timeIntervalHelper: DateTimeIntervalHelper
    private let roundingTime: TimeInterval = 60 * 5 // seconds

    // MARK: - Init functions
    required init(startDate: Date? = nil,
                  now: Date = Date(),
                  timeZone: TimeZone,
                  analytics: Analytics = KarhooAnalytics(),
                  timeIntervalHelper: DateTimeIntervalHelper = TimeSinceNowProvider(),
                  callback: @escaping ScreenResultCallback<Date>) {
        self.callback = callback
        self.analytics = analytics
        self.timeZone = timeZone
        self.now = now
        self.timeIntervalHelper = timeIntervalHelper
        self.minDate = calculateMinDate()
        self.maxDate = calculateMaxDate()

        if let start = startDate {
            let forced = forceToBoundries(date: start)
            initialDate = rounded(date: forced)
        } else {
            initialDate = minDate
        }
    }

    func viewShown() {
        view?.setBoundries(min: minDate, max: maxDate)
        view?.set(date: initialDate)
        analytics.prebookOpened()
    }

    func viewWillShow() {
        applyTimeZoneToScreen()
    }

    func set(view: DatePickerView?) {
        self.view = view
    }

    func dateDidChange(newDate: Date) {
        let forcedDate = forceToBoundries(date: newDate)
        let roundedDate = rounded(date: forcedDate)
        initialDate = roundedDate
        view?.set(date: initialDate)
    }

    func setDate() {
        if attemptingPrebookWithinTheHour() {
            view?.showAlert(title: nil, message: UITexts.Errors.prebookingWithinTheHour)
            now = Date()
            dateDidChange(newDate: calculateMinDate())
            return
        }

        finishWithResult(ScreenResult.completed(result: initialDate))
        analytics.prebookTimeSet(date: initialDate)
    }

    func cancel() {
        finishWithResult(ScreenResult.cancelled(byUser: true))
    }

    // MARK: - Private functions
    private func calculateMinDate() -> Date {
        var minDate = validDate(hoursInAdvance: 1)
        minDate = rounded(date: minDate)
        return minDate
    }

    private func attemptingPrebookWithinTheHour() -> Bool {
        return timeIntervalHelper.intervalSinceNow(forDate: initialDate) < SEC_PER_HOUR
    }

    private func calculateMaxDate() -> Date {
        return Date().addingTimeInterval(MAX_PREBOOK_TIME)
    }

    private func forceToBoundries(date: Date) -> Date {
        let dateTimeInterval = date.timeIntervalSince1970
        let minTimeInterval = minDate.timeIntervalSince1970
        let maxTimeInterval = maxDate.timeIntervalSince1970

        var date = date
        if dateTimeInterval < minTimeInterval {
            date = minDate
        } else if dateTimeInterval > maxTimeInterval {
            date = maxDate
        }
        return date
    }

    private func validDate(hoursInAdvance: Int) -> Date {
        let roundedNow = rounded(date: nil)
        let factor = TimeInterval(hoursInAdvance)
        let date = Date(timeInterval: SEC_PER_HOUR * factor, since: roundedNow)
        return date
    }

    private func rounded(date: Date?) -> Date {
        let dateToRound = date ?? now
        let roundingInterval = dateToRound.timeIntervalSinceReferenceDate
        let seconds = ceil(roundingInterval / roundingTime) * roundingTime
        return Date(timeIntervalSinceReferenceDate: seconds)
    }

    private func applyTimeZoneToScreen() {
        view?.setDatePicker(timeZone: timeZone)
        let bookingInTheSameTimeZone = timeZone.abbreviation() == TimeZone.current.abbreviation()

        if bookingInTheSameTimeZone {
            view?.set(timeZoneMessageHidden: true)
        } else {
            guard let abbreviation = timeZone.abbreviation() else {
                view?.set(timeZoneMessageHidden: true)
                return
            }

            view?.set(timeZoneMessageHidden: false)
            view?.set(timeZoneMessageText: String(format: UITexts.Prebook.timeZoneMessage, abbreviation))
        }
    }

    private func finishWithResult(_ result: ScreenResult<Date>) {
        callback(result)
    }
}
