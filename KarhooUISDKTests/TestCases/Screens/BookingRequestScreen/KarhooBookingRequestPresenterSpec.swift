//
//  BookingRequestPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooBookingRequestPresenterSpec: XCTestCase {

    private var testObject: FormBookingRequestPresenter!
    private var mockView: MockBookingRequestView!
    private var testQuote: Quote!
    private var testBookingDetails: BookingDetails!
    private var testCallbackResult: ScreenResult<TripInfo>?
    private var mockUserService: MockUserService!
    private var mockTripService: MockTripService!
    private var mockFlightDetails: FlightDetails!
    private var mockAppStateNotifier: MockAppStateNotifier!
    private var mockAnalytics: MockAnalytics!
    private var mockFlightScreenBuilder: MockFlightDetailsScreenBuilder!
    private var mockPopupDialogScreenBuilder: MockPopupDialogScreenBuilder!
    private let mockPaymentNonceProvider = MockPaymentNonceProvider()
    private let mockCardRegistrationFlow = MockCardRegistrationFlow()
    private var mockBookingMetadata: [String: Any]? = [:]

    override func setUp() {
        super.setUp()

        mockView = MockBookingRequestView()
        testQuote = TestUtil.getRandomQuote(highPrice: 10)
        mockFlightDetails = FlightDetails(flightNumber: "flight_number", comments: "comments")
        testBookingDetails = TestUtil.getRandomBookingDetails()
        mockUserService = MockUserService()
        mockTripService = MockTripService()
        mockAppStateNotifier = MockAppStateNotifier()
        mockAnalytics = MockAnalytics()
        mockFlightScreenBuilder = MockFlightDetailsScreenBuilder()
        mockPopupDialogScreenBuilder = MockPopupDialogScreenBuilder()

        loadTestObject()
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
    }

    /**
      * When: Pickup or destination is an airport type address
      * Then: Screen should set to "add flight details" state
      * NOTE: As booking button state is called on screen loading and dependent on booking details, we have
              to reload the entire test object with an airport set as just the pickup, then just the destination
      */
    func testAirportBookingSetup() {
        testBookingDetails = TestUtil.getAirportBookingDetails(originAsAirportAddress: false)
        loadTestObject()
        XCTAssertTrue(mockView.addFlightDetailsStateSet)

        testBookingDetails = TestUtil.getAirportBookingDetails(originAsAirportAddress: true)
        loadTestObject()
        XCTAssertTrue(mockView.addFlightDetailsStateSet)
    }

    /**
      * When: Pickup or destination is NOT an airport type address
      * Then: Screen should be set to default state "Book Ride"
      */
    func testRegularBookingSetup() {
        XCTAssertFalse(mockView.addFlightDetailsStateSet)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /**
     * When: The user presses "book ride"
     * And: They are authenticated
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: No flight information should be passed (not airport booking)
     * And: Analytics event should fire
     */
    func testRequestCarAuthenticated() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        XCTAssert(mockView.setRequestingStateCalled)
        XCTAssertTrue(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNil(mockTripService.tripBookingSet?.flightNumber)
        XCTAssertNil(mockTripService.tripBookingSet?.meta)
        XCTAssertTrue(mockAnalytics.bookingRequestedCalled)
    }
    
    /**
     * When: The user presses "book ride"
     * And: They are using Adyen for payment
     * And: No booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: Analytics event should fire
     */
    func testAdyenRequestCarAuthenticated() {
        mockView.paymentNonceToReturn = "nonce"
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.bookTripPressed()
        XCTAssert(mockView.setRequestingStateCalled)
        XCTAssertFalse(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
        XCTAssertTrue(mockAnalytics.bookingRequestedCalled)
        XCTAssertNil(mockTripService.tripBookingSet?.meta["key"])
    }
    
    /**
     * When: The user presses "book ride"
     * And: booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: Analytics event should fire
     * And: Injected metadata should be set on TripBooking request object
     */
    func testbookingMetadata() {
        mockBookingMetadata = ["key":"value"]
        loadTestObject()
        mockView.paymentNonceToReturn = "nonce"
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.bookTripPressed()
        XCTAssert(mockView.setRequestingStateCalled)
        XCTAssertFalse(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
        XCTAssertTrue(mockAnalytics.bookingRequestedCalled)
        let value: String? = mockTripService.tripBookingSet?.meta["key"] as? String
        XCTAssertEqual(value, "value")
    }

    /**
     * When: Adyen payment is cancelled
     * Then: no alert should show
     */
    func testCancellingPaymentProviderFlow() {
        mockView.paymentNonceToReturn = "nonce"
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(.cancelledByUser)
        XCTAssertFalse(mockView.showAlertCalled)
        XCTAssertFalse(mockView.showErrorCalled)
    }

    /**
     * When: The user presses "book ride"
     * And: They are not authenticated
     * Then: An alert should show with failed to get user message
     * And: trip service should not be called
     * And: No Analytics event should fire
     */
    func testRequestCarNotAuthenticated() {
        mockUserService.currentUserToReturn = nil
        testObject.bookTripPressed()
        XCTAssertEqual(UITexts.Errors.somethingWentWrong, mockView.showAlertTitle)
        XCTAssertEqual(UITexts.Errors.getUserFail, mockView.showAlertMessage)
        XCTAssertFalse(mockTripService.bookCall.executed)
        XCTAssertFalse(mockAnalytics.bookingRequestedCalled)
    }

    /**
     * When: A successful trip is requested
     * Then: The screen should fade out
     */
    func testRequestCarFadeOut() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))
        mockTripService.bookCall.triggerSuccess(TestUtil.getRandomTrip())
        XCTAssertFalse(mockView.isBookingRequestViewVisible)
    }

    /**
     * Given: The screen fades out
     * When:  The user requests a car
     * And:   The request is successful
     * Then:  A callBack should be completed
     */
    func testRequestCarCallbackSuccess() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))
        mockTripService.bookCall.triggerSuccess(TestUtil.getRandomTrip())
        testObject.screenHasFadedOut()
        XCTAssert(testCallbackResult?.isComplete() == true)
    }

    /**
     * Given: The screen fades out
     * When:  The user requests a car
     * And:   The request fails (not due to preauth)
     * Then:  The state should be set to default
     * And:   callback should be called with error
     */
    func testRequestFailed() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))

        let bookingError = TestUtil.getRandomError()
        mockTripService.bookCall.triggerFailure(bookingError)
        XCTAssert(mockView.setDefaultStateCalled)
        XCTAssertFalse(mockCardRegistrationFlow.startCalled)

        XCTAssertEqual(testCallbackResult?.errorValue()?.code, bookingError.code)

    }
    
    /**
     * When: Guest user logged in
     * Then: view should be set to more details
     * And: user details should be null initially
     */
    func testAddPassengerDetails() {
        let mockGuestSettings = GuestSettings(identifier: "test", referer: "test", organisationId: "test")
        loadTestObject(configuration: .guest(settings: mockGuestSettings))
        XCTAssertTrue(mockView.setMoreDetailsCalled)
        testObject.addMoreDetails()
        XCTAssertNil(mockView.details)
    }
    
    /**
     * When: Guest karhoo user logged in
     * Then: view should be set to default state
     * And: user details should NOT be null initially
     */
    func testAddPassengerDetailsFailed() {
        loadTestObject()
        XCTAssertFalse(mockView.setMoreDetailsCalled)
        XCTAssertTrue(mockView.setDefaultStateCalled)
    }

    /**
     * When: Booking fails due to payment pre-auth error
     * Then: Card registration flow should start
     */
    func testPaymentErrorShowsStartsUpdateCardFlow() {
        startWithPaymentBookingError()

        XCTAssertTrue(mockView.retryAddPaymentMethodCalled)
    }

    /**
     * When: User updates their card successfully
     * Then: Booking should be reattempted
     */
    func testUpdateCardSuccessContinuesBooking() {
        startWithPaymentBookingError()

        mockCardRegistrationFlow.triggerAddCardResult(.completed(value: .didAddPaymentMethod(nonce: Nonce())))

        XCTAssertNotNil(mockTripService.tripBookingSet)
        XCTAssertTrue(mockView.setRequestingStateCalled)
    }

    /**
     * Given:  The user requests a ride
     * Wheb:   Getting a payment nonce fails
     * Then:  Then
     * And:   The callback should return error
     */
    func testRequestFailedNonceError() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(OperationResult.completed(value: .threeDSecureCheckFailed))

        XCTAssert(mockView.setDefaultStateCalled)
        XCTAssertEqual(mockView.showAlertTitle, UITexts.Generic.error)
        XCTAssertEqual(mockView.showAlertMessage, UITexts.Errors.somethingWentWrong)
    }

    /** Given: The view loads
     *  When: Quote has come from the fleet
     *  Then: The price as a srting should be set
     */
    func testPriceSet() {
        testQuote = TestUtil.getRandomQuote(source: .fleet)
        loadTestObject()

        XCTAssertEqual(CurrencyCodeConverter.toPriceString(quote: testQuote), mockView.priceString)
    }

    /** Given: The view loads
     *  When: Quote has come from the market
     *  Then: The price as a srting should be set as a range
     */
    func testPriceSetAsRange() {
        testQuote = TestUtil.getRandomQuote(source: .market)
        loadTestObject()

        XCTAssertEqual(CurrencyCodeConverter.quoteRangePrice(quote: testQuote), mockView.priceString)
    }

    /**
     * When: The booking details is scheduled (is a prebook)
     * Then: The timePriceView should be set to prebook mode
     *  And: Quote type should be set correctly
     */
    func testPrebookSetup() {
        let timeZone = testBookingDetails.originLocationDetails!.timezone()
        let formatter = KarhooDateFormatter(timeZone: timeZone)
        let displayTime = formatter.display(shortStyleTime: testBookingDetails.scheduledDate)

        XCTAssert(mockView.timeStringSet == displayTime)
        XCTAssert(mockView.dateStringSet == formatter.display(mediumStyleDate: testBookingDetails.scheduledDate))
    }

    /**
     * When: The booking details is not scheduled (is asap)
     * Then: the timePriceView should be set to asap mode
     *  And: Quote type should be set correctly
     */
    func testAsapSetup() {
        testBookingDetails.scheduledDate = nil
        loadTestObject()
        let qta = QtaStringFormatter().qtaString(min: testQuote.vehicle.qta.lowMinutes,
                                                 max: testQuote.vehicle.qta.highMinutes)
        XCTAssertEqual(qta, mockView.asapQtaString)
        XCTAssertEqual(UITexts.Generic.fixed.lowercased(), mockView.quoteType?.lowercased())
    }

    /**
      * Given: A fixed fare type
      * Then: The base fare explanation should be hidden
      */
    func testFixedQuoteHidesBaseFare() {
        testQuote = TestUtil.getRandomQuote(highPrice: 10, quoteType: .fixed)

        let fixedFareRequestScreen = FormBookingRequestPresenter(quote: testQuote,
                                                                   bookingDetails: testBookingDetails,
                                                                   bookingMetadata: mockBookingMetadata,
                                                                   tripService: mockTripService,
                                                                   userService: mockUserService,
                                                                   callback: bookingRequestTrip)

        fixedFareRequestScreen.load(view: mockView)

        XCTAssertTrue(mockView.baseFareHiddenSet!)
    }

    /**
     * Given: An estimated fare type
     * Then: The base fare explanation should NOT be hidden
     */
    func testNotFixedQuote() {
        testQuote = TestUtil.getRandomQuote(highPrice: 10, quoteType: .estimated)
        loadTestObject()
        XCTAssertFalse(mockView.baseFareHiddenSet!)
    }

    /**
      * Given: App state notifier triggers "Did enter background"
      * When: TripInfo is being reqested
      * Then: Screen should not be closed
      */
    func testAppEnteringBackgroundWhenRequestingTrip() {
        testObject.bookTripPressed()
        mockAppStateNotifier.signalAppDidEnterBackground()
        XCTAssertFalse(mockView.fadeOutCalled)
    }

    /**
     * Given: App state notifier triggers "Did enter background"
     * When: Add flight details screen is presented
     * Then: Screen should not be closed
     */
    func testAppEnteringBackgroundWhenAddingFlightDetails() {
        testObject.didPressAddFlightDetails()
        mockAppStateNotifier.signalAppDidEnterBackground()
        XCTAssertFalse(mockView.fadeOutCalled)
    }

    /**
     * Given: App state notifier triggers "Did enter background"
     * When:  Trip is not being requested
     * Then:  Screen should be closed
     * And:   Callback should not have a completed value
     */
    func testAppEnteringBackgroundWhenNotRequestingTrip() {
        mockAppStateNotifier.signalAppDidEnterBackground()
        XCTAssertFalse(mockView.isBookingRequestViewVisible)
        XCTAssertNil(testCallbackResult?.completedValue())
    }

    /**
     * When: The user presses fare explanation
     * Then: The popup dialog should show
     */
    func testBaseFareDialogShowing() {
        testObject.didPressFareExplanation()

        XCTAssertTrue(mockPopupDialogScreenBuilder.buildPopupScreenCalled)
        XCTAssertTrue(mockView.showAsOverlayCalled)
    }

    /**
     * When: The user closes dialog
     * Then: Then popup view should be dismissed
     */
    func testBaseFareDialogDismisses() {
        testObject.didPressFareExplanation()
        mockPopupDialogScreenBuilder.triggerScreenResult(.completed(result: ()))

        XCTAssertTrue(mockView.dismissCalled)
    }

    /**
     * When: User added flight details
     * Then: view should be set to requesting
     * And: View should dismiss
     * And: trip booking should be made (with added flight number)
     */
    func testFlightDetailsAdded() {
        testObject.didPressAddFlightDetails()

        let flightDetailsAdded = FlightDetails(flightNumber: "some", comments: "someComment")

        mockFlightScreenBuilder.triggerFlightDetailsScreenResult(.completed(result: flightDetailsAdded))
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))
        XCTAssertTrue(mockView.setRequestingStateCalled)
        XCTAssertTrue(mockFlightScreenBuilder.returnViewController!.dismissCalled)
        XCTAssertTrue(mockTripService.bookCall.executed)
        XCTAssertEqual(mockTripService.tripBookingSet?.flightNumber, flightDetailsAdded.flightNumber)
    }

    /**
     * When: User cancels adding flight details
     * Then: view should not be set to requesting
     * And: View should dismiss
     * And: trip booking should NOT be made
     */
    func testNoFlightDetailsAdded() {
        testObject.didPressAddFlightDetails()

        mockFlightScreenBuilder.triggerFlightDetailsScreenResult(.cancelled(byUser: true))

        XCTAssertFalse(mockView.setRequestingStateCalled)
        XCTAssertFalse(mockTripService.bookCall.executed)
        XCTAssertTrue(mockFlightScreenBuilder.returnViewController!.dismissCalled)
    }
    
    private func startWithPaymentBookingError() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.bookTripPressed()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))

        mockTripService.bookCall.triggerFailure(MockError(code: "K4006",
                                                          message: "",
                                                          userMessage: ""))

    }

    private func bookingRequestTrip(result: ScreenResult<TripInfo>) {
        testCallbackResult = result
    }

    private func loadTestObject(configuration: AuthenticationMethod = .karhooUser) {
        KarhooTestConfiguration.authenticationMethod = configuration
        testObject = FormBookingRequestPresenter(quote: testQuote,
                                                   bookingDetails: testBookingDetails,
                                                   bookingMetadata: mockBookingMetadata,
                                                   tripService: mockTripService,
                                                   userService: mockUserService,
                                                   analytics: mockAnalytics,
                                                   appStateNotifier: mockAppStateNotifier,
                                                   flightDetailsScreenBuilder: mockFlightScreenBuilder,
                                                   baseFarePopupDialogBuilder: mockPopupDialogScreenBuilder,
                                                   paymentNonceProvider: mockPaymentNonceProvider,
                                                   callback: bookingRequestTrip)
        testObject.load(view: mockView)
    }
}
