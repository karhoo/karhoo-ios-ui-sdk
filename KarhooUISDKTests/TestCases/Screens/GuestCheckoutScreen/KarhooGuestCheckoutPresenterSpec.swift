//
//  KarhooGuestBookingRequestPresenterSpec.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooGuestCheckoutPresenterSpec: KarhooTestCase {

    private var testObject: KarhooCheckoutPresenter!
    private var mockView: MockCheckoutView = MockCheckoutView()
    private var testQuote: Quote = TestUtil.getRandomQuote(highPrice: 10)
    private var testCallbackResult: ScreenResult<TripInfo>?
    private var mockThreeDSecureProvider = MockThreeDSecureProvider()
    private var mockTripService = MockTripService()
    private var mockJourneyDetails = TestUtil.getRandomJourneyDetails()
    private var mockUserService = MockUserService()
    private var mockPaymentNonceProvider = MockPaymentNonceProvider()
    private var mockBookingMetadata: [String: Any]? = [:]

    override func setUp() {
        super.setUp()
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        loadTestObject()
    }
    
     // MARK: Tests specific for Braintree

    /** Given: A user has added details and a nonce
     *  When: Booking button is pressed
     *  Then: ThreeDSecure request should be correctly formed and sent
     *  And: View should be in a requesting state
     */
    
    func testThreeDSecureBraintreeSent() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        testObject.completeBookingFlow()

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setRequestingStateCalled)
        XCTAssertTrue(mockThreeDSecureProvider.setBaseViewControllerCalled)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(mockThreeDSecureProvider.paymentAmountSet, NSDecimalNumber(value: testQuote.price.highPrice))
    }

    /** When: 3D secure provider succeeds
     *  Then: Then trip service should be called with secure nonce
     */
    
    func testThreeDSecureProviderBraintreeSucceeds() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        testObject.completeBookingFlow()

        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("456", mockTripService.tripBookingSet?.paymentNonce)
    }

    /** When: 3D secure provider fails
     *  Then: Then trip service should not be called
     */
    
    func testThreeDSecureProviderBraintreeFails() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        testObject.completeBookingFlow()

        mockThreeDSecureProvider.triggerResult(.completed(value: .threeDSecureAuthenticationFailed))

        XCTAssertNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Trip service booking succeeds
     *  Then: View should be updated and callback is called with trip
     */
    
    func testTripServiceBraintreeSucceeds() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        testObject.completeBookingFlow()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)
        
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("456", mockTripService.tripBookingSet?.paymentNonce)

        // TODO: Provide new test implementation for this case
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /**
     * When: Trip service booking succeeds
     *  Then: View should be updated and callback is called with trip
     */
    
    func testCorrectPaymentNonceIsUsed() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        KarhooTestConfiguration.authenticationMethod = .guest(settings: .init(identifier: "", referer: "", organisationId: ""))

        let expectedNonce = Nonce(nonce: "mock_nonce")
        
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.completeBookingFlow()
        mockUserService.currentUserToReturn = UserInfo(nonce: expectedNonce)
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "mock_nonce")))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(expectedNonce.nonce, mockTripService.tripBookingSet?.paymentNonce)

        // TODO: Provide new test implementation for this case
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
    }
    
    /** When: Trip service booking succeeds for token exchange
     *  Then: View should be updated and callback is called with trip
     */
    func testCorrectTokenExchangePaymentNonceIsUsedForBraintreePayment() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.braintree)
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        let expectedNonce = Nonce(nonce: "mock_nonce")
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: expectedNonce,
                                                                     paymentProvider: "braintree")
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        
        testObject.completeBookingFlow()
        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "mock_nonce")))
            
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: expectedNonce)))

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(expectedNonce.nonce, mockTripService.tripBookingSet?.paymentNonce)

        // TODO: Provide new test implementation for this case
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
    }
    
    // MARK: Tests only for Adyen
    
    /** When: Trip service booking succeeds for token exchange
     *  Then: View should be updated and callback is called with trip
     */
    
    func testCorrectTokenExchangePaymentNonceIsUsedForAdyenPayment() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.adyen)
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
                                                                     paymentProvider: "adyen")
        testObject.completeBookingFlow()

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(mockView.paymentNonceToReturn?.nonce, mockTripService.tripBookingSet?.paymentNonce)

        // TODO: Provide new test implementation for this case
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
    }
    
    /**
     * When: The user presses "book ride"
     * And: booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: View should be updated and callback is called with trip
     * And: Injected metadata should be set on TripBooking request object
     */
    func testBookingMetadata() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.adyen)
        mockBookingMetadata = ["key":"value"]
        loadTestObject()
        KarhooTestConfiguration.authenticationMethod = .tokenExchange(settings: KarhooTestConfiguration.tokenExchangeSettings)
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
                                                                     paymentProvider: "adyen")
        
        testObject.completeBookingFlow()

        let tripBooked = TestUtil.getRandomTrip()
        mockTripService.bookCall.triggerSuccess(tripBooked)

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(mockView.paymentNonceToReturn?.nonce, mockTripService.tripBookingSet?.paymentNonce)

        // TODO: Provide new test implementation for this case
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setDefaultStateCalled)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
//        let value: String = mockTripService.tripBookingSet?.meta["key"] as! String
//        XCTAssertEqual(value, "value")
    }
    
    // MARK: Common test for all PSP

    /** When: Trip service booking fails
     *  Then: View should be updated and error propagated
     */
     /// TODO: Unit test disable due to: `Swift/Dictionary.swift:826: Fatal error: Dictionary literal contains duplicate keys` IDE issue
    func testTripServiceFails() {
//        testObject.bookTripPressed()
//        mockThreeDSecureProvider.triggerResult(.completed(value: .success(nonce: "456")))
//
//        let bookingError = TestUtil.getRandomError()
//        mockTripService.bookCall.triggerFailure(bookingError)
//        let expectedMessage = "\(bookingError.localizedMessage) [\(bookingError.code)]"
//
//        XCTAssertEqual(expectedMessage, mockView.showAlertMessage)
//        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /** When: Adyen is the payment provider
     *  Then: Correct flow executes
     */
    // TODO: update PSP flow tests to new, agnostic, approach
    func testAdyenPaymentFlow() {
//        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil,
//                                                                     paymentProvider: "adyen")
//        testObject.bookTripPressed()
//
//        XCTAssertFalse(mockThreeDSecureProvider.threeDSecureCalled)
//
//        let tripBooked = TestUtil.getRandomTrip()
//        mockTripService.bookCall.triggerSuccess(tripBooked)
//
//        XCTAssertNotNil(mockTripService.tripBookingSet)
//        XCTAssertEqual("comments", mockTripService.tripBookingSet?.comments)
//        XCTAssertEqual("flightNumber", mockTripService.tripBookingSet?.flightNumber)
//        XCTAssertEqual("123", mockTripService.tripBookingSet?.paymentNonce)
//
//        XCTAssertEqual(tripBooked.tripId, testCallbackResult?.completedValue()?.tripId)
//        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    private func guestBookingRequestTrip(result: ScreenResult<TripInfo>) {
        testCallbackResult = result
    }

    private func loadTestObject() {
        mockView.paymentNonceToReturn = Nonce(nonce: "123")
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        mockView.commentsToReturn = "comments"
        mockView.flightNumberToReturn = "flightNumber"
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(nonce: nil)
        testObject = KarhooCheckoutPresenter(
            quote: testQuote,
            journeyDetails: mockJourneyDetails,
            bookingMetadata: mockBookingMetadata,
            threeDSecureProvider: mockThreeDSecureProvider,
            tripService: mockTripService,
            userService: mockUserService,
            paymentNonceProvider: mockPaymentNonceProvider,
            sdkConfiguration: KarhooUISDKConfigurationProvider.configuration,
            callback: guestBookingRequestTrip
        )
        testObject.load(view: mockView)
    }
}
