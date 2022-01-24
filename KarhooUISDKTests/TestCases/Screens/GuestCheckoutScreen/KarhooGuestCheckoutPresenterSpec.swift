//
//  KarhooGuestBookingRequestPresenterSpec.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooGuestCheckoutPresenterSpec: XCTestCase {

    private var testObject: KarhooCheckoutPresenter!
    private var mockView: MockCheckoutView = MockCheckoutView()
    private var testQuote: Quote = TestUtil.getRandomQuote(highPrice: 10)
    private var testCallbackResult: ScreenResult<TripInfo>?
    private var mockThreeDSecureProvider = MockThreeDSecureProvider()
    private var mockTripService = MockTripService()
    private var mockBookingDetails = TestUtil.getRandomBookingDetails()
    private var mockUserService = MockUserService()
    private var mockPaymentNonceProvicer = MockPaymentNonceProvider()
    private var mockBookingMetadata: [String: Any]? = [:]

    override func setUp() {
        super.setUp()
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        loadTestObject()
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
        KarhooTestConfiguration.authenticationMethod = .guest(settings: .init(identifier: "", referer: "", organisationId: ""))

        let expectedNonce = Nonce(nonce: "mock_nonce")
        
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.bookTripPressed()
        mockUserService.currentUserToReturn = UserInfo(nonce: expectedNonce)
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
    func testCorrectTokenExchangePaymentNonceIsUsedForBraintreePayment() {
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        let expectedNonce = Nonce(nonce: "mock_nonce")
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: expectedNonce,
                                                                     paymentProvider: "braintree")
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        
        testObject.bookTripPressed()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "mock_nonce")))
            
        mockPaymentNonceProvicer.triggerResult(.completed(value: .nonce(nonce: expectedNonce)))

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
    func testCorrectTokenExchangePaymentNonceIsUsedForAdyenPayment() {
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
                                                                     paymentProvider: "adyen")
        testObject.bookTripPressed()

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual(mockView.paymentNonceToReturn, mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }
    
    
    /**
     * When: The user presses "book ride"
     * And: booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: View should be updated and callback is called with trip
     * And: Injected metadata should be set on TripBooking request object
     */
    func testbookingMetadata() {
        mockBookingMetadata = ["key":"value"]
        loadTestObject()
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
                                                                     paymentProvider: "adyen")
        
        testObject.bookTripPressed()

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        XCTAssertEqual(mockView.paymentNonceToReturn, mockTripService.tripBookingSet?.paymentNonce)

        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        XCTAssertTrue(mockView.setDefaultStateCalled)
        XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
        let value: String = mockTripService.tripBookingSet?.meta["key"] as! String
        XCTAssertEqual(value, "value")
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
        testObject = KarhooCheckoutPresenter(
            quote: testQuote,
            bookingDetails: mockBookingDetails,
            bookingMetadata: mockBookingMetadata,
            threeDSecureProvider: mockThreeDSecureProvider,
            tripService: mockTripService,
            userService: mockUserService,
            paymentNonceProvider: mockPaymentNonceProvicer,
            callback: guestBookingRequestTrip
        )
        testObject.load(view: mockView)
    }
}
