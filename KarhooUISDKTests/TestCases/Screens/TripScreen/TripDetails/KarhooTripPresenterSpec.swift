//
//  KarhooTripPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

final class KarhooTripPresenterSpec: KarhooTestCase {

    private var mockInitialTrip: TripInfo!
    private var mockTripView: MockTripView!
    private var mockTripService: MockTripService!
    private var mockDriverTrackingService: MockDriverTrackingService!
    private var mockCancelRide: MockCancelRideBehaviour!
    private var mockPhoneNumberCaller = MockPhoneNumberCaller()
    private var mockAnalytics: MockAnalytics!
    private var mockRideDetailsScreenBuilder = MockRideDetailsScreenBuilder()
    private var testObject: KarhooTripPresenter!
    private var screenResult: ScreenResult<TripScreenResult>?

    override func setUp() {
        super.setUp()
        
        simulateShowingScreen(tripState: .confirmed)
    }

    private func tripScreenCallback(result: ScreenResult<TripScreenResult>) {
        self.screenResult = result
    }

    private func simulateShowingScreen(tripState: TripState) {
        mockInitialTrip = TestUtil.getRandomTrip(state: tripState)
        mockTripView = MockTripView()
        mockTripService = MockTripService()
        mockCancelRide = MockCancelRideBehaviour()
        mockAnalytics = MockAnalytics()
        mockDriverTrackingService = MockDriverTrackingService()

        testObject = KarhooTripPresenter(initialTrip: mockInitialTrip,
                                            service: mockTripService,
                                            driverTrackingService: mockDriverTrackingService,
                                            cancelRideBehaviour: mockCancelRide,
                                            phoneNumberCaller: mockPhoneNumberCaller,
                                            analytics: mockAnalytics,
                                            rideDetailsScreenBuilder: mockRideDetailsScreenBuilder,
                                            callback: tripScreenCallback)
        
        testObject.load(view: mockTripView)
        testObject.screenAppeared()
    }
    
    /**
     *  When:   Screen appears
     *  Then:   It should start listening for current trip updates
     *   And:   It should not start listening for current trip driver location updates
     *   And:   The screen should hide the locate button
     */
    func testTripAndDriverLocationUpdates() {
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)

        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
        XCTAssertTrue(mockTripView.theLocateButtonHidden!)
    }
    
    /**
     *  When:   Screen appears
     *  And:    The driver is en route / can be tracked
     *  Then:   It should start listening for current trip updates
     *   And:   It should start listening for current trip driver location updates
     *   And:   The screen should hide the locate button
     */
    func testTripAndDriverLocationUpdatesDriverEnRoute() {
        let driverCanBeTrackedStates: [TripState] = [.driverEnRoute, .arrived, .passengerOnBoard]
        
        driverCanBeTrackedStates.forEach { (state) in
            testObject = nil
          
            simulateShowingScreen(tripState: state)
            
            XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
            XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
            XCTAssertTrue(mockTripView.theLocateButtonHidden!)
        }
    }

    /**
     *  When:   Screen appears
     *  Then:   A analitycs event should be triggered
     */
    func testScreenAppears() {
        simulateShowingScreen(tripState: .driverEnRoute)
        testObject.screenAppeared()
        XCTAssertTrue(mockAnalytics.trackTripOpenedCalled)
    }

    /**
     * Given:   Initialised screen with active listeners
     *  When:   Screen disappears
     *  Then:   It should remove trip listener
     *   And:   It should remove driver location listener
     */
    func testScreenDisappears() {
        simulateShowingScreen(tripState: .driverEnRoute)
        testObject.screenDidDisappear()
        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
    }

    /** 
     *  When:   Pressing cancel trip button
     *  Then:   Cancel trip behaviour should be triggered
     */
    func testCancelTripButton() {
        testObject.cancelBookingPressed()
        XCTAssertTrue(mockCancelRide.cancelPressedCalled)
    }

    /** 
     *  When:   Trip update sends driverCancelled message
     *  Then:   Routing should be notified (with cancelByUser == false)
     */
    func testUpdateCancelledByDriver() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .driverCancelled)
        mockTripService.trackTripCall.triggerPollSuccess(trip)

        XCTAssertEqual(mockTripView.actionAlertTitle, UITexts.Trip.tripCancelledByDispatchAlertTitle)
        XCTAssertEqual(mockTripView.actionAlertMessage, UITexts.Trip.tripCancelledByDispatchAlertMessage)

        mockTripView.triggerAlertAction(atIndex: 0)

        if case .closed? = screenResult!.completedValue() {
            XCTAssertTrue(true)
        } else {
            XCTFail("Routing not notified (with cancelByUser != false)")
        }
    }

    /**
     *  When:   Trip stream sends karhooCancelled message
     *  Then:   Routing should be notified cancelledByKarhoo
     */
    func testCancelledByKarhooTripUpdate() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .karhooCancelled)
        
        mockTripService.trackTripCall.triggerPollSuccess(trip)

        guard case .closed? = screenResult!.completedValue() else {
            XCTFail("Routing not notified cancelledByKarhoo")
            return
        }
    }

    /**
     * When: The user calls fleet
     * Then: Phone number caller should call fleet number
     */
    func testCallFleet() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .driverEnRoute)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.callFleetPressed()

        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, trip.fleetInfo.phoneNumber)
    }

    /**
     * When: The user calls driver
     * Then: Phone number caller should call driver number
     */
    func testCallDriver() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .driverEnRoute)

        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.callDriverPressed()
        
        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, trip.vehicle.driver.phoneNumber)
    }

    /**
      * Given: A trip pre driver alocation
      * When:  The map is focused
      * Then:  The map presenter should focus on route
      *  And:  TripStateChanged analytics event should be fired
      */
    func testPreDriverAllocationFocus() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .requested)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.locatePressed()

        XCTAssertTrue(mockTripView.focusMapOnRouteCalled)
        XCTAssertFalse(mockTripView.focusMapOnDriverAndPickupCalled)
        XCTAssertFalse(mockTripView.focusMapOnDriverCalled)
        XCTAssertTrue(mockAnalytics.tripStateChangedCalled)
    }

    /**
     * Given: A trip where the driver is en route
     * When: The map is focused
     * Then: The map presenter should focus on the driver and pick up
     */
    func testDriverEnRouteFocus() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .driverEnRoute)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.locatePressed()

        XCTAssertTrue(mockTripView.focusOnUserLocationCalled)
    }
    
    /**
     * Given: A trip where the driver has arrived
     * When: The map is focused
     * Then: The map presenter should focus on the driver and pick up
     */
    func testDriverArrivedFocus() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .arrived)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.locatePressed()

        XCTAssertFalse(mockTripView.focusMapOnDriverCalled)
    }

    /**
     * Given: A trip with the passenger on board
     * When: The map is focused
     * Then: The map presenter should focus on the the driver and destination
     */
    func testPassengerOnBoardFocus() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .passengerOnBoard)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        testObject.locatePressed()

        XCTAssertFalse(mockTripView.focusMapOnDriverCalled)
    }

    /**
     * When: Driver location is updated
     *  And: the user has not moved the map
     * Then: The screen should be told to update
     */
    func testDriverLocationFocus() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .passengerOnBoard)
        mockTripService.trackTripCall.triggerPollSuccess(trip)

        let driverTrackingInfo = TestUtil.getRandomDriverTrackingInfo()
        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(driverTrackingInfo)

        XCTAssertFalse(mockTripView.focusMapOnRouteCalled)
    }

    /**
     *  Given:  Trip has been updated with trip in POB
     *   When:  Another trip POB update happens
     *   Then:  TripStateChanged analytics event should NOT be fired
     */
    func testTripPOBupdate() {
        let trip = TestUtil.getRandomTrip(state: .passengerOnBoard)
        mockTripService.trackTripCall.triggerPollSuccess(trip)
        mockAnalytics.tripStateChangedCalled = false

        mockTripService.trackTripCall.triggerPollSuccess(trip)
        XCTAssertFalse(mockAnalytics.tripStateChangedCalled)
    }

    /**
      * When: The user moves the map
      * Then: The locate button should be visible
      * And: The map should not be focused on driver location update
      */
    func testMapMovedByUser() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .passengerOnBoard)
        mockTripService.trackTripCall.triggerPollSuccess(trip)

        testObject.userMovedMap()
        let driverTrackingInfo = TestUtil.getRandomDriverTrackingInfo()
        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(driverTrackingInfo)

        XCTAssertFalse(mockTripView.theLocateButtonHidden!)
        XCTAssertFalse(mockTripView.focusMapOnRouteCalled)
        XCTAssertFalse(mockTripView.focusMapOnDriverCalled)
        XCTAssertFalse(mockTripView.focusMapOnDriverAndPickupCalled)
    }

    /**
     * When: Show loading is called
     * Then: should call show loading screen on JorneyView
     */
    func testShowLoadingOverlay() {
        testObject.showLoadingOverlay()

        XCTAssertTrue(mockTripView.showLoadingCalled)
    }

    /**
     * When: Hide loading is called
     * Then: should call hide loading screen on JorneyView
     */
    func testHideLoadingOverlay() {
        testObject.hideLoadingOverlay()

        XCTAssertTrue(mockTripView.hideLoadingCalled)
    }
    
    func testHandleSuccessfulCancellation() {
        testObject.handleSuccessfulCancellation()
        
        guard case .closed? = screenResult?.completedValue()! else {
            XCTFail("Wrong result")
            return
        }
    }

    /**
     * When: Trip completes
     * Then: Ride Details screen should be presented
     */
    func testCompletedPresentsRideDetails() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .completed)

        mockTripService.trackTripCall.triggerPollSuccess(trip)

        XCTAssertEqual(trip.tripId, mockRideDetailsScreenBuilder.overlayTripSet?.tripId)
        XCTAssertEqual(mockRideDetailsScreenBuilder.overlayReturnViewController, mockTripView.presentedView)
    }

    /**
     * Given: Ride details completes
     * When: Result of ride details is rebook trip
     * Then: Callback rebook intent
     */
    func testRebookTripFromRideDetails() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .completed)

        mockTripService.trackTripCall.triggerPollSuccess(trip)

        mockRideDetailsScreenBuilder.triggerRideDetailsOverlayResult(.completed(result: .rebookTrip(trip)))

        guard case .rebookTrip(let detailsToRebook)? = screenResult?.completedValue()! else {
            XCTFail("Wrong result")
            return
        }
        XCTAssertEqual(detailsToRebook.originLocationDetails?.placeId, trip.origin.placeId)
    }

    /**
     * When: Ride details dismisses from being closed by user
     * Then: Callback should be called
     */
    func testTripCompleteDismissesView() {
        let trip = TestUtil.getRandomTrip(tripId: mockInitialTrip.tripId,
                                          state: .completed)

        mockTripService.trackTripCall.triggerPollSuccess(trip)

        mockRideDetailsScreenBuilder.triggerRideDetailsOverlayResult(.cancelled(byUser: true))

        guard case .closed? = screenResult?.completedValue()! else {
            XCTFail("Wrong result")
            return
        }
    }
}
