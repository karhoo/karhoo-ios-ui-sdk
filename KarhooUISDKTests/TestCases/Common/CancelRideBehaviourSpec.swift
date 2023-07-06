//
//  CancelRideBehaviourSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class CancelRideBehaviourSpec: KarhooTestCase {

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
        
        KarhooTestConfiguration.setTokenAuthentication()
    }
    
    /**
     *  Given:      A call is made to retrieve the cancellation fee
     *  When:      It is a guest booking
     *  Then:       Then the follow code is used
     */
    func test() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        
        testObject.cancelPressed()
        
        mockTripService.cancellationFeeCall.triggerSuccess(CancellationFee())
        
        XCTAssertEqual(testTrip.followCode, mockTripService.identifierSet)
    }
    
    /**
     *  Given:      A call is made to retrieve the cancellation fee
     *  When:      The call fails
     *  Then:       A failure alert is shown
     */
    func testCancellationFeeRetrievalFailure() {
        testObject.cancelPressed()
        
        mockTripService.cancellationFeeCall.triggerFailure(TestUtil.getRandomError())
        
        XCTAssertEqual(testTrip.tripId, mockTripService.identifierSet)
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
        let feeString = CurrencyCodeConverter.toPriceString(price: fee.value, currencyCode: fee.currency)
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
     *  Then:    Error alert should be presented
     *  And:      Error alert positive action should be 'Call...'
     */
    func testCancellationWithFeeFailedAlert() {
        setUpCancellationFailure()

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 2)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Trip.tripCancelBookingFailedAlertTitle)
        XCTAssertEqual(mockAlertHandler.secondAlertButtonTitle,
                       UITexts.Trip.tripCancelBookingFailedAlertCallFleetButton)
    }

    /** 
     *  Given:  Cancel booking failed alert is presented
     *  When:   'Call' button is pressed
     *  Then:   Phone number to supplier should be called
     */
    func testCallOnCancellationAlert() {
        setUpCancellationFailure()
        
        mockAlertHandler.triggerSecondAlertAction()

        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, testTrip.fleetInfo.phoneNumber)
    }
    
    /**
     *  When:   Cancel booking request succeeds
     *  Then:    Success alert should be presented
     *  And:      Success alert positive action should be 'Okay'
     */
    func testCancellationSuccess() {
        setUpCancellationSuccess()

        XCTAssertTrue(testDelegateInstance.showLoadingOverlayCalled)
        XCTAssertTrue(testDelegateInstance.hideLoadingOverlayCalled)
        XCTAssertEqual(mockAlertHandler.alertActions?.count, 1)
        XCTAssertEqual(mockAlertHandler.alertTitle, UITexts.Bookings.cancellationSuccessAlertTitle)
        XCTAssertEqual(mockAlertHandler.firstAlertButtonTitle, UITexts.Generic.ok)
        
        mockAlertHandler.triggerFirstAlertAction()
        
        XCTAssertTrue(testDelegateInstance.handleSuccessfulCancellationCalled)
    }
    
    func setUpCancellationFeeSuccess() {
        let fee = CancellationFeePrice(currency: "GBP", value: 1000)
        let cancellationFee = CancellationFee(cancellationFee: true, fee: fee)
        testObject.cancelPressed()
        mockTripService.cancellationFeeCall.triggerSuccess(cancellationFee)
    }
    
    func setUpCancellationFailure() {
        setUpCancellationFeeSuccess()
        mockAlertHandler.triggerSecondAlertAction()
        mockTripService.cancelCall.triggerFailure(TestUtil.getRandomError())
    }
    
    func setUpCancellationSuccess() {
        setUpCancellationFeeSuccess()
        mockAlertHandler.triggerSecondAlertAction()
        mockTripService.cancelCall.triggerSuccess(KarhooVoid())
    }
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
