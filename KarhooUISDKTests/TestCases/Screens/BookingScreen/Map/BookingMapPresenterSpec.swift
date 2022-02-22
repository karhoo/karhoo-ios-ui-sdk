//
//  BookingMapPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

class BookingMapPresenterSpec: XCTestCase {

    private var testPickupOnlyStrategy: MockPickupOnlyStrategy!
    private var testDestinationSetStrategy: MockBookingMapStrategy!
    private var testBookingDetails: JourneyDetails!
    private var mockBookingStatus: MockBookingStatus!
    private var testObject: KarhooBookingMapPresenter!

    override func setUp() {
        super.setUp()

        testPickupOnlyStrategy = MockPickupOnlyStrategy()
        testDestinationSetStrategy = MockBookingMapStrategy()

        testBookingDetails = TestUtil.getRandomBookingDetails(destinationSet: false,
                                                              dateSet: false)

        mockBookingStatus = MockBookingStatus()
        mockBookingStatus.bookingDetailsToReturn = testBookingDetails

        testObject = KarhooBookingMapPresenter(pickupOnlyStrategy: testPickupOnlyStrategy,
                                               destinationSetStrategy: testDestinationSetStrategy,
                                               bookingStatus: mockBookingStatus)
    }

    /** 
     * When:    Initialized
     * Then:    The correct strategy should be used 
     */
    func testInit() {
        XCTAssertFalse(strategyUsed(testDestinationSetStrategy))
        XCTAssert(strategyUsed(testPickupOnlyStrategy))
    }

    /**
     * When:    Loading the map
     * Then:    All the strategies should reveive that map
     */
    func testLoadMap() {
        testObject.load(map: nil)

        XCTAssert(testPickupOnlyStrategy.loadMapCalled)
        XCTAssert(testDestinationSetStrategy.loadMapCalled)
    }

    /**
     * When:    No destination is set
     * Then:    The pickup only strategy should be used
     */
    func testDestinationNotSet() {
        var details = TestUtil.getRandomBookingDetails()
        testObject.bookingStateChanged(details: details)

        details.destinationLocationDetails = nil
        testDestinationSetStrategy.reset()
        testPickupOnlyStrategy.reset()

        testObject.bookingStateChanged(details: details)

        XCTAssertFalse(isStarted(strategy: testDestinationSetStrategy))
        XCTAssertFalse(strategyUsed(testDestinationSetStrategy))

        XCTAssert(isStarted(strategy: testPickupOnlyStrategy))
        XCTAssert(strategyUsed(testPickupOnlyStrategy))
        XCTAssertEqual(testPickupOnlyStrategy.startBookingDetails?.originLocationDetails?.placeId,
                      details.originLocationDetails?.placeId)
    }

    /**
     * When:    Destination is set
     * Then:    The destination set strategy should be used
     */
    func testDestinationSet() {
        let details = TestUtil.getRandomBookingDetails()
        testObject.bookingStateChanged(details: details)

        XCTAssert(isStarted(strategy: testDestinationSetStrategy))
        XCTAssert(strategyUsed(testDestinationSetStrategy))

        XCTAssertFalse(isStarted(strategy: testPickupOnlyStrategy))
        XCTAssertFalse(strategyUsed(testPickupOnlyStrategy))
    }

    /**
     * Given:   No destination is set
     * When:    Recieving new details with no destination set
     * Then:    The current state should get the new booking details
     */
    func testNoChange() {
        let details = TestUtil.getRandomBookingDetails(destinationSet: false, dateSet: false)
        testObject.bookingStateChanged(details: details)

        XCTAssertFalse(isStarted(strategy: testDestinationSetStrategy))
        XCTAssertFalse(isStarted(strategy: testPickupOnlyStrategy))

        XCTAssertTrue(testPickupOnlyStrategy.detailsChangedCalled)
        XCTAssertEqual(testPickupOnlyStrategy.detailsChangedTo?.originLocationDetails?.placeId,
                       details.originLocationDetails?.placeId)
    }

    // MARK: - Private functions
    private func strategyUsed(_ strategy: MockBookingMapStrategy) -> Bool {
        runFunctionsOnTestObject()

        return strategy.functionsCalled()
    }

    private func runFunctionsOnTestObject() {
        testObject.focusMap()
    }

    private func isStarted(strategy: MockBookingMapStrategy) -> Bool {
        return strategy.startCalled && !strategy.stopCalled
    }
}
