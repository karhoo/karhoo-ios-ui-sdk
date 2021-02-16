//
//  KarhooGuestBookingRequestPresenterSpec.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooGuestBookingRequestPresenterSpec: XCTestCase {

    private var testObject: FormBookingRequestPresenter!
    private var mockView: MockBookingRequestView = MockBookingRequestView()
    private var testQuote: Quote = TestUtil.getRandomQuote(highPrice: 10)
    private var testCallbackResult: ScreenResult<TripInfo>?
    private var mockThreeDSecureProvider = MockThreeDSecureProvider()
    private var mockTripService = MockTripService()
    private var mockBookingDetails = TestUtil.getRandomBookingDetails()
    private var mockUserService = MockUserService()

    override func setUp() {
        super.setUp()
        loadTestObject()
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
    }

    /** Given: A user has added details and a nonce
     *  When: Booking button is pressed
     *  Then: ThreeDSecure request should be correctly formed and sent
     *  And: View should be in a requesting state
     */
    func testThreeDSecureSent() {
        testObject.bookTripPressed()

        XCTAssertTrue(mockView.setRequestingStateCalled)
        XCTAssertTrue(mockThreeDSecureProvider.setBaseViewControllerCalled)
        XCTAssertEqual(mockThreeDSecureProvider.paymentAmountSet, NSDecimalNumber(value: testQuote.price.highPrice))
    }

    /** When: 3D secure provider succeeds
     *  Then: Then trip service should be called with secure nonce
     */
    func testThreeDSecureProviderSucceeds() {
        testObject.bookTripPressed()

        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))

        XCTAssertEqual("456", mockTripService.tripBookingSet?.paymentNonce)
    }

    /** When: 3D secure provider fails
     *  Then: Then trip service should not be called
     */
    func testThreeDSecureProviderFails() {
        testObject.bookTripPressed()

        mockThreeDSecureProvider.triggerResult(.completed(value: .threeDSecureAuthenticationFailed))

        XCTAssertNil(mockTripService.tripBookingSet)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Trip service booking succceeds
     *  Then: View should be updated and callback is called with trip
     */
    func testTripServiceSucceeds() {
        testObject.bookTripPressed()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)
        
        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual("456", mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Trip service booking succceeds
     *  Then: View should be updated and callback is called with trip
     */
    func testCorrectPaymentNonceIsUsed() {
        KarhooTestConfiguration.authenticationMethod = .karhooUser

        let expectedNonce = Nonce(nonce: "mock_nonce")
        mockUserService.currentUserToReturn = UserInfo(nonce: expectedNonce)

        testObject.bookTripPressed()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "mock_nonce")))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual(expectedNonce.nonce, mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Trip service booking succceeds for token exchange
     *  Then: View should be updated and callback is called with trip
     */
    func testCorrectTokenExchangePaymentNonceIsUsed() {
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)

        let expectedNonce = Nonce(nonce: "mock_nonce")
        mockUserService.currentUserToReturn = UserInfo(nonce: expectedNonce)

        testObject.bookTripPressed()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "mock_nonce")))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual(expectedNonce.nonce, mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Trip service booking fails
     *  Then: View should be updated and error propogated
     */
    func testTripServiceFails() {
        testObject.bookTripPressed()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))

        let bookingError = TestUtil.getRandomError()
        mockTripService.bookCall.triggerFailure(bookingError)
        let expectedMessage = "\(bookingError.localizedMessage) [\(bookingError.code)]"

        XCTAssertEqual(expectedMessage, mockView.showAlertMessage)
        XCTAssertTrue(mockView.setDefaultStateCalled)

    }

    /** Whem: Adyen is the payment provider
     *  Then: Correct flow executes
     */
    func testAdyenPaymentFlow() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
                                                                     paymentProvider: "adyen")
        testObject.bookTripPressed()

        XCTAssertFalse(mockThreeDSecureProvider.threeDSecureCalled)

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)
        
        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual("123", mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    private func guestBookingRequestTrip(result: ScreenResult<TripInfo>) {
        testCallbackResult = result
    }

    private func loadTestObject() {
        mockView.paymentNonceToReturn = "123"
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        mockView.commentsToReturn = "comments"
        mockView.flightNumberToReturn = "flightNumber"
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil)
        testObject = FormBookingRequestPresenter(quote: testQuote,
                                                  bookingDetails: mockBookingDetails,
                                                  threeDSecureProvider: mockThreeDSecureProvider,
                                                  tripService: mockTripService,
                                                  userService: mockUserService,
                                                  callback: guestBookingRequestTrip)
        testObject.load(view: mockView)
    }
}
