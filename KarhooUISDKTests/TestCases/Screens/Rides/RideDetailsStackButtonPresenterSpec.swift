//
//  BookingDetailsButtonPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class RideDetailsStackButtonPresenterSpec: XCTestCase {

    private var testObject: RideDetailsStackButtonPresenter!
    private var mockStackButtonView: MockStackButtonView!
    private var mockFeedbackMailComposer: MockFeedbackMailComposer!
    private var mockRideDetailsStackButtonActions: MockRideDetailsStackButtonActions!

    override func setUp() {
        mockStackButtonView = MockStackButtonView()
        mockFeedbackMailComposer = MockFeedbackMailComposer()
        mockRideDetailsStackButtonActions = MockRideDetailsStackButtonActions()
    }

    /**
     * Given: A trip that can be cancelled
     * And: The driver phone number is available
     * Then: The presenter should set up two buttons, cancel ride and contact driver
     */
    func testUpComingTripButtonsWithDriverNumber() {
        let tripThatCanBeCancelled = TestUtil.getRandomTrip(state: .requested)

        testObject = RideDetailsStackButtonPresenter(trip: tripThatCanBeCancelled,
                                                     stackButton: mockStackButtonView,
                                                     mailComposer: mockFeedbackMailComposer,
                                                     rideDetailsStackButtonActions: mockRideDetailsStackButtonActions)

        XCTAssertEqual(mockStackButtonView.firstButtonTextCalled, UITexts.Bookings.cancelRide)
        XCTAssertEqual(mockStackButtonView.secondButtonTextCalled, UITexts.Bookings.contactDriver)
    }
    
    /**
     * Given: A trip that can be cancelled
     * And: The driver phone number is not available
     * Then: The presenter should set up two buttons, cancel ride and contact supplier
     */
    func testUpComingTripButtonsWithoutDriverNumber() {
        let tripThatCanBeCancelled = TestUtil.getRandomTrip(state: .requested, vehicle: Vehicle())

        testObject = RideDetailsStackButtonPresenter(trip: tripThatCanBeCancelled,
                                                     stackButton: mockStackButtonView,
                                                     mailComposer: mockFeedbackMailComposer,
                                                     rideDetailsStackButtonActions: mockRideDetailsStackButtonActions)

        XCTAssertEqual(mockStackButtonView.firstButtonTextCalled, UITexts.Bookings.cancelRide)
        XCTAssertEqual(mockStackButtonView.secondButtonTextCalled, UITexts.Bookings.contactFleet)
    }

    /**
     * Given: A trip that is completed or cancelled or failed (past)
     * Then: The presenter should set up two buttons with correct text and actions
     */
    func testPastTrip() {
        let pastStates = TripStatesGetter().getStatesForTripRequest(type: .past)

        pastStates.forEach({ state in
            testLoadingWithTripState(state)
        })
    }

    private func testLoadingWithTripState(_ tripState: TripState) {
        let trip = TestUtil.getRandomTrip(state: tripState)
        testObject = RideDetailsStackButtonPresenter(trip: trip,
                                                     stackButton: mockStackButtonView,
                                                     mailComposer: mockFeedbackMailComposer,
                                                     rideDetailsStackButtonActions: mockRideDetailsStackButtonActions)

        XCTAssertEqual(mockStackButtonView.firstButtonTextCalled, UITexts.Bookings.reportIssue)
        XCTAssertEqual(mockStackButtonView.secondButtonTextCalled, UITexts.Bookings.rebookRide)
    }

    /**
     * Given:   A trip that is in progress (user in the car)
     *  Then:   The presenter should set up one button with correct text and track trip button
     */
    func testInprogressTrip() {
        let inProgressTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)
        testObject = RideDetailsStackButtonPresenter(trip: inProgressTrip,
                                                     stackButton: mockStackButtonView,
                                                     mailComposer: mockFeedbackMailComposer,
                                                     rideDetailsStackButtonActions: mockRideDetailsStackButtonActions)

        XCTAssertEqual(mockStackButtonView.singleButtonTextCalled, UITexts.Bookings.contactFleet)
        mockStackButtonView.singleButtonAction?()
//        XCTAssertTrue(mockRideDetailsStackButtonActions.trackRideCalled)
//        XCTAssertFalse(mockRideDetailsStackButtonActions.rebookRideCalled)
    }

    /**
     * Given:   A trip state is unknown
     *  When:   Presenter created
     *  Then:   StackButtonView should hide
     */
    func testUnknownTripState() {
        let trip = TestUtil.getRandomTrip(state: .unknown)
        testObject = RideDetailsStackButtonPresenter(trip: trip,
                                                     stackButton: mockStackButtonView,
                                                     mailComposer: mockFeedbackMailComposer,
                                                    rideDetailsStackButtonActions: mockRideDetailsStackButtonActions)
        XCTAssertTrue(mockRideDetailsStackButtonActions.hideRideOptionsCalled)
    }
}
