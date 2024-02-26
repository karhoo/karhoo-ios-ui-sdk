//
//  PopupDialogPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

class PopupDialogPresenterSpec: KarhooTestCase {

    private var testObject: PopupDialogPresenter!
    private var testCallback: ScreenResult<Void>?
    private var mockView: MockPopupDialogView!

    override func setUp() {
        super.setUp()
        mockView = MockPopupDialogView()
        testObject = KarhooPopupDialogPresenter(callback: popupDialogCallback)
        testObject.load(view: mockView)
    }

    /**
      * When: Tapping screen
      * And: The callback should be cancelled by user
      * And: View should dismiss
      */
    func testTapDismiss() {
        testObject.didTapScreen()
        XCTAssert(testCallback?.isCancelledByUser() == true)
    }

    /**
     * When: Tapping main popup button
     * And: The callback should be cancelled by user
     * And: View should dismiss
     */
    func testTapDismissByPopupButton() {
        testObject.didTapPopupButton()
        XCTAssert(testCallback?.isCancelledByUser() == true)
    }

    /**
      * When: The screen loads
      * Then: the dialog message should be set
      * And: the form button title should be set
      */
    func testSettingCopy() {
        XCTAssert(mockView.theFormButtonTitleSet == UITexts.Generic.gotIt)
        XCTAssert(mockView.theDialogMessageSet == UITexts.Booking.baseFareExplanation)
        XCTAssert(mockView.theDialogTitleSet == UITexts.Booking.baseFare)
    }

    private func popupDialogCallback(result: ScreenResult<Void>?) {
        testCallback = result
    }
}
