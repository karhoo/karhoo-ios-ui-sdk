//
//  FlightDetailsPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
@testable import KarhooUISDK

class FlightDetailsPresenterSpec: XCTestCase {

    private var testObject: KarhooFlightDetailsPresenter!
    private var testCallback: ScreenResult<FlightDetails>?
    private var mockFlightDetailsView: MockFlightDetailsView!

    override func setUp() {
        mockFlightDetailsView = MockFlightDetailsView()
        testObject = KarhooFlightDetailsPresenter(completion: airportScreenCallback)
        testObject.load(view: mockFlightDetailsView)
    }

    /**
      * When: the screen will appear
      * Then: Presenter should tell screen to set up UI
      */
    func testScreenWillAppear() {
        testObject.screenWillAppear()
        XCTAssertTrue(mockFlightDetailsView.setUpUICalled)
        XCTAssertTrue(mockFlightDetailsView.startKeyboardListenerCalled)
    }

    /**
      * When: The user presses cancel
      * Then: Callback should be cancelled by user
      * And: Keyboard should resign
      */
    func testCancelPressed() {
        testObject.screenWillAppear()
        testObject.didPressCancel()

        XCTAssert(testCallback?.isCancelledByUser() == true)
        XCTAssertTrue(mockFlightDetailsView.unfocusInputCalled)
    }

    /**
      * When: The flight number field is focused
      * Then: the screen should update the placeholder text with flight number validation message
      */
    func testFlightNumberFieldFocused() {
        testObject.fieldDidFocus(identifier: AirportFields.flightNumber.rawValue)
        XCTAssertEqual(UITexts.Errors.flightNumberValidatorError, mockFlightDetailsView.flightNumberPlaceHolderSet)
    }

    /**
     * Given: The flight number field is unfocused
     * When: no flight number has been set
     * Then: the screen should update the placeholder text with default placeholder (Flight Number)
     */
    func testFlightNumberFieldUnfocusedWithNoInput() {
        testObject.fieldDidUnFocus(identifier: AirportFields.flightNumber.rawValue)
        XCTAssertEqual(UITexts.Airport.flightNumber, mockFlightDetailsView.flightNumberPlaceHolderSet)
    }

    /**
     * Given: The flight number field is unfocused
     * When: A flight number has been set and it is valid
     * Then: the screen should update the placeholder text with default placeholder (Flight Number)
     */
    func testFlightNumberFieldUnfocusedWithValidInput() {
        testObject.didChange(text: "AA123", isValid: true, identifier: AirportFields.flightNumber.rawValue)
        testObject.fieldDidUnFocus(identifier: AirportFields.flightNumber.rawValue)
        XCTAssertEqual(UITexts.Airport.flightNumber, mockFlightDetailsView.flightNumberPlaceHolderSet)
    }
    
    /**
      * When: Flight number is empty
      * Then: Formbutton should be disabled
      */
    func testEmptyFlightNumber() {
        testObject.didChange(text: "", isValid: false, identifier: AirportFields.flightNumber.rawValue)
        XCTAssert(mockFlightDetailsView.formButtonEnabledSet == false)
    }

    /**
      * When: A valid flight number is present
      * Then: Formbutton should be enabled
      */
    func testValidFlightNumberEntered() {
        testObject.didChange(text: "LL123", isValid: true, identifier: AirportFields.flightNumber.rawValue)
        XCTAssert(mockFlightDetailsView.formButtonEnabledSet == true)
    }

    /**
     * When: A flight number is invalid
     * Then: Formbutton should be disabled
     */
    func testInvalidlightNumberLength() {
        testObject.didChange(text: "12", isValid: false, identifier: AirportFields.flightNumber.rawValue)
        XCTAssert(mockFlightDetailsView.formButtonEnabledSet == false)
    }

    /**
     * Given: User presses continue
     * When: Only a flight number has been entered
     * Then: flight number should be passed in compeltion handler
     * And: Additional information string should be nil
     * And: Keyboard should resign
     */
    func testContinueWithFlightNumber() {
        testObject.didChange(text: "123", isValid: true, identifier: AirportFields.flightNumber.rawValue)
        testObject.didPressContinue()

        XCTAssertNil(testCallback?.completedValue()?.comments)
        XCTAssert(testCallback?.completedValue()?.flightNumber == "123")
        XCTAssertTrue(mockFlightDetailsView.unfocusInputCalled)
    }

    /**
     * Given: User presses continue
     * When:  a flight number AND additional information has been entered
     * Then: flight number and additional information should be passed in compeltion handler
     * And: the keyboard should resign
     */
    func testContinueWithFlightNumberAndNotes() {
        testObject.didChange(text: "123", isValid: true, identifier: AirportFields.flightNumber.rawValue)
        testObject.didSet(additionalInformation: "1234")
        testObject.didPressContinue()

        XCTAssert(testCallback?.completedValue()?.comments == "1234")
        XCTAssert(testCallback?.completedValue()?.flightNumber == "123")
        XCTAssertTrue(mockFlightDetailsView.unfocusInputCalled)
    }

    private func airportScreenCallback(result: ScreenResult<FlightDetails>?) {
        testCallback = result
    }
}
