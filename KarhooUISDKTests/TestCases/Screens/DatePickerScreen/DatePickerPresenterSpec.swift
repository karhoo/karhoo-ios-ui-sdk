//
//  DatePickerPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class DatePickerPresenterSpec: KarhooTestCase {

    private var mockView: MockDatePickerView!
    private var testAnalytics: MockAnalytics!
    private let sec_per_min: TimeInterval = 60
    private let sec_per_hour: TimeInterval = 60 * 60
    private let sec_per_year: TimeInterval = 60 * 60 * 24 * 365
    private let epsilonInterval: TimeInterval = 0.01
    private let MAX_PREBOOK_TIME: TimeInterval = 60*60*24*365
    private var sharedTestObject: DatePickerPresenter!
    private var testObjectCallback: ScreenResult<Date>?
    private var mockTimeSinceNow: MockTimeSinceNowProvider!

    override func setUp() {
        super.setUp()

        mockView = MockDatePickerView()
        testAnalytics = MockAnalytics()
        mockTimeSinceNow = MockTimeSinceNowProvider()
        mockTimeSinceNow.intervalToReturn = sec_per_hour
    }

    /**
     *  When:   The view is shown at a time that needs no rounding to the 
     *          nearest 5 min
     *  Then:   The correct date boundries shall be set
     */
    func testBoundriesOnViewShown() {
        simulateViewShown(initialDate: nil, timeZone: TimeZone.current)
        let expectedMaxDate = Date().addingTimeInterval(MAX_PREBOOK_TIME)
        let expectedMinDate = Date(timeIntervalSince1970: sec_per_hour)

        XCTAssert(mockView.minDateSet == expectedMinDate)
        XCTAssert(differenceBetween(firstDate: expectedMaxDate, secondDate: mockView.maxDateSet) < epsilonInterval)
        XCTAssertTrue(testAnalytics.prebookOpenedCalled)
    }

    private func differenceBetween(firstDate: Date?, secondDate: Date?) -> TimeInterval {
        return abs(firstDate!.timeIntervalSince1970  - secondDate!.timeIntervalSince1970)
    }
    /**
     *  When:   The view is shown at a time that needs rounding to the nearest
     *          5 min
     *  Then:   The correct date boundries shall be set
     */
    func testBoundriesOnViewShownRoundingNeeded() {
        let now = Date(timeIntervalSince1970: 17)
        simulateViewShown(initialDate: nil, timeZone: TimeZone.current, now: now)

        let oneHourAndFiveMin = TimeInterval(5) * sec_per_min + sec_per_hour
        let expectedMinDate = Date(timeIntervalSince1970: oneHourAndFiveMin)
        let expectedMaxDate = Date().addingTimeInterval(MAX_PREBOOK_TIME)

        XCTAssert(mockView.minDateSet == expectedMinDate)
        XCTAssert(differenceBetween(firstDate: mockView.maxDateSet, secondDate: expectedMaxDate) < epsilonInterval)
    }

    /**
     *  Given:  A start date has been set that is bigger than the min date
     *  When:   The view is shown
     *  Then:   The view should show the start date
     */
    func testStartDateOnViewShown() {
        let offset = TimeInterval(2) * sec_per_hour + 38
        let startDate = Date(timeIntervalSince1970: offset)
        simulateViewShown(initialDate: startDate, timeZone: TimeZone.current)

        let expectedOffset = TimeInterval(2) * sec_per_hour + TimeInterval(5) * sec_per_min
        let expectedDate = Date(timeIntervalSince1970: expectedOffset)
        XCTAssert(mockView.dateSet == expectedDate)
    }

    /**
      * Given: Timezone of origin is the same as the local timezone
      * When:  The view is shown
      * Then:  No message should be set
      * And:   Timezone message should be hidden
      */
    func testSameTimeZoneOriginAndLocalTime() {
        let timeZone = TimeZone.current
        simulateViewShown(initialDate: nil, timeZone: timeZone)

        XCTAssert(mockView.timeZoneMessageHiddenSet == true)
        XCTAssert(mockView.theTimeZoneSet == timeZone)
        XCTAssert(mockView.theTimeZoneMessageText == nil)
    }
/*
    /**
     * Given: Timezone of origin is different to the local timezone
     * When:  The view is shown
     * Then:  No message should be set to "Booking will be made in local time (timeZone abbreviation)
     */
    func testDifferentTimeZoneOriginAndLocalTime() {
        let timezone = TimeZone(identifier: "America/New_York")!
        simulateViewShown(initialDate: nil, timeZone: timezone)
        XCTAssert(mockView.timeZoneMessageHiddenSet == false)
        XCTAssert(mockView.theTimeZoneSet == timezone)
        
        let localisedMessage = UITexts.Prebook.timeZoneMessage.replacingOccurrences(of: " (%1$@)", with: "")
        XCTAssertEqual(mockView.theTimeZoneMessageText, "\(localisedMessage) (\(timezone.abbreviation()!))")
    }
 */

    /**
     *  Given:  A start date has been set that is smaller than the min date
     *  When:   The view is shown
     *  Then:   The view should show the start date
     */
    func testInvalidSmallStartDateOnViewShown() {
        let startDate = Date(timeIntervalSince1970: sec_per_hour - TimeInterval(5) * sec_per_min - 89)
        simulateViewShown(initialDate: startDate, timeZone: TimeZone.current)

        let expectedDate = mockView.minDateSet
        XCTAssert(mockView.dateSet == expectedDate)
    }

    /**
     *  Given:  A start date has been set that is bigger than the max date
     *  When:   The view is shown
     *  Then:   The view should show the start date
     */
    func testInvalidBigStartDateOnViewShown() {
        let startDate = Date().addingTimeInterval(MAX_PREBOOK_TIME + 10000)
        simulateViewShown(initialDate: startDate, timeZone: TimeZone.current)

        let expectedDate = mockView.maxDateSet
        XCTAssert(differenceBetween(firstDate: mockView.dateSet, secondDate: expectedDate) < sec_per_min * 5)
    }

    /**
     *  Given:  A start date has not been set
     *  When:   The view is shown
     *  Then:   The view should show the minimum date
     */
    func testNoStartDateOnViewShown() {
        simulateViewShown(initialDate: nil, timeZone: TimeZone.current)

        let expectedDate = mockView.minDateSet
        XCTAssert(mockView.dateSet == expectedDate)
    }

    /**
     *  When:   The date in the UI was changed to a correct value
     *   And:   When asking for the date
     *  Then:   The value set should be returned
     *   And:   PrebookTimeSet analytics event should be fired
     */
    func testDateChangedToValidValue() {
        let newDate = Date(timeIntervalSince1970: TimeInterval(5) * sec_per_min + sec_per_hour)
        let returnedDate = simulateDateChangeAndSet(date: newDate)

        XCTAssert(mockView.dateSet == newDate)
        XCTAssert(returnedDate == newDate)

        XCTAssertTrue(testAnalytics.prebookSetCalled)
    }

    /**
     *  When:   The date in the UI was changed to an incorrectly rounded value
     *   And:   When asking for the date
     *  Then:   The correctly rounded value should be returned
     *   And:   The screen should be forced to show the correctly rounded value
     */
    func testDateChangedToInvalidRounding() {
        let expectedTimeInterval = TimeInterval(5) * 2 * sec_per_min + sec_per_hour
        let newDate = Date(timeIntervalSince1970: expectedTimeInterval - 17)
        let returnedDate = simulateDateChangeAndSet(date: newDate)

        let expectedDate = Date(timeIntervalSince1970: expectedTimeInterval)
        XCTAssert(mockView.dateSet == expectedDate)
        XCTAssert(returnedDate == expectedDate)
    }

    /**
     *  When:   The date in the UI was changed to a too small value
     *   And:   When asking for the date
     *  Then:   The minimum value should be returned
     *   And:   The screen should be forced to show the minimum value
     */
    func testDateChangedToTooSmallValue() {
        let newDate = Date(timeIntervalSince1970: sec_per_hour - 10)
        let returnedDate = simulateDateChangeAndSet(date: newDate)

        let expectedDate = mockView.minDateSet
        XCTAssert(mockView.dateSet == expectedDate)
        XCTAssert(returnedDate == expectedDate)
    }

    /**
     *  When:   The date in the UI was changed to a too big value
     *   And:   When asking for the date
     *  Then:   The maximum value should be returned
     *   And:   The screen should be forced to show the maximum value
     */
    func testDateChangedToTooBigValue() {
        let newDate = Date().addingTimeInterval(MAX_PREBOOK_TIME + 10000)
        let returnedDate = simulateDateChangeAndSet(date: newDate)
        let expectedDate = mockView.maxDateSet

        // granularity is 5 min and that's what we compare to
        XCTAssert(differenceBetween(firstDate: mockView.dateSet, secondDate: expectedDate) < 60 * 5)
        XCTAssert(differenceBetween(firstDate: returnedDate, secondDate: expectedDate) < 60 * 5)
    }

    /**
     *  When:   Cancelling the date picker
     *  Then:   The callback should be called 
     */
    func testCancel() {
        var testCallbackCalled = false
        var callbackDate: Date?
        let testObject = KarhooDatePickerPresenter(startDate: nil,
                                                           timeZone: TimeZone.current,
                                                           analytics: testAnalytics,
                                                           callback: { (result: ScreenResult<Date>) in
            testCallbackCalled = true
            callbackDate = result.completedValue()
        })

        testObject.cancel()

        XCTAssert(testCallbackCalled)
        XCTAssertNil(callbackDate)
    }

    /**
      * When: Attempting to prebook within the current hour
      * Then: Alert handler should show relevant error message
      * And:  Screen setDate should be updated with new min date
      * NOTE: we could override the value from timeIntervalSinceNow
      *       Rather than injecting in a mock timeIntervalProvider
              For now this tests the logic.
      */
    func testPrebookingWithinTheHour() {
        let testObjectShown = simulateViewShown(initialDate: Date(), timeZone: TimeZone.current)

        /// simulates time between now and initialDate being less than an hour
        mockTimeSinceNow.intervalToReturn = 1

        testObjectShown.setDate()

        XCTAssertEqual(mockView.showAlertMessage, UITexts.Errors.prebookingWithinTheHour)
        XCTAssertNil(testObjectCallback)
        XCTAssert(differenceBetween(firstDate: Date(), secondDate: mockView.dateSet) > sec_per_hour)
    }

    @discardableResult
    private func simulateViewShown(initialDate: Date?,
                                   timeZone: TimeZone,
                                   now: Date = Date(timeIntervalSince1970: 0)) -> DatePickerPresenter {
        let testObject = KarhooDatePickerPresenter(startDate: initialDate,
                                                   now: now,
                                                   timeZone: timeZone,
                                                   analytics: testAnalytics,
                                                   timeIntervalHelper: mockTimeSinceNow,
                                                   callback: datePickerCallback)
        testObject.set(view: mockView)
        testObject.viewWillShow()
        testObject.viewShown()
        return testObject
    }

    private func simulateDateChangeAndSet(date: Date, now: Date = Date(timeIntervalSince1970: 0)) -> Date? {
        var returnedDate: Date?
        let testObject = KarhooDatePickerPresenter(now: now,
                                                   timeZone: TimeZone.current,
                                                   analytics: testAnalytics,
                                                   timeIntervalHelper: mockTimeSinceNow,
                                                   callback: { (result: ScreenResult<Date>) in
            returnedDate = result.completedValue()
        })
        testObject.set(view: mockView)
        testObject.viewShown()

        testObject.dateDidChange(newDate: date)
        testObject.setDate()

        return returnedDate
    }

    private func datePickerCallback(result: ScreenResult<Date>?) {
        testObjectCallback = result
    }
}
