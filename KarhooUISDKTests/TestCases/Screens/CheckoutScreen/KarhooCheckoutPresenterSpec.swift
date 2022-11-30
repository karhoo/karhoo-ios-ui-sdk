//
//  KarhooCheckoutPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooCheckoutPresenterSpec: KarhooTestCase {

    private var testObject: KarhooCheckoutPresenter!
    private var mockView: MockCheckoutView!
    private var testQuote: Quote!
    private var testJourneyDetails: JourneyDetails!
    private var testCallbackResult: ScreenResult<TripInfo>?
    private var mockUserService: MockUserService!
    private var mockTripService: MockTripService!
    private var mockAppStateNotifier: MockAppStateNotifier!
    private var mockAnalytics: MockAnalytics!
    private var mockPopupDialogScreenBuilder: MockPopupDialogScreenBuilder!
    private let mockPaymentNonceProvider = MockPaymentNonceProvider()
    private let mockCardRegistrationFlow = MockCardRegistrationFlow()
    private var mockBookingMetadata: [String: Any]? = [:]

    override func setUp() {
        super.setUp()

        mockView = MockCheckoutView()
        testQuote = TestUtil.getRandomQuote(highPrice: 10)
        testJourneyDetails = TestUtil.getRandomJourneyDetails()
        mockUserService = MockUserService()
        mockTripService = MockTripService()
        mockAppStateNotifier = MockAppStateNotifier()
        mockAnalytics = MockAnalytics()
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
        testJourneyDetails = TestUtil.getAirportBookingDetails(originAsAirportAddress: false)
        loadTestObject()
        XCTAssertTrue(mockView.addFlightDetailsStateSet)
        testJourneyDetails = TestUtil.getAirportBookingDetails(originAsAirportAddress: true)
        loadTestObject()
        XCTAssertTrue(mockView.addFlightDetailsStateSet)
    }

    /**
     * When: User details are provided
     * When: The user presses "book ride"
     * And: They are authenticated
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     * And: No flight information should be passed (not airport booking)
     */
    func testRequestCarAuthenticated() {
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.completeBookingFlow()
        // TODO: Fix after ONE STEP PAYMENT // XCTAssert(mockView.setRequestingStateCalled)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNil(mockTripService.tripBookingSet?.flightNumber)
        XCTAssertNil(mockTripService.tripBookingSet?.meta)
    }
    
    /**
     * When: The user presses "Next"
     * And: They are using Adyen for payment
     * And: No booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should be called
     */
    func testAdyenRequestCarAuthenticated() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.adyen)
        mockView.passengerDetailsToReturn = TestUtil.getRandomValidPassengerDetails()
        mockView.paymentNonceToReturn = Nonce(nonce: "nonce")
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.completeBookingFlow()
        XCTAssert(mockView.setRequestingStateCalled)
        XCTAssertFalse(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
        XCTAssertTrue(mockTripService.tripBookingSet?.meta.count ?? 0 == 1)
        XCTAssertNotNil(mockTripService.tripBookingSet!.meta["trip_id"]) // ONE STEP PAYMENT
        XCTAssertNil(mockTripService.tripBookingSet?.meta["key"])
    }
    
    /**
     * When: The user presses "Next"
     * And: booking metadata injected into the Booking Request
     * Then: Then the screen should set to requesting state
     * And: Get nonce endpoint should not be called
     * And: Injected metadata should be set on TripBooking request object
     * And: Metadata should include trip_id = nonce
     */
    func testAdyenBookingMetadata() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.adyen)
        mockBookingMetadata = ["key":"value"]
        loadTestObject()
        mockView.passengerDetailsToReturn = TestUtil.getRandomValidPassengerDetails()
        let nonce = Nonce(nonce: "nonce")
        mockView.paymentNonceToReturn = nonce
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.completeBookingFlow()
        XCTAssert(mockView.setRequestingStateCalled)
        XCTAssertFalse(mockPaymentNonceProvider.getNonceCalled)
        XCTAssertNotNil(mockTripService.tripBookingSet?.meta)
        let value: String? = mockTripService.tripBookingSet?.meta["key"] as? String
        XCTAssertEqual(value, "value")
        let tripIdValue: String? = mockTripService.tripBookingSet?.meta["trip_id"] as? String
        XCTAssertEqual(tripIdValue, nonce.nonce)
    }

    /**
     * When: Adyen payment is cancelled
     * Then: no alert should show
     */
    func testCancellingPaymentProviderFlow() {
        KarhooTestConfiguration.mockPaymentManager = MockPaymentManager(.adyen)
        mockView.paymentNonceToReturn = Nonce(nonce: "nonce")
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(paymentProvider: "adyen")
        testObject.completeBookingFlow()
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
        testObject.completeBookingFlow()
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(UITexts.Errors.somethingWentWrong, mockView.showAlertTitle)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(UITexts.Errors.getUserFail, mockView.showAlertMessage)
        XCTAssertFalse(mockTripService.bookCall.executed)
        XCTAssertFalse(mockAnalytics.bookingRequestedWithDesinationCalled)
    }

    /**
     * When: A successful trip is requested
     * Then: The screen should fade out
     */
    func testRequestCarFadeOut() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        testObject.completeBookingFlow()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))
        mockTripService.bookCall.triggerSuccess(TestUtil.getRandomTrip())
        XCTAssertFalse(mockView.isCheckoutViewVisible)
    }

    /**
     * Given: The screen fades out
     * When:  The user requests a car
     * And:   The request is successful
     * Then:  A callBack should be completed
     * And: The analytics event should be triggered
     */
    func testRequestCarCallbackSuccess() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.completeBookingFlow()
        mockPaymentNonceProvider.triggerResult(OperationResult.completed(value: .nonce(nonce: Nonce(nonce: "some"))))
        mockTripService.bookCall.triggerSuccess(TestUtil.getRandomTrip())
        testObject.screenHasFadedOut()
        // TODO: Fix after ONE STEP PAYMENT // XCTAssert(testCallbackResult?.isComplete() == true)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssert(mockAnalytics.paymentSucceedCalled)
    }

    /**
     * Given: The screen fades out
     * When:  The user requests a car
     * And:   The request fails (not due to preauth)
     * Then:  The state should be set to default
     * And:   callback should be called with error
     * And: The analytics event should fire
     */
    func testRequestFailed() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.completeBookingFlow()
        mockPaymentNonceProvider.triggerResult(.completed(value: .nonce(nonce: Nonce(nonce: "some"))))

        let bookingError = TestUtil.getRandomError()
        mockTripService.bookCall.triggerFailure(bookingError)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssert(mockView.setDefaultStateCalled)
        XCTAssertFalse(mockCardRegistrationFlow.startCalled)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(testCallbackResult?.errorValue()?.code, bookingError.code)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockAnalytics.paymentFailedCalled)

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
     * Then: view should be set to more details state
     * And: user details should be null initially
     */
    func testAddPassengerDetailsFailed() {
        loadTestObject()
        XCTAssertFalse(mockView.addFlightDetailsStateSet)
        XCTAssertTrue(mockView.setMoreDetailsCalled)
        XCTAssertNil(mockView.details)
    }

    /**
     * When: Booking fails due to payment pre-auth error
     * Then: Card registration flow should start
     */
    func testPaymentErrorShowsStartsUpdateCardFlow() {
        startWithPaymentBookingError()

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.retryAddPaymentMethodCalled)
    }

    /**
     * When: User updates their card successfully
     * Then: Booking should be reattempted
     */
    func testUpdateCardSuccessContinuesBooking() {
        startWithPaymentBookingError()

        mockCardRegistrationFlow.triggerAddCardResult(.completed(value: .didAddPaymentMethod(nonce: Nonce())))

        // TODO: Fix after ONE STEP PAYMENT // XCTAssertNotNil(mockTripService.tripBookingSet)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertTrue(mockView.setRequestingStateCalled)
    }

    /**
     * Given:  The user requests a ride
     * When:   Getting a payment nonce fails
     * Then:  Then
     * And:   The callback should return error
     */
    func testRequestFailedNonceError() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.completeBookingFlow()
        mockPaymentNonceProvider.triggerResult(OperationResult.completed(value: .threeDSecureCheckFailed))

        // TODO: Fix after ONE STEP PAYMENT // XCTAssert(mockView.setDefaultStateCalled)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(mockView.showAlertTitle, UITexts.Generic.error)
        // TODO: Fix after ONE STEP PAYMENT // XCTAssertEqual(mockView.showAlertMessage, UITexts.Errors.somethingWentWrong)
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
        let timeZone = testJourneyDetails.originLocationDetails!.timezone()
        let formatter = KarhooDateFormatter(timeZone: timeZone)
        let displayTime = formatter.display(shortStyleTime: testJourneyDetails.scheduledDate)

        XCTAssert(mockView.timeStringSet == displayTime)
        XCTAssert(mockView.dateStringSet == formatter.display(mediumStyleDate: testJourneyDetails.scheduledDate))
    }

    /**
     * When: The booking details is not scheduled (is asap)
     * Then: the timePriceView should be set to asap mode
     *  And: Quote type should be set correctly
     */
    func testAsapSetup() {
        testJourneyDetails.scheduledDate = nil
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

        let fixedFareRequestScreen = KarhooCheckoutPresenter(quote: testQuote,
                                                             journeyDetails: testJourneyDetails,
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
     * When: TripInfo is being requested
     * Then: Screen should not be closed
     */
    func testAppEnteringBackgroundWhenRequestingTrip() {
        testObject.completeBookingFlow()
        mockAppStateNotifier.signalAppDidEnterBackground()
        XCTAssertFalse(mockView.fadeOutCalled)
    }

    /**
     * Given: App state notifier triggers "Did enter background"
     * When: Add flight details screen is presented
     * Then: Screen should not be closed
     */
    func testAppEnteringBackgroundWhenAddingFlightDetails() {
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
        XCTAssertFalse(mockView.isCheckoutViewVisible)
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

    func testQuoteExpiredCalling() {
        mockView.quoteDidExpire()

        XCTAssertTrue(mockView.quoteDidExpireCalled)
    }
    
    /**
     * When: SDK `isExplicitTermsAndConditionsConsentRequired` configuration is default
     * Then: Presenter should return false
     */
    func testIsExplicitTermsAndConditionsConsentRequiredDefaultValueIsFalse() {
        let isRequired = testObject.shouldRequireExplicitTermsAndConditionsAcceptance()
        
        XCTAssertFalse(isRequired)
    }

    /**
     * When: SDK `isExplicitTermsAndConditionsConsentRequired` configuration is set to true
     * Then: Presenter should return true
     */
    func testIsExplicitTermsAndConditionsConsentRequiredOverridenValueIsTrue() {
        KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
        
        testObject = KarhooCheckoutPresenter(
            quote: testQuote,
            journeyDetails: testJourneyDetails,
            bookingMetadata: mockBookingMetadata,
            tripService: mockTripService,
            userService: mockUserService,
            analytics: mockAnalytics,
            appStateNotifier: mockAppStateNotifier,
            baseFarePopupDialogBuilder: mockPopupDialogScreenBuilder,
            paymentNonceProvider: mockPaymentNonceProvider,
            callback: bookingRequestTrip
        )
        testObject.load(view: mockView)
        
        let isRequired = testObject.shouldRequireExplicitTermsAndConditionsAcceptance()
        
        XCTAssertTrue(isRequired)
    }
    

    /**
     * When: Booking screen is opened
     * Then: Analytics event should be triggered
     */
    func testWhenCheckoutOpened() {
        testObject.screenWillAppear()
        XCTAssertTrue(mockAnalytics.checkoutOpenedCalled)
    }

    private func startWithPaymentBookingError() {
        mockUserService.currentUserToReturn = TestUtil.getRandomUser()
        mockView.passengerDetailsToReturn = TestUtil.getRandomPassengerDetails()
        testObject.completeBookingFlow()
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
        KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = false
        testObject = KarhooCheckoutPresenter(
            quote: testQuote,
            journeyDetails: testJourneyDetails,
            bookingMetadata: mockBookingMetadata,
            tripService: mockTripService,
            userService: mockUserService,
            analytics: mockAnalytics,
            appStateNotifier: mockAppStateNotifier,
            baseFarePopupDialogBuilder: mockPopupDialogScreenBuilder,
            paymentNonceProvider: mockPaymentNonceProvider,
            callback: bookingRequestTrip
        )
        testObject.load(view: mockView)
    }
}
