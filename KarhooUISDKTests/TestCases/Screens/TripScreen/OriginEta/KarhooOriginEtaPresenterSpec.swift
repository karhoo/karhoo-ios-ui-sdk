//
//  KarhooOriginEtaPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooOriginEtaPresenterSpec: KarhooTestCase {
    
    private let testTripId: String = "some_tripid"
    private var mockTripService: MockTripService!
    private var mockDriverTrackingService: MockDriverTrackingService!
    private var testObject: KarhooOriginEtaPresenter!
    private var mockOriginEtaView: MockOriginEtaView!
    private lazy var testTrip = TestUtil.getRandomTrip(tripId: testTripId)

    override func setUp() {
        super.setUp()
        mockOriginEtaView = MockOriginEtaView()
        mockTripService = MockTripService()
        mockDriverTrackingService = MockDriverTrackingService()
        testObject = KarhooOriginEtaPresenter(tripService: mockTripService,
                                              driverTrackingService: mockDriverTrackingService,
                                              etaView: mockOriginEtaView)
 
    }
    
    /**
      * When: Start monitoring eta is called
      * Then: The trip service should have an active listener for trip status
      * And: The injected trip id should be the trip to monitor
      * And: Should not call track driver
      * And: The view should be hidden
      */
    func testStartMonitoringEta() {
        testObject.monitorTrip(tripId: testTripId)

        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockOriginEtaView.hideEtaCalled)
    }
    
    /**
     * Given: Driver en route
     * When: Stop monitoring eta is called
     * Then: The trip service should have no active listeners for trip status
     * And: Driver tracking observer should be disposed
     */
    func testStopMonitoring() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        testObject.stopMonitoringTrip()
        
        XCTAssertFalse(mockTripService.trackTripStatusCall.hasObserver)
    }
    
    /**
      * Given: Driver is enroute
      * When: TripInfo status is updated and is still driver en route
      * Then: Track driver should only be called once
      */
    func testSuccessiveDriverEnrouteStatusUpdates() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)
        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
        mockDriverTrackingService.trackDriverCalled = false
        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)
        XCTAssertFalse(mockDriverTrackingService.trackDriverCalled)
    }
    
    /**
      * Given: Driver en route
      * Then: Track driver should be called
      * When: Passenger is onboard
      * Then: Driver tracking observer should be disposed
      */
    func testPassengerOnboardDoesntListenForDriverLocation() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)
        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
    }
     
    /**
      * Given: TripInfo is confirmed
      * When: trip status is updated to driver is en route
      * Then: Driver tracking observer should start
      * And: TripInfo status should only have the one listener
      */
    func testNonTrackingStateToDriverEnroute() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.confirmed)
        
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)
    }
    
    /**
      * Given: Driver is enroute
      * When: trip state changes to passenger onboard
      * And: For whatever godly reason the state changes back to driver en route
      * Then: Only one driver location listener should be present
      */
    func testDriverEnrouteGlitchEdgecase() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        mockDriverTrackingService.trackDriverCalled = false
        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)
        
        XCTAssertTrue(mockDriverTrackingService.trackDriverCalled)
    }
    
    /**
      * Given: The trip is confirmed
      * When: The trip state is changed to arrived
      * Then: No driver location listeners should not be active
      */
    func testNonTrackableSuccessiveStateUpdates() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.confirmed)
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.arrived)
        
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
    }

    /**
     * Given: Driver location is updated
     * When: Drive is en route
     * Then: The eta view should show eta with the correct eta
     * And: Analytics event should be fired
     */
    func testDriverLocationUpdatedWhenDriverEnRoute() {
        testObject.monitorTrip(tripId: testTripId)

        let testDriverTrackingInfo = TestUtil.getRandomDriverTrackingInfo()

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(testDriverTrackingInfo)

        XCTAssertEqual("\(testDriverTrackingInfo.originEta)", mockOriginEtaView.showEtaSet)
    }
    
    /**
      * When: Driver location eta to origin is 0
      * Then: The eta view should hide
      */
    func testHidingEtaViewWhenEtaIsZero() {
        testObject.monitorTrip(tripId: testTripId)

        let testDriverTrackingInfo = TestUtil.getRandomDriverTrackingInfo(etaToOrigin: 0)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(testDriverTrackingInfo)
        XCTAssertTrue(mockOriginEtaView.hideEtaCalled)
    }
    
    /**
      * When: TripInfo state is not driver en route
      * Then: Eta should be hidden
      */
    func testHidingEtaViewWhenDriverIsNotEnroute() {
        testObject.monitorTrip(tripId: testTripId)

        let testStates: [TripState] = [.requested,
                                       .noDriversAvailable,
                                       .confirmed,
                                       .arrived,
                                       .passengerOnBoard,
                                       .bookerCancelled,
                                       .driverCancelled,
                                       .karhooCancelled,
                                       .unknown,
                                       .completed]
        
        testStates.forEach { state in

            mockTripService.trackTripStatusCall.triggerPollSuccess(state)

            XCTAssertTrue(mockOriginEtaView.hideEtaCalled)

            mockOriginEtaView.hideEtaCalled = false
        }
    }
    
    /**
      * When: The trip is completed
      * Then: No more listeners should be active
      */
    func testTripCompleted() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)
        
        mockTripService.trackTripStatusCall.triggerPollSuccess(.completed)
        
        XCTAssertFalse(mockTripService.trackTripStatusCall.hasObserver)
    }
}
