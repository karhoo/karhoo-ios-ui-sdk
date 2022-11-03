//
//  KarhooDestinationEtaPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class KarhooDestinationEtaSpec: KarhooTestCase {
    
    private let testTripId: String = "some_tripid"
    private var mockTripService: MockTripService!
    private var mockDriverTrackingService: MockDriverTrackingService!
    private var testObject: KarhooDestinationEtaPresenter!
    private var mockDestinationEtaView: MockDestinationEtaView!
    private var testTimeFetcher: MockTimeFetcher!
    private lazy var testTrip = TestUtil.getRandomTrip(tripId: testTripId)

    override func setUp() {
        super.setUp()
        mockDestinationEtaView = MockDestinationEtaView()
        mockTripService = MockTripService()
        testTimeFetcher = MockTimeFetcher()
        mockDriverTrackingService = MockDriverTrackingService()
        testObject = KarhooDestinationEtaPresenter(tripService: mockTripService,
                                                                    driverTrackingService: mockDriverTrackingService,
                                                                    timeFetcher: testTimeFetcher,
                                                                    etaView: mockDestinationEtaView)
        
    }
    
    /**
     * When: Start monitoring eta is called
     * Then: The trip service should have an active listener for trip status
     * And: The injected trip id should be the trip to monitor
     * And: Should not call track driver
     */
    func testStartMonitoringEta() {
        testObject.monitorTrip(tripId: testTripId)

        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockDestinationEtaView.hideEtaCalled)
    }
    
    /**
     * Given: Stop monitoring eta is called
     * When: Passenger on board
     * Then: The trip service should have no active listeners for trip status
     * And: Driver tracking observer should be disposed
     */
    func testStopMonitoring() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        testObject.stopMonitoringTrip()
        
        XCTAssertFalse(mockTripService.trackTripStatusCall.hasObserver)
    }
    
    /**
     * Given: Passenger is on board
     * When: TripInfo status is updated and is still Passenger on board
     * Then: Only one driver location listener should be present in the trip service
     */
    func testSuccessivePassengerOnBoardStatusUpdates() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)

        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
    }
    
    /**
     * When: Driver is en route
     * Then: TripInfo Service should not be listening for driver location updates
     */
    func testDriverEnRouteDoesntListenForDriverLocation() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.driverEnRoute)

        XCTAssertEqual(testTripId, mockTripService.trackTripStatusIdSet)
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
    }
    
    /**
     * Given: TripInfo is arrived
     * When: trip status is updated to passenger on board
     * Then: A driver location listener should be added
     * And: TripInfo status should only have the one listener
     */
    func testNonTrackingStateToPassengerOnBoard() {
        testObject.monitorTrip(tripId: testTripId)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.arrived)
        
        XCTAssertFalse(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        
        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)
    }
    
    /**
     * Given: Passenger is on board
     * When: For whatever godly reason trip state changes to arrived (state reverses)
     * And:  then state changes back to passenger on board
     * Then: Only one driver location listener should be present
     */
    func testPassengerOnBoardGlitchEdgeCase() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        mockTripService.trackTripStatusCall.triggerPollSuccess(.arrived)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)
        
        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
    }
    
    /**
     * Given: Driver location is updated
     * When: Passenger is on board
     * Then: The eta view should show eta with the correct eta
     */
    func testDriverLocationUpdatedWhenPassengerOnBoard() {
        testObject.monitorTrip(tripId: testTripId)
        
        let testDriverTrackingInfo = TestUtil.getRandomDriverTrackingInfo(etaToDestination: 11)
        testTimeFetcher.timeToDeliver = TestUtil.getTestDate()

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)

        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(testDriverTrackingInfo)

        XCTAssertEqual(testTripId, mockTripService.trackTripStatusIdSet)
        XCTAssertEqual("16:31", mockDestinationEtaView.showEtaSet)
    }
    
    /**
     * When: Driver location eta to destination is 0
     * Then: The eta view should hide
     */
    func testHidingEtaViewWhenEtaIsZero() {
        testObject.monitorTrip(tripId: testTripId)
        
        let testDriverTrackingInfo = TestUtil.getRandomDriverTrackingInfo(etaToDestination: 0)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)

        mockDriverTrackingService.trackDriverCall.triggerPollSuccess(testDriverTrackingInfo)
        XCTAssertTrue(mockDestinationEtaView.hideEtaCalled)
    }
    
    /**
     * When: TripInfo state is not passenger on board
     * Then: Eta should be hidden
     */
    func testHidingEtaViewWhenPassengerIsNotOnBoard() {
        testObject.monitorTrip(tripId: testTripId)
        
        let testStates: [TripState] = [.requested,
                                       .noDriversAvailable,
                                       .confirmed,
                                       .driverEnRoute,
                                       .arrived,
                                       .bookerCancelled,
                                       .driverCancelled,
                                       .karhooCancelled,
                                       .unknown,
                                       .completed]
        
        testStates.forEach { (state) in
            mockTripService.trackTripStatusCall.triggerPollSuccess(state)
            
            XCTAssertTrue(mockDestinationEtaView.hideEtaCalled)
            
            mockDestinationEtaView.hideEtaCalled = false
        }
    }
    
    /**
     * Given: Passenger is on board
     * When: The trip is completed
     * Then: No more listeners should be active
     */
    func testTripCompleted() {
        testObject.monitorTrip(tripId: testTripId)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.passengerOnBoard)

        XCTAssertTrue(mockDriverTrackingService.trackDriverCall.hasObserver)
        XCTAssertTrue(mockTripService.trackTripStatusCall.hasObserver)

        mockTripService.trackTripStatusCall.triggerPollSuccess(.completed)
        
        XCTAssertFalse(mockTripService.trackTripStatusCall.hasObserver)
    }
}
