//
//  StackButtonViewSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

/*  techDebt to test a UIView, that logic should really be in a presenter
    (see BookingHistoryActionButton and BookingHistoryDetailActionButton)
 */
class StackButtonViewSpec: KarhooTestCase {

    private var testObject: KarhooStackButtonView!
    private var actionTwoCalled: Bool!
    private var actionOneCalled: Bool!

    override func setUp() {
        super.setUp()
        testObject = KarhooStackButtonView()

//        testObject.resizingSwitcher = ResizingSwitcher() // normally loaded from xib

        actionOneCalled = false
        actionTwoCalled = false
    }
    /**
      * Given: One action button set
      * When: Button pressed
      * Then: Button one text set correctly and action caleld
      */
    func testOneActionSet() {
        pressedSingleButton()

        XCTAssert(testObject.buttonOneText == "BUTTON")
        XCTAssert(actionOneCalled == true)
    }

    /**
     * When: Two actions set
     * Then: Button one action and text should be set correctly
     * And: Button two action and text should be set correctly
     */
    func testTwoButtonsSet() {
        pressBothButtons()

        XCTAssert(testObject.buttonOneText == "BUTTON ONE")
        XCTAssert(actionOneCalled == true)

        XCTAssert(testObject.buttonTwoText == "BUTTON TWO")
        XCTAssert(actionTwoCalled == true)
    }

    /**
      * Given: Two button actions are set
      * When: One button action is set 
      * Then: button two action should be nil
      */
    func testTwoButtonsSetWhenOneButtonWasSet() {
        pressBothButtons()
        pressedSingleButton()

        XCTAssert(testObject.buttonOneText == "BUTTON")
        XCTAssert(actionOneCalled == true)
        XCTAssert(testObject.buttonTwoAction == nil)
    }

    private func pressBothButtons() {
        testObject.set(firstButtonText: "BUTTON ONE", firstButtonAction: {
            self.actionOneCalled = true
        }, secondButtonText: "BUTTON TWO", secondButtonAction: {
            self.actionTwoCalled = true
        })

        testObject.buttonOnePressed()
        testObject.buttonTwoPressed()
    }

    private func pressedSingleButton() {
        testObject.set(buttonText: "BUTTON", action: {
            self.actionOneCalled = true
        })
        testObject.buttonOnePressed()
    }
}
