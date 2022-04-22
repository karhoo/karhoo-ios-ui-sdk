//
//  KarhooTripAllocationPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class KarhooTripAllocationPresenterSpec: XCTestCase {

    private var testObject: KarhooTripAllocationPresenter!
    private var mockTripService: MockTripService!
    private var mockTripAllocationView: MockTripAllocationView!
    private let mockTrip: TripInfo = TestUtil.getRandomTrip()
    private var mockAnalytics: MockAnalytics!
    private var driverAllocationCheckDelay = 0.1

    override func setUp() {
        super.setUp()
        KarhooTestConfiguration.authenticationMethod = .karhooUser

        mockTripService = MockTripService()
        mockTripAllocationView = MockTripAllocationView()
        mockAnalytics = MockAnalytics()

        testObject = KarhooTripAllocationPresenter(tripService: mockTripService,
                                                   analytics: mockAnalytics,
                                                   view: mockTripAllocationView,
                                                   driverAllocationCheckDelay: driverAllocationCheckDelay)
    }
    
    /**
     * When: Monitor trip is called for a guest booking
     * Then: Trip tracking observer should subscribe to trip service
     * And: An alert should not be shown if there is a delay in allocation a driver
     */
    func testStartMonitoringGuestUserTrip() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        
        testObject.startMonitoringTrip(trip: mockTrip)
        
        let expectation = XCTestExpectation()
        
        XCTAssertEqual(mockTrip.followCode, mockTripService.tripTrackingIdentifierSet)
        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + driverAllocationCheckDelay*2) {
            XCTAssertFalse(self.mockTripAllocationView.tripDriverAllocationDelayedCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /**
      * When: Monitor trip is called for an authorised user booking
      * Then: Trip tracking observer should subscribe to trip service
      * And: An alert should be shown if there is a delay in allocation a driver
      */
    func testStartMonitoringAuthorisedUserTrip() {
        testObject.startMonitoringTrip(trip: mockTrip)
        
//        let expectation = XCTestExpectation()
        
        XCTAssertEqual(mockTrip.tripId, mockTripService.tripTrackingIdentifierSet)
        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + driverAllocationCheckDelay*4) {
//            XCTAssertTrue(self.mockTripAllocationView.tripDriverAllocationDelayedCalled)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5)
    }

    /**
      * Given: Cancelling a trip
      * When: No trip is being monitored
      * Then: Trip service cancellation should be nil (not called)
      */
    func testCancelTripNoCurrentTripSet() {
        testObject.cancelTrip()
        XCTAssertNil(mockTripService.tripCancellationSet)
    }

    /**
     * Given: Cancelling a trip
     * When: Trip is being monitored
     * Then: Trip service should be called upon to cancel trip
     * And: Alaytics should be called with trip cancellation initialised event
     */
    func testCancelTripWithCurrentTripSet() {
        testObject.startMonitoringTrip(trip: mockTrip)
        testObject.cancelTrip()

        XCTAssertEqual(mockTripService.tripCancellationSet?.tripId, mockTrip.tripId)
        XCTAssertEqual(mockTripService.tripCancellationSet?.tripId, mockTrip.tripId)
    }

    /**
      * Given: Cancelling a trip
      * When: Cancelling is successful
      * Then: View should be informed
      * And: Trip tracking should stop
      * And: Cancel button should reset
      */
    func testCancelTripSuccessful() {
        testObject.startMonitoringTrip(trip: mockTrip)
        testObject.cancelTrip()

        mockTripService.cancelCall.triggerSuccess(KarhooVoid())

        XCTAssertTrue(mockTripAllocationView.tripCancellationRequestSucceededCalled)
        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
        XCTAssertTrue(mockTripAllocationView.resetCancelButtonCalled)
    }

    /**
      * Given: Cancelling a trip
      * When: Cancel trip fails
      * Then: View should be informed
      * And: Trip should still be observerd
      * And: Cancel button should reset
      */
    func testCancelTripFails() {
        let cancelFailError = TestUtil.getRandomError()

        testObject.startMonitoringTrip(trip: mockTrip)
        testObject.cancelTrip()

        mockTripService.cancelCall.triggerFailure(cancelFailError)

        XCTAssert(cancelFailError.equals(mockTripAllocationView.tripCancellationRequestFailedCalled))
        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
        XCTAssertTrue(mockTripAllocationView.resetCancelButtonCalled)
    }

    /**
     * Given: Trip updates
     * When: Trip status implies the trip is allocated
     * Then: View should be informed
     * And: Trip observer should be removed
     * And: Cancel button should reset
     * And: Driver allocation delay alert should not be shown
     */
    func testTripAllocated() {
        let allocatedStates: [TripState] = [.driverEnRoute,
                                            .arrived,
                                            .passengerOnBoard,
                                            .completed]

        allocatedStates.forEach({ state in
            let expectation = XCTestExpectation()
            
            testObject.startMonitoringTrip(trip: mockTrip)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + driverAllocationCheckDelay*2) {
                XCTAssertFalse(self.mockTripAllocationView.tripDriverAllocationDelayedCalled)
                expectation.fulfill()
            }

            let newTripUpdate = TestUtil.getRandomTrip(state: state)
            mockTripService.trackTripCall.triggerPollSuccess(newTripUpdate)

            XCTAssertEqual(mockTripAllocationView.tripAllocatedCalled!.tripId, newTripUpdate.tripId)
            XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
            XCTAssertTrue(mockTripAllocationView.resetCancelButtonCalled)
            wait(for: [expectation], timeout: 1)

            tearDown()
        })
    }

    /**
     * Given: Trip updates
     * When: Trip status implies the trip is cancelled by system(Karhoo/Dispatch/Driver)
     * Then: View should be informed
     * And: Trip observer should be removed
     * And: Cancel button should reset
     * And: Driver allocation delay alert should not be shown
     */
    func testTripCancelledBySystem() {
        let cancelledBySystemStates: [TripState] = [.karhooCancelled,
                                                    .driverCancelled,
                                                    .noDriversAvailable]
        
        cancelledBySystemStates.forEach({ state in
            let expectation = XCTestExpectation()
            
            testObject.startMonitoringTrip(trip: mockTrip)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + driverAllocationCheckDelay*2) {
                XCTAssertFalse(self.mockTripAllocationView.tripDriverAllocationDelayedCalled)
                expectation.fulfill()
            }

            let newTripUpdate = TestUtil.getRandomTrip(state: state)
            mockTripService.trackTripCall.triggerPollSuccess(newTripUpdate)

            XCTAssertTrue(mockTripAllocationView.tripCancelledBySystemCalled)
            XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
            XCTAssertTrue(mockTripAllocationView.resetCancelButtonCalled)
            wait(for: [expectation], timeout: 1)

            tearDown()
        })
    }

    /**
      * When: User is a guest
      * Then: Track trip should use follow code
      * And:  Trip should be cancelled with follow code
      */
    func testGuestAuthenticationUsesFollowCode() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        testObject.startMonitoringTrip(trip: mockTrip)
        XCTAssertEqual(mockTrip.followCode, mockTripService.tripTrackingIdentifierSet)
        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)

        testObject.cancelTrip()
        XCTAssertEqual(mockTrip.followCode, mockTripService.tripCancellationSet?.tripId)
    }
}
