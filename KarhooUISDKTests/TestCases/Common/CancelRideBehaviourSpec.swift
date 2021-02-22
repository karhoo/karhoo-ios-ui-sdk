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
    private var mockTripService: MockTripService!
    private var testDelegateInstance: TestCancelRideDelegate!
    private var mockPhoneNumberCaller: MockPhoneNumberCaller!
    private var testObject: CancelRideBehaviour!
    private var testTrip: TripInfo = TestUtil.getRandomTrip(state: .driverEnRoute)
    override func setUp() {
        super.setUp()
        mockAlertHandler = MockAlertHandler()
        mockTripService = MockTripService()
        testDelegateInstance = TestCancelRideDelegate()
        mockPhoneNumberCaller = MockPhoneNumberCaller()

        testObject = CancelRideBehaviour(trip: testTrip,
                                         tripService: mockTripService,
                                         delegate: testDelegateInstance,
                                         alertHandler: mockAlertHandler,
                                         phoneNumberCaller: mockPhoneNumberCaller)
        
        KarhooTestConfiguration.authenticationMethod = .karhooUser
    }
    
    /**
     *  Given:      A call is made to retrieve the cancellation fee
     *  When:      The call fails
     *  Then:       A failure alert is shown
     */
    func testCancellationFeeRetrievalFailure() {
        testObject.cancelPressed()
        
        mockTripService.cancellationFeeCall.triggerFailure(TestUtil.getRandomError())
        
//        testObject.cancelPressed()
        
        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
        XCTAssertEqual(UITexts.Trip.tripCancelBookingFailedAlertTitle, mockAlertHandler?.alertTitle)
        XCTAssertEqual(UITexts.Trip.tripCancelBookingFailedAlertMessage, mockAlertHandler?.alertMessage)
    }

    /**
     *  Given:      A call is made to retrieve the cancellation fee
     *  When:      The call succeeds
     *  And:         There is no cancellation fee
     *  Then:       An alert is shown without the fee
     */
    func testCancellationWithoutFeeAlert() {
        testObject.cancelPressed()
        
        mockTripService.cancellationFeeCall.triggerSuccess(CancellationFee())

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Trip.tripCancelBookingConfirmationAlertTitle)
        XCTAssertEqual(mockAlertHandler.alertMessage, UITexts.Bookings.cancellationFeeContinue)
        XCTAssertEqual(mockAlertHandler.firstAlertButtonTitle, UITexts.Generic.no)
        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle, UITexts.Generic.yes)
    }

    /**
     *  Given:      A call is made to retrieve the cancellation fee
     *  When:      The call succeeds
     *  And:         There is no cancellation fee
     *  Then:       An alert is shown with the fee
     */
    func testCancellationWithFeeAlert() {
        let fee = CancellationFeePrice(currency: "GBP", value: 1000)
        let feeString = CurrencyCodeConverter.toPriceString(price: Double(fee.value), currencyCode: fee.currency)
        let expectedMessage = String(format: UITexts.Bookings.cancellationFeeCharge, feeString)
        
        testObject.cancelPressed()
        
        mockTripService.cancellationFeeCall.triggerSuccess(CancellationFee(cancellationFee: true, fee: fee))

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Trip.tripCancelBookingConfirmationAlertTitle)
        XCTAssertEqual(mockAlertHandler.alertMessage, expectedMessage)
        XCTAssertEqual(mockAlertHandler.firstAlertButtonTitle, UITexts.Generic.no)
        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle, UITexts.Generic.yes)
        
    }

    /** 
     *  When:   Cancel booking request fails
     *  Then:   Error alert should be presented
     *  And:    Error alert positive action should be 'call...'
     */
//    func testCancellationFailedAlert() {
//        setCancelRequestMockToFail()
//        triggerCancelRideAndPressYesInConfirmationAlert()
//
//        XCTAssert(mockAlertHandler.alertMessage?.isEmpty == false)
//        XCTAssert(mockAlertHandler.alertTitle?.isEmpty == false)
//        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
//        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Trip.tripCancelBookingFailedAlertTitle)
//        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle,
//                       UITexts.Trip.tripCancelBookingFailedAlertCallFleetButton)
//    }

    /** 
     *  Given:  Cancel booking failed alert is presented
     *  When:   'Call' button is pressed
     *  Then:   Phone number to supplier should be called
     */
//    func testCallOnCancellationAlert() {
//        setCancelRequestMockToFail()
//        triggerCancelRideAndPressYesInConfirmationAlert()
//        mockAlertHandler.triggerSecondAlertAction()
//
//        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, testTrip.fleetInfo.phoneNumber)
//    }

    /**
     *  Given:  Cancelling ride confirmed in an alert
     *  When:   Sending network request
     *  Then:   Loading indicator show be presented
     */
//    func testShowLoadingIndicator() {
//        triggerCancelRideAndPressYesInConfirmationAlert()
//
//        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
//        XCTAssertFalse(testDelegateInstance.hideLoadingOverlayCalled)
//    }

    /**
     *  Given:  Sending cancel ride network request
     *  When:   Request succeeds
     *  Then:   Loading indicator should be dismissed
     *   And:   Confirmation message alert should be presented
     */
//    func testDismissLoadingIndicatorOnSuccess() {
//        setCancelRequestMockToSucceed()
//        triggerCancelRideAndPressYesInConfirmationAlert()
//
//        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
//        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
//    }

    /**
     *  Given:  Sending cancel ride network reqeust
     *  When:   Request fails
     *  Then:   Loading indicoator should be dismissed
     */
//    func testDismissLoadingIndicatorOnFailure() {
//        setCancelRequestMockToFail()
//        triggerCancelRideAndPressYesInConfirmationAlert()
//
//        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
//        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
//    }

    // MARK: Private helper methods

    private func setCancelRequestMockToFail() {
        testDelegateInstance.cancelReqeuestResultToReturn = Result.failure(error: TestUtil.getRandomError())
    }

    private func setCancelRequestMockToSucceed() {
        testDelegateInstance.cancelReqeuestResultToReturn = Result.success(result: KarhooVoid())
    }

//    private func triggerCancelRideAndPressYesInConfirmationAlert() {
//        testObject.triggerCancelRide()
//        mockAlertHandler.triggerSecondAlertAction()
//    }
    
    /**
     *  Given:  Cancel trip fails
     *  Then:   Alert handler should not show
     */
//    func testCancelRequestFailureNotDismissingTrip() {
//        testObject.sendCancelRideNetworkRequest(callback: { _ in })
//
//        mockTripService.cancelCall.triggerFailure(TestUtil.getRandomError())
//
//        XCTAssertNil(mockTripView.actionAlertTitle)
//        XCTAssertNil(mockTripView.actionAlertMessage)
//        XCTAssertNil(screenResult)
//    }
}

class TestCancelRideDelegate: CancelRideDelegate {
    private(set) var showLoadingOverlayCalled = false
    private(set) var hideLoadingOverlayCalled = false
    private(set) var handleSuccessfulCancellationCalled = false
    var cancelReqeuestResultToReturn: Result<KarhooVoid>?

    func showLoadingOverlay() {
        showLoadingOverlayCalled = true
    }

    func hideLoadingOverlay() {
        hideLoadingOverlayCalled = true
    }
    
    func handleSuccessfulCancellation() {
        handleSuccessfulCancellationCalled = true
    }
}
