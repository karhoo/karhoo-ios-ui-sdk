//
//  KarhooPrebookConfirmationPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class KarhooPrebookConfirmationPresenterSpec: XCTestCase {

    private var mockView: MockPrebookConfirmationView!
    private var mockQuote: Quote!
    private var mockBookingDetails: BookingDetails!
    private var mockCallback: ScreenResult<PrebookConfirmationAction>?
    private var testObject: KarhooPrebookConfirmationPresenter!

    override func setUp() {
        super.setUp()
        mockCallback = nil
        mockView = MockPrebookConfirmationView()
        mockQuote = TestUtil.getRandomQuote()
        mockBookingDetails = TestUtil.getRandomBookingDetails()
        testObject = KarhooPrebookConfirmationPresenter(quote: mockQuote,
                                                        bookingDetails: mockBookingDetails,
                                                        callback: prebookConfirmationCallback)
        testObject.load(view: mockView)
    }

    /**
     * When: The screen loads
     * Then: the view model should be set
     */
    func testUIUpdates() {
        XCTAssertNotNil(mockView.viewModelSet)
    }

    /**
     * When: user taps screen
     * Then: callback should be called
     */
    func testTapScreenCallsCallback() {
        testObject.didTapScreen()
        XCTAssertEqual(.close, mockCallback?.completedValue())
    }

    /**
     * When: user taps button
     * Then: callback should be called
     */
    func testTapButtonCallsCallback() {
        testObject.didTapPopupButton()
        XCTAssertEqual(.rideDetails, mockCallback?.completedValue())
    }

    /**
     * When: user taps close button
     * Then: callback should be called
     */
    func testTapCloseCallsCallback() {
        testObject.didTapClose()
        XCTAssertEqual(.close, mockCallback?.completedValue())
    }

    private func prebookConfirmationCallback(result: ScreenResult<PrebookConfirmationAction>?) {
        mockCallback = result
    }
}
