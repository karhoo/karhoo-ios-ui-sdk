//
//  KarhooBookingPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//
import XCTest
import CoreLocation
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

// swiftlint:disable file_length
final class KarhooBookingPresenterSpec: KarhooTestCase {

    private var mockBookingRouter: MockBookingRouter!
    private var mockAppAnalytics: MockAnalytics!
    private var mockJourneyDetailsManager: MockJourneyDetailsManager!
    private var mockUserService: MockUserService!
    private var testObject: KarhooBookingPresenter!
    private var mockBookingView: MockBookingView!
    private var mockPhoneNumberCaller: MockPhoneNumberCaller!
    private var mockTripScreenBuilder: MockTripScreenBuilder!
    private var mockRideDetailsScreenBuilder: MockRideDetailsScreenBuilder!
    private var mockCheckoutScreenBuilder: MockCheckoutScreenBuilder!
    private var mockAddressScreenBuilder: MockAddressScreenBuilder!
    private var mockDatePickerScreenBuilder: MockDatePickerScreenBuilder!
    private var mockRidesScreenBuilder: MockRidesScreenBuilder!
    private var mockCardRegistrationFlow: MockCardRegistrationFlow!
    private var bookingScreenResult: BookingScreenResult?
    private var mockTripRatingCache: MockTripRatingCache = MockTripRatingCache()
    private var mockURLOpener = MockURLOpener()
    private var featureFlagProvider: FeatureFlagProvider = MockFeatureFlagProvider()

    override func setUp() {
        super.setUp()
        KarhooTestConfiguration.setTokenAuthentication()
        mockBookingRouter = MockBookingRouter()
        mockAppAnalytics = MockAnalytics()
        mockJourneyDetailsManager = MockJourneyDetailsManager()
        mockUserService = MockUserService()
        mockPhoneNumberCaller = MockPhoneNumberCaller()
        mockTripScreenBuilder = MockTripScreenBuilder()
        mockRideDetailsScreenBuilder = MockRideDetailsScreenBuilder()
        mockCheckoutScreenBuilder = MockCheckoutScreenBuilder()
        mockJourneyDetailsManager.journeyDetailsToReturn = TestUtil.getRandomJourneyDetails()
        mockAddressScreenBuilder = MockAddressScreenBuilder()
        mockDatePickerScreenBuilder = MockDatePickerScreenBuilder()
        mockRidesScreenBuilder = MockRidesScreenBuilder()
        mockCardRegistrationFlow = MockCardRegistrationFlow()
        testObject = buildTestObject(callback: nil)

        mockBookingView = MockBookingView()
        testObject.load(view: mockBookingView)
    }

    private func buildTestObject(callback: ScreenResultCallback<BookingScreenResult>?) -> KarhooBookingPresenter {
        KarhooBookingPresenter(
            router: mockBookingRouter,
            journeyDetailsManager: mockJourneyDetailsManager,
            userService: mockUserService,
            analytics: mockAppAnalytics,
            phoneNumberCaller: mockPhoneNumberCaller,
            callback: callback,
            tripScreenBuilder: mockTripScreenBuilder,
            rideDetailsScreenBuilder: mockRideDetailsScreenBuilder,
            ridesScreenBuilder: mockRidesScreenBuilder,
            addressScreenBuilder: mockAddressScreenBuilder,
            datePickerScreenBuilder: mockDatePickerScreenBuilder,
            tripRatingCache: mockTripRatingCache,
            urlOpener: mockURLOpener,
            featureFlagsProvider: featureFlagProvider
        )
    }

    private func bookingScreenCallback(result: ScreenResult<BookingScreenResult>) {
        self.bookingScreenResult = result.completedValue()!
    }

    /**
      * When: View appears
      * Then: map padding should be set
      * And: The analytics event should be triggered
      */
    func testViewAppears() {
        testObject.viewWillAppear()
        
        XCTAssertTrue(mockAppAnalytics.bookingScreenOpenedCalled)
    }

    /**
     * Given: Booking status updates
     * When: destination is nil
     * Then: Map padding should be set without bottom padding
     */
    func testJourneyDetailsUpdatesNoDestination() {
        let mockJourneyDetails = TestUtil.getRandomJourneyDetails(destinationSet: false)
        mockJourneyDetailsManager.triggerCallback(journeyDetails: mockJourneyDetails)
    }

    /**
     *  When:   Resetting booking status
     *  Then:   The bookingStatus should revert to its initial state
     */
    func testResetJourneyDetails() {
        mockJourneyDetailsManager.journeyDetailsToReturn = TestUtil.getRandomJourneyDetails()
        testObject.resetJourneyDetails()

        XCTAssertTrue(mockJourneyDetailsManager.resetCalled)
    }

    /**
      * When: Booking details is set
      * Then: the booking state should be reset
      * And: Set with new details
      */
    func testBookingDetailsSet() {
        let testJourneyDetails = TestUtil.getRandomJourneyDetails()

        mockBookingView.set(journeyDetails: testJourneyDetails)
        XCTAssertEqual(mockBookingView.theSetJourneyDetails?.originLocationDetails?.placeId,
                       testJourneyDetails.originLocationDetails?.placeId)
        XCTAssertEqual(mockBookingView.theSetJourneyDetails?.destinationLocationDetails!.placeId,
                       testJourneyDetails.destinationLocationDetails!.placeId)

        testObject.populate(with: testJourneyDetails)
        XCTAssertEqual(testJourneyDetails.originLocationDetails?.placeId,
                       mockJourneyDetailsManager.resetJourneyDetailsSet!.originLocationDetails?.placeId)
    }

    /**
     * When: Trip canceled by system (Driver cancelled / no drivers available)
     * Then: allocation screen should hide
     * And: show alert with an error
     * And: booking status origin and destination should be set
     */
    func testTripCanceledBySystemDriverUnavailable() {
        let mockTrips = [TestUtil.getRandomTrip(state: .driverCancelled),
                         TestUtil.getRandomTrip(state: .noDriversAvailable)]

        mockTrips.forEach({ mockTrip in
            testObject.tripCancelledBySystem(trip: mockTrip)

            XCTAssertTrue(mockBookingView.hideAllocationScreenCalled)

            XCTAssertEqual(UITexts.Trip.noDriversAvailableTitle, mockBookingView.showAlertTitle)
            XCTAssertEqual(String(format: UITexts.Trip.noDriversAvailableMessage,
                                  mockTrip.fleetInfo.name), mockBookingView.showAlertMessage)
        XCTAssertTrue(mockTrip.origin.toLocationInfo()
            .equals(mockJourneyDetailsManager.resetJourneyDetailsSet!.originLocationDetails!))
        XCTAssertTrue(mockTrip.destination!.toLocationInfo()
            .equals(mockJourneyDetailsManager.resetJourneyDetailsSet!.destinationLocationDetails!))

            tearDown()
        })

    }

    /**
     * When: Trip canceled by system (Karhoo cancelled)
     * Then: allocation screen should hide
     * And: show alert with an error
     * And: booking status origin and destination should be set
     */
    func testTripCanceledBySystemKarhooCancelled() {
        let mockTrip = TestUtil.getRandomTrip(state: .karhooCancelled)
        testObject.tripCancelledBySystem(trip: mockTrip)

        XCTAssertTrue(mockBookingView.hideAllocationScreenCalled)

        XCTAssertEqual(UITexts.Trip.karhooCancelledAlertTitle, mockBookingView.showAlertTitle)
        XCTAssertEqual(UITexts.Trip.karhooCancelledAlertMessage, mockBookingView.showAlertMessage)

        XCTAssertTrue(mockTrip.origin.toLocationInfo()
            .equals(mockJourneyDetailsManager.resetJourneyDetailsSet!.originLocationDetails!))
        XCTAssertTrue(mockTrip.destination!.toLocationInfo()
            .equals(mockJourneyDetailsManager.resetJourneyDetailsSet!.destinationLocationDetails!))

    }

    /**
     * Given: Trip canceled by user
     * When: Cancellation succeeds
     * Then: allocation screen should hide
     * And: show alert with cancellation success message
     */
    func testTripCanceledByUserSuccess() {
        testObject.tripSuccessfullyCancelled()

        XCTAssertTrue(mockBookingView.hideAllocationScreenCalled)

        XCTAssertEqual(UITexts.Bookings.cancellationSuccessAlertTitle, mockBookingView.showAlertTitle)
        XCTAssertEqual(UITexts.Bookings.cancellationSuccessAlertMessage, mockBookingView.showAlertMessage)
    }

    /**
     * Given: Trip canceled by user
     * When: Cancellation fails
     * Then: allocation screen should not hide
     * And: show alert with cancellation success message
     */
    func testTripCanceledByUserFails() {
        let mockTrip = TestUtil.getRandomTrip(state: .driverCancelled)
        testObject.tripCancellationFailed(trip: mockTrip)

        XCTAssertFalse(mockBookingView.hideAllocationScreenCalled)

        XCTAssertEqual(UITexts.Trip.tripCancelBookingFailedAlertTitle, mockBookingView.actionAlertTitle)
        XCTAssertEqual(UITexts.Trip.tripCancelBookingFailedAlertMessage, mockBookingView.actionAlertMessage)

        mockBookingView.triggerAlertAction(atIndex: 1)
        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, mockTrip.fleetInfo.phoneNumber)
    }

    /**
     *  When:   A user logs out
     *  Then:   The screen should reset
     *  And:    Trip rating cache should be cleared
     */
    func testUserLogsOut() {
        mockJourneyDetailsManager.journeyDetailsToReturn = TestUtil.getRandomJourneyDetails()
        mockUserService.triggerUserStateChange(user: nil)

        XCTAssertTrue(mockJourneyDetailsManager.resetCalled)
        XCTAssertTrue(mockTripRatingCache.clearTripRatingCalled)
    }

    /**
     *  When:   An asap booking has been confirmed
     *  Then:   The allocation screen should be showed
     *  And: Booking request presenter should be dismissed
     */
    func testBookingConfirmed() {
        // TODO: Provide new test implementation for this case
    }

    /**
     *  When: booking request fails
     *  Then: error should show
     */
    func testBookingRequestFails() {
        // TODO: Provide new test implementation for this case
    }

    /**
     *  When:   Booking request is cancelled
     *  Then:   QuoteList should appear
     *   And:   QuoteCategories should appear
     */
    func testUserCancelledBooking() {
        // TODO: Provide new test implementation for this case
    }

    /**
     *  When:   A booking returns with karhooCancelled state
     *  Then:   The alerthandler should show an appropriate message
     *   And:   The booking screen should be reset
     */
    func testKarhooCancelledBooking() {
        // TODO: Provide new test implementation for this case
    }

    /**
     *  When:   A booking returns with noDriverAavailable state
     *  Then:   The alerthandler should show an appropriate message
     *   And:   The booking screen should be reset
     */
    func testNoDriversAvailableBooking() {
        // TODO: Provide new test implementation for this case
    }

    /**
     * When: Prebook trip is booked
     * Then: prebook confirmation should show
     * And: screen should dismiss when closed
     */
    func testPrebookConfirmationPresentAndDismiss() {
        // TODO: Provide new test implementation for this case
    }

    /**
      * When: Prebook confimation is closed with result 'show ride details'
      * Then: View should show ride details for specified trip
      */
    func testShowRideDetailsAfterPrebookConfirmation() {
        // TODO: Provide new test implementation for this case
    }

    /**
     * Given: A callback is set on the booking presenter
     * When: Prebook confimation is closed
     * Then: Callback should be called with expected result
     */
    func testCallbackOnBookingPrebookConfirmnation() {
        // TODO: Provide new test implementation for this case
//        testObject = buildTestObject(callback: bookingScreenCallback)
//        testObject.load(view: mockBookingView)
//
//        let tripBooked = TestUtil.getRandomTrip(dateSet: true)
//        let rideDetailsResult = ScreenResult<PrebookConfirmationAction>.completed(result: .rideDetails)
//
//        mockCheckoutScreenBuilder.triggerCheckoutScreenResult(.completed(result: tripBooked))
//        mockBookingView.triggerDismissCallback()
//
//        mockPrebookConfirmationScreenBuilder.triggerScreenResult(rideDetailsResult)
//
//        guard case .prebookConfirmed? = bookingScreenResult else {
//            XCTFail("wrong result")
//            return
//        }
    }
    
    /**
      * When: User chooses to wait on the Ride Details screen for an unallocated trip
      * Then: View should show ride details for specified trip
      */
    func testShowRideDetailsOnDriverAllocationDelayAlertDismissal() {
        let tripBooked = TestUtil.getRandomTrip(dateSet: true)
        
        testObject.tripDriverAllocationDelayed(trip: tripBooked)
        
        XCTAssertTrue(mockBookingView.showAlertCalled)
        XCTAssertEqual(UITexts.GenericTripStatus.driverAllocationDelayTitle, mockBookingView.actionAlertTitle)
        XCTAssertEqual(UITexts.GenericTripStatus.driverAllocationDelayMessage, mockBookingView.actionAlertMessage)
        
        mockBookingView.triggerAlertAction(atIndex: 0)
        
        XCTAssertTrue(mockBookingView.resetAndLocateCalled)
        XCTAssertTrue(mockBookingView.hideAllocationScreenCalled)
        XCTAssertEqual(tripBooked.tripId, mockRideDetailsScreenBuilder.overlayTripSet?.tripId)
        XCTAssertEqual(mockBookingView?.presentedView, mockRideDetailsScreenBuilder.overlayReturnViewController)
    }
    
    /**
      * When: trip is allocated
      * Then: View should hide allocation screen
      */
    func testHideAllocationScreen() {
        let allocatedTrip = TestUtil.getRandomTrip()
        testObject.tripAllocated(trip: allocatedTrip)

        XCTAssertTrue(mockBookingView.hideAllocationScreenCalled)
        XCTAssertTrue(mockBookingView.resetCalled)
    }

    /**
     * When: Callback is provided in init
     * And: The view finishes
     * Then: Callback should be set
     */
    func testFinishingWithCallbackSet() {
        testObject = buildTestObject(callback: bookingScreenCallback)

        mockBookingView = MockBookingView()
        testObject.load(view: mockBookingView)

        let trip = TestUtil.getRandomTrip(state: .driverEnRoute)
        testObject.tripAllocated(trip: trip)

        guard case .tripAllocated = bookingScreenResult! else {
            XCTFail("wrong result")
            return
        }
    }

    /**
      * When: No callback is provided in init
      * And: The view finishes
      * Then: view should go to trip screen
      * And: Trip screen finishes with rebookTrip
      * And: Booking status should be updated
      */
    func  testFinishingWithNoCallbackSet() {
        let trip = TestUtil.getRandomTrip(state: .karhooCancelled)
        testObject.tripAllocated(trip: trip)

        XCTAssertEqual(trip.tripId, mockTripScreenBuilder.tripSet?.tripId)
        XCTAssertEqual(mockBookingView.presentedView, mockTripScreenBuilder.returnViewController)
        XCTAssertTrue(mockBookingView.resetCalled)

        let mockBookingDetails = TestUtil.getRandomJourneyDetails()
        mockTripScreenBuilder
            .callbackSet?(.completed(result: TripScreenResult.rebookTrip(rebookDetails: mockBookingDetails)))
        XCTAssertEqual(mockBookingDetails, mockJourneyDetailsManager.resetJourneyDetailsSet)
    }

    /**
     * When: rideListCompleted with trackTrip  set
     * Then: TripScreenBuilder should be called and presented
     * When: TripScreenBuilder finishis with action to rebook
     * Then: booking status should be updated
     */
    func testRideListCompletedWithTrackTrip() {
        let mockTrip = TestUtil.getRandomTrip()

        testObject.showRidesList(presentationStyle: nil)
        XCTAssertEqual(mockRidesScreenBuilder.returnViewController, mockBookingView.presentedView)

        mockRidesScreenBuilder.triggerRidesScreenResult(.completed(result: .trackTrip(trip: mockTrip)))
        
        mockBookingView.triggerDismissCallback()
        
        XCTAssertEqual(mockTrip.tripId, mockTripScreenBuilder.tripSet?.tripId)
        XCTAssertEqual(mockBookingView.presentedView, mockTripScreenBuilder.returnViewController)

        let mockBookingDetails = TestUtil.getRandomJourneyDetails()
        mockTripScreenBuilder
            .callbackSet?(.completed(result: TripScreenResult.rebookTrip(rebookDetails: mockBookingDetails)))
        XCTAssertEqual(mockBookingDetails, mockJourneyDetailsManager.resetJourneyDetailsSet)
    }

    /**
     * When: rideListCompleted with bookNewTrip set
     * Then: view should resetAndLocate
     */
    func testRideListCompletedWithBookNewTrip() {
        testObject.showRidesList(presentationStyle: nil)
        mockRidesScreenBuilder.triggerRidesScreenResult(.completed(result: .bookNewTrip))
        mockBookingView.triggerDismissCallback()

        XCTAssertTrue(mockBookingView.resetAndLocateCalled)
    }

    /**
     * When: rideListCompleted with rebookTrip set
     * Then: booking status should be updated
     */
    func testRideListCompletedWithRebookTrip() {
        let mockTrip = TestUtil.getRandomTrip()
        testObject.showRidesList(presentationStyle: nil)
        mockRidesScreenBuilder.triggerRidesScreenResult(.completed(result: .rebookTrip(trip: mockTrip)))

        var mockJourneyDetails = JourneyDetails(originLocationDetails: mockTrip.origin.toLocationInfo())
        mockJourneyDetails.destinationLocationDetails = mockTrip.destination?.toLocationInfo()
        mockBookingView.triggerDismissCallback()
        XCTAssertEqual(mockJourneyDetails, mockJourneyDetailsManager.resetJourneyDetailsSet)
    }

    /**
     * Given: The user is a guest user
     * When: The user confirms that he/she wants to follow the trip
     * Then: URL opener should open agent portal and Trip screen should not open
     */
    func testWhenTheUserConfirmsToTrackShouldOpenTheTripTrackingURL() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        let testTrip = TestUtil.getRandomTrip()
        testObject.goToTripView(trip: testTrip)
        mockBookingView.triggerAlertAction(atIndex: 1)

        XCTAssertEqual(testTrip.followCode, mockURLOpener.followCodeSet)
        XCTAssertNil(mockTripScreenBuilder.tripSet)
    }

    /**
     * Given: The user is a guest user
     * When: The user dismisses trip tracking alert
     * Then: URL opener should not open agent portal
     */
    func testWhenTheUserDismissesTripTrackingShouldNotOpenTheTripTrackingURL() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        let testTrip = TestUtil.getRandomTrip()
        testObject.goToTripView(trip: testTrip)
        mockBookingView.triggerAlertAction(atIndex: 0)

        XCTAssertNil(mockURLOpener.followCodeSet)
    }

    /**
     * Given: The user is a guest user
     * When: The user is presented the trip tracking alert
     * Then: The alert should have correct title, message and button titles
     */
    func testWhenTheUserIsPresentedTheTripTrackingAlertItShouldHaveCorrectContent() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        let testTrip = TestUtil.getRandomTrip()
        testObject.goToTripView(trip: testTrip)

        XCTAssertEqual(mockBookingView.actionAlertTitle, UITexts.Trip.trackTripAlertTitle)
        XCTAssertEqual(mockBookingView.actionAlertMessage, UITexts.Trip.trackTripAlertMessage)
        XCTAssertEqual(mockBookingView.alertActions[0].action.title, UITexts.Trip.trackTripAlertDismissAction)
        XCTAssertEqual(mockBookingView.alertActions[1].action.title, UITexts.Trip.trackTripAlertAction)
    }

    /**
     * When: Booking screen is opened
     * Then: Analytics event should be triggered
     */
    func testWhenBookingOpensProperAnalyticsEventIsTriggered() {
        mockBookingView.loadViewIfNeeded()
        
    }
}
