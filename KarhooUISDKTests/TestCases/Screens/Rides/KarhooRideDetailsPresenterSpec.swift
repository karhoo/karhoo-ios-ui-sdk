//
//  KarhooRideDetailsPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

class KarhooRideDetailsPresenterSpec: KarhooTestCase {

    private var mockRideDetailsView: MockRideDetailsView = MockRideDetailsView()
    private var testObject: KarhooRideDetailsPresenter!
    private var testCallback: ScreenResult<Void>?
    private var testInitialTrip: TripInfo = TestUtil.getRandomTrip(dateSet: true, state: .confirmed)
    private var mockTripService: MockTripService = MockTripService()
    private var mockFeedbackMailComposer: MockFeedbackMailComposer = MockFeedbackMailComposer()
    private var mockCancelRideBehaviour: MockCancelRideBehaviour = MockCancelRideBehaviour()
    private var callbackResult: ScreenResult<RideDetailsAction>?
    private var mockPopupDialogScreenBuilder: MockPopupDialogScreenBuilder = MockPopupDialogScreenBuilder()
    private var mockAnalyticsService: MockAnalyticsService = MockAnalyticsService()
    private var mockFeedbackScreenBuilder: MockTripFeedbackScreenBuilder = MockTripFeedbackScreenBuilder()
    private var mockTripRatingCache = MockTripRatingCache()
    private var mockAlertHandler: MockAlertHandler! = MockAlertHandler()
    
    private func callback(_ result: ScreenResult<RideDetailsAction>) {
        callbackResult = result
    }

    override func setUp() {
        super.setUp()
        KarhooTestConfiguration.authenticationMethod = .karhooUser
        mockTripRatingCache.tripRatedValueToReturn = true
        testObject = KarhooRideDetailsPresenter(trip: testInitialTrip,
                                                mailComposer: mockFeedbackMailComposer,
                                                tripService: mockTripService,
                                                popupDialogScreenBuilder: mockPopupDialogScreenBuilder,
                                                callback: callback,
                                                analyticsService: mockAnalyticsService,
                                                feedbackScreenBuilder: mockFeedbackScreenBuilder,
                                                tripRatingCache: mockTripRatingCache)

        testObject.set(cancelRideBehaviour: mockCancelRideBehaviour, alertHandler: mockAlertHandler)
    }

    /**
      * When: TripInfo is in the past
      * Then: listener shouldn't be added
      */
    func testPastBookingListening() {
        testInitilisingWith(state: .completed)
        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
    }

    /**
     * When: TripInfo is in the future or on going
     * Then: listener should be added
     */
    func testUpcomingBookingListening() {
        testInitilisingWith(state: .requested)
        XCTAssertEqual(testInitialTrip.tripId, mockTripService.tripTrackingIdentifierSet)
        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
    }

    private func testInitilisingWith(state: TripState) {
        testInitialTrip = TestUtil.getRandomTrip(dateSet: true, state: state)
        mockTripService = MockTripService()

        testObject = KarhooRideDetailsPresenter(trip: testInitialTrip,
                                                mailComposer: mockFeedbackMailComposer,
                                                tripService: mockTripService,
                                                callback: callback)

        testObject.bind(view: mockRideDetailsView)
        testObject.set(cancelRideBehaviour: mockCancelRideBehaviour, alertHandler: mockAlertHandler)
    }

    /**
     *  When:   trip is updated
     *  Then:   screen should be updated
     */
    func testScreenUpdates() {
        testObject.bind(view: mockRideDetailsView)

        mockTripService.trackTripCall.triggerPollSuccess(testInitialTrip)

        XCTAssertNotNil(mockRideDetailsView.setTripCalled)
    }

    /**
     * Given: A scheduled booking
     * Then: The presenter should set the navigation title with the formatted date of the booking
     */
    func testNavigationTitleSet() {
        testObject.bind(view: mockRideDetailsView)
        let timezone = testInitialTrip.origin.timezone()
        let expectedNavigationTitle = KarhooDateFormatter(timeZone: timezone)
                                      .display(detailStyleDate: testInitialTrip.dateScheduled!)

        XCTAssertEqual(expectedNavigationTitle, mockRideDetailsView.theNavigationTitleSet)
    }

    /**
     * When: The user reports an issue
     * Then: The mail constructor should be called
     */
    func testReportIssue() {
        testObject.didPresssReportIsssue()

        XCTAssertEqual(mockFeedbackMailComposer.reportedTripCalled?.tripId, testInitialTrip.tripId)
    }

    /**
     * Given: The screen loads
     * When: No trip rating is present for this trip
     * Then: It should be populated with the correct trip
     * And: Rating options should not be hidden
     */
    func testSettingTrip() {
        mockTripRatingCache.tripRatedValueToReturn = false
        testObject.bind(view: mockRideDetailsView)

        XCTAssertFalse(mockRideDetailsView.hideFeedbackOptionsCalled)
        XCTAssertEqual(mockRideDetailsView.setTripCalled.tripId, testInitialTrip.tripId)
    }

    /**
     * Given: The screen loads
     * When:  trip rating is present for this trip
     * Then: It should be populated with the correct trip
     * And: Rating options should be hidden
     */
    func testSettingTripThatHasBeenRated() {
        mockTripRatingCache.tripRatedValueToReturn = true
        testObject.bind(view: mockRideDetailsView)

        XCTAssertTrue(mockRideDetailsView.hideFeedbackOptionsCalled)
    }

    /**
     *  When:   didPressTrackTrip called
     *  Then:   the closure should be called
     */
    func testTrackTrip() {
        testObject.didPressTrackTrip()

        if case RideDetailsAction.trackTrip(let trip) = callbackResult!.completedValue()! {
            XCTAssertEqual(trip.tripId, testInitialTrip.tripId)
        } else {
            XCTFail("testTrackTrip: callback result incorrect")
        }
    }

    /**
     *  When:   didPressRebook called
     *  Then:   the closure should be called
     */
    func testRebookTrip() {
        testObject.didPressRebookTrip()

        if case RideDetailsAction.rebookTrip(let trip) = callbackResult!.completedValue()! {
            XCTAssertEqual(trip.tripId, testInitialTrip.tripId)
        } else {
            XCTFail("testRebookTrip: callback result incorrect")
        }
    }

    /**
     *  When:   Trip cancelled successfully
     *  Then:   Screen overlay should hide
     *  And:   ride details actions (did cancel trip) should be called
     */
    func testCancelSuccess() {
        testObject.bind(view: mockRideDetailsView)

        testObject.handleSuccessfulCancellation()

        XCTAssertTrue(mockRideDetailsView.popCalled)
    }
    
    /**
      * When: TripInfo update is cancelled by driver (cancelled by dispatch)
      * Then: An alert should show with cancelled by dispatch title and message
      *  And: The trip listener should be removed
      */
    func testCancelledByDispatchTripUpdate() {
        testObject.bind(view: mockRideDetailsView)
        let testTrip = TestUtil.getRandomTrip(tripId: testInitialTrip.tripId,
                                              state: .driverCancelled)
        mockTripService.trackTripCall.triggerPollSuccess(testTrip)

        XCTAssertEqual(mockRideDetailsView.showAlertTitle, UITexts.Trip.tripCancelledByDispatchAlertTitle)
        XCTAssertEqual(mockRideDetailsView.showAlertMessage, UITexts.Trip.tripCancelledByDispatchAlertMessage)
        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
    }

    /**
      * When: Base fare explanation selected
      * Then: Base fare dialog should show
      * And: view should dismiss dialog on completion
      */
    func testPresentDismissBaseFareDialog() {
        testObject.bind(view: mockRideDetailsView)
        testObject.didPressBaseFareExplanation()

        XCTAssertEqual(mockRideDetailsView.presentedView, mockPopupDialogScreenBuilder.returnScreen)
        XCTAssertEqual(mockRideDetailsView.presentedView?.modalTransitionStyle, .crossDissolve)
        XCTAssertEqual(mockRideDetailsView.presentedView?.modalPresentationStyle, .overCurrentContext)

        mockPopupDialogScreenBuilder.triggerScreenResult(ScreenResult.completed(result: ()))

        XCTAssertTrue(mockRideDetailsView.dismissCalled)
    }
    
    /**
     * When: SendTrip rate is invoked
     * Then: The analytic event is sent
     */
    func testRatingEventSentCorrectly() {
        let rate = 5
        let expectedPayload: [String: Any] = ["tripId": testInitialTrip.tripId,
                                              "source": "MOBILE",
                                              "type": "STARS",
                                              "rating": rate,
                                              "timestamp": Date().timeIntervalSince1970]
        
        testObject.sendTripRate(rating: rate)

        XCTAssertEqual(mockAnalyticsService.eventSent, .tripRatingSubmitted)
        
        let eventPayload = mockAnalyticsService.eventPayloadSent!
        XCTAssertTrue(eventPayload["source"] as? String == expectedPayload["source"] as? String)
        XCTAssertTrue(eventPayload["type"] as? String == expectedPayload["type"] as? String)
        XCTAssertTrue(eventPayload["tripId"] as? String == expectedPayload["tripId"] as? String)
        XCTAssertTrue(eventPayload["rating"] as? Int == expectedPayload["rating"] as? Int)
    }

    /**
      * When: Extra feedback is selected
      * Then: Feedback view should be show
      */
    func testExtraFeedbackShown() {
        testObject.bind(view: mockRideDetailsView)
        testObject.didPressTripFeedback()
        XCTAssertEqual(testInitialTrip.tripId, mockFeedbackScreenBuilder.tripIdSet)
        XCTAssertTrue(mockFeedbackScreenBuilder.buildFeedbackScreenCalled)
        XCTAssertEqual(mockRideDetailsView.pushViewController, mockFeedbackScreenBuilder.feedbackScreen)

        mockFeedbackScreenBuilder.triggerScreenResult(.completed(result: ()))

        XCTAssertTrue(mockRideDetailsView.popCalled)
        XCTAssertTrue(mockRideDetailsView.hideFeedbackOptionsCalled)
    }
}
