//
//  KarhooTripsProviderSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class KarhooTripsProviderSpec: XCTestCase {

    private var testObject: KarhooTripsProvider!
    private var mockReachability: MockReachabilityProvider!
    private var mockTripsProviderDelegate: MockTripsProviderDelegate! //swiftlint:disable:this weak_delegate
    private var mockTripService: MockTripService!
    private var mockTimeScheduler: MockTimeScheduler!
    private var mockTripInResponse: TripInfo!
    private var mockTripResponse: [TripInfo] = []
    override func setUp() {
        mockTripInResponse = TestUtil.getRandomTrip()
        mockTripResponse = [mockTripInResponse]
        mockTripsProviderDelegate = MockTripsProviderDelegate()
        mockReachability = MockReachabilityProvider()

        mockTripService = MockTripService()
        mockTimeScheduler = MockTimeScheduler()

        testObject = KarhooTripsProvider(reachability: mockReachability,
                                         tripService: mockTripService,
                                         tripRequestType: .past,
                                         timer: mockTimeScheduler)

        testObject.delegate = mockTripsProviderDelegate
    }

    /**
      * When: Provider should poll
      * And: The timer fires
      * Then: A fetch should be made
      */
    func testPollingSet() {
        testObject = KarhooTripsProvider(reachability: mockReachability,
                                   tripService: mockTripService,
                                   tripRequestType: .past,
                                   shouldPoll: true,
                                   timer: mockTimeScheduler)

        testObject.delegate = mockTripsProviderDelegate
        testObject.start()

        XCTAssertEqual(mockTimeScheduler.schuduleRepeats, true)
        XCTAssert(mockTimeScheduler.events.count != 0)

        mockTimeScheduler.fire()
        mockTripService.searchCall.triggerSuccess(mockTripResponse)

        XCTAssert(mockTripsProviderDelegate.fetchedCalled)
    }

    /**
     * When: Provider should NOT poll
     * Then: timescheduler should not be started
     */
    func testPollingNotSet() {
        testObject.start()
        XCTAssertEqual(mockTimeScheduler.events.count, 0)
    }

    /**
      * Given: initially no reachability
      * Then: Reachability re conects
      * Then: Re-attempt request
      */
    func testReachabilityChange() {
        testObject.start()
        mockReachability.simulateReachable()
        mockReachability.simulatedReachability = false
        mockTripService.searchCall.triggerFailure(TestUtil.getRandomError())

        XCTAssertFalse(mockTripsProviderDelegate.fetchedCalled)

        mockReachability.simulatedReachability = true
        mockReachability.simulateReachable()
        mockTripService.searchCall.triggerSuccess(mockTripResponse)
        XCTAssertTrue(mockTripsProviderDelegate.fetchedCalled)
    }

    /**
      * When: request succeeds
      * Then: correct delegate should call correct method
      */
    func testSuccess() {
        let expectedTripSearch = TripSearch(tripStates: TripStatesGetter().getStatesForTripRequest(type: .past),
                                            paginationRowCount: 10,
                                            paginationOffset: 0)

        testObject.start()
        mockReachability.simulateReachable()
        mockReachability.simulatedReachability = true
        mockTripService.searchCall.triggerSuccess(mockTripResponse)

        XCTAssertEqual(expectedTripSearch.encode(), mockTripService.tripSearchSet?.encode())
        XCTAssertEqual(mockTripsProviderDelegate.tripsFetched[0].tripId, mockTripInResponse.tripId)
        XCTAssertFalse(mockTripsProviderDelegate.tripProviderFailedCalled)
    }

    /**
      * When: request fails
      * Then: correct delegate method should be called
      */
    func testFailure() {
        let failureError = TestUtil.getRandomError()
        testObject.start()
        mockReachability.simulateReachable()
        mockReachability.simulatedReachability = true
        mockTripService.searchCall.triggerFailure(failureError)

        XCTAssertFalse(mockTripsProviderDelegate.fetchedCalled)
        XCTAssertEqual(mockTripsProviderDelegate.theError?.message, failureError.message)
    }
}

class MockReachabilityProvider: ReachabilityProvider {

    var lastAddedListener: ReachabilityListener?
    var addListenerCalled = false
    func add(listener: ReachabilityListener) {
        addListenerCalled = true
        lastAddedListener = listener
    }

    var lastRemovedListener: ReachabilityListener?
    var removeListerCalled = false
    func remove(listener: ReachabilityListener) {
        lastRemovedListener = listener
        removeListerCalled = true
    }

    var simulatedReachability = false
    func isReachable() -> Bool {
        return simulatedReachability
    }

    func simulateReachable() {
        if lastAddedListener !== lastRemovedListener {
            lastAddedListener?.reachabilityChanged(isReachable: simulatedReachability)
        }
    }
}

private class MockTripsProviderDelegate: TripsProviderDelegate {

    var tripsFetched: [TripInfo] = []
    var fetchedCalled = false
    func fetched(trips: [TripInfo]) {
        tripsFetched = trips
        fetchedCalled = true
    }

    var tripProviderFailedCalled = false
    var theError: KarhooError?
    func tripProviderFailed(error: KarhooError?) {
        theError = error
        tripProviderFailedCalled = true
    }
}
