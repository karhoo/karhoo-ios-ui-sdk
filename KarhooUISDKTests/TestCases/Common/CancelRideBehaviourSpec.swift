//
//  CancelRideBehaviourSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class CancelRideBehaviourSpec: XCTestCase {

    private var mockAlertHandler: MockAlertHandler!
    private var testDelegateInstance: TestCancelRideDelegate!
    private var mockPhoneNumberCaller: MockPhoneNumberCaller!
    private var testObject: CancelRideBehaviour!
    private var testTrip: TripInfo = TestUtil.getRandomTrip(state: .driverEnRoute)
    override func setUp() {
        super.setUp()
        mockAlertHandler = MockAlertHandler()
        testDelegateInstance = TestCancelRideDelegate()
        mockPhoneNumberCaller = MockPhoneNumberCaller()

        testObject = CancelRideBehaviour(trip: testTrip,
                                         delegate: testDelegateInstance,
                                         alertHandler: mockAlertHandler,
                                         phoneNumberCaller: mockPhoneNumberCaller)
    }

    /**
     *  When:   Cancel booking triggered
     *  Then:   Confirmation alert should be presented
     *  And:    Second button should be 'yes'
     */
    func testConfirmationAlert() {
        testObject.triggerCancelRide()

        XCTAssert(mockAlertHandler.alertMessage?.isEmpty == false)
        XCTAssert(mockAlertHandler.alertTitle?.isEmpty == false)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Journey.journeyCancelBookingConfirmationAlertTitle)
        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle, UITexts.Generic.yes)
    }

    /** 
     *  When:   Cancel booking request fails
     *  Then:   Error alert should be presented
     *  And:    Error alert positive action should be 'call...'
     */
    func testCancellationFailedAlert() {
        setCancelRequestMockToFail()
        triggerCancelRideAndPressYesInConfirmationAlert()

        XCTAssert(mockAlertHandler.alertMessage?.isEmpty == false)
        XCTAssert(mockAlertHandler.alertTitle?.isEmpty == false)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Journey.journeyCancelBookingFailedAlertTitle)
        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle,
                       UITexts.Journey.journeyCancelBookingFailedAlertCallFleetButton)
    }

    /** 
     *  Given:  Cancel booking failed alert is presented
     *  When:   'Call' button is pressed
     *  Then:   Phone number to supplier should be called
     */
    func testCallOnCancellationAlert() {
        setCancelRequestMockToFail()
        triggerCancelRideAndPressYesInConfirmationAlert()
        mockAlertHandler.triggerSecondAlertAction()

        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, testTrip.fleetInfo.phoneNumber)
    }

    /**
     *  Given:  Cancelling ride confirmed in an alert
     *  When:   Sending network request
     *  Then:   Loading indicator show be presented
     */
    func testShowLoadingIndicator() {
        triggerCancelRideAndPressYesInConfirmationAlert()

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertFalse(testDelegateInstance.hideLoadingOverlayCalled)
    }

    /**
     *  Given:  Sending cancel ride network request
     *  When:   Request succeeds
     *  Then:   Loading indicator should be dismissed
     *   And:   Confirmation message alert should be presented
     */
    func testDismissLoadingIndicatorOnSuccess() {
        setCancelRequestMockToSucceed()
        triggerCancelRideAndPressYesInConfirmationAlert()

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
    }

    /**
     *  Given:  Sending cancel ride network reqeust
     *  When:   Request fails
     *  Then:   Loading indicoator should be dismissed
     */
    func testDismissLoadingIndicatorOnFailure() {
        setCancelRequestMockToFail()
        triggerCancelRideAndPressYesInConfirmationAlert()

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
    }

    // MARK: Private helper methods

    private func setCancelRequestMockToFail() {
        testDelegateInstance.cancelReqeuestResultToReturn = Result.failure(error: TestUtil.getRandomError())
    }

    private func setCancelRequestMockToSucceed() {
        testDelegateInstance.cancelReqeuestResultToReturn = Result.success(result: KarhooVoid())
    }

    private func triggerCancelRideAndPressYesInConfirmationAlert() {
        testObject.triggerCancelRide()
        mockAlertHandler.triggerSecondAlertAction()
    }
}

class TestCancelRideDelegate: CancelRideDelegate {
    private(set) var showLoadingOverlayCalled = false
    private(set) var hideLoadingOverlayCalled = false
    var cancelReqeuestResultToReturn: Result<KarhooVoid>?

    func showLoadingOverlay() {
        showLoadingOverlayCalled = true
    }

    func hideLoadingOverlay() {
        hideLoadingOverlayCalled = true
    }

    func sendCancelRideNetworkRequest(callback: @escaping CallbackClosure<KarhooVoid>) {

        if let result = cancelReqeuestResultToReturn {
            callback(result)
        }
    }
}
