//
//  BookingMapPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK
import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

class BookingMapPresenterSpec: KarhooTestCase {

    private var testEmptyBookingStrategy: MockBookingMapStrategy!
    private var testPickupOnlyStrategy: MockPickupOnlyStrategy!
    private var testDestinationSetStrategy: MockBookingMapStrategy!
    private var testJourneyDetails: JourneyDetails!
    private var mockJourneyDetailsManager: MockJourneyDetailsManager!
    private var mockLocationPermissionProvider: MockLocationPermissionProvider!
    private var testObject: KarhooBookingMapPresenter!

    private var onLocationPermissionDeniedCalled: Bool!

    override func setUp() {
        super.setUp()

        testEmptyBookingStrategy = MockBookingMapStrategy()
        testPickupOnlyStrategy = MockPickupOnlyStrategy()
        testDestinationSetStrategy = MockBookingMapStrategy()

        testJourneyDetails = TestUtil.getRandomJourneyDetails(destinationSet: false,
                                                              dateSet: false)

        mockJourneyDetailsManager = MockJourneyDetailsManager()
        mockJourneyDetailsManager.journeyDetailsToReturn = testJourneyDetails
        
        mockLocationPermissionProvider = MockLocationPermissionProvider()
        mockLocationPermissionProvider.isLocationPermissionGrantedReturn = true
        onLocationPermissionDeniedCalled = false

        testObject = KarhooBookingMapPresenter(
            pickupOnlyStrategy: testPickupOnlyStrategy,
            destinationSetStrategy: testDestinationSetStrategy,
            journeyDetailsManager: mockJourneyDetailsManager,
            emptyBookingStrategy: testEmptyBookingStrategy,
            locationPermissionProvider: mockLocationPermissionProvider,
            onLocationPermissionDenied: {
                self.onLocationPermissionDeniedCalled = true
            }
        )
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
        testObject.load(map: nil, onLocationPermissionDenied: nil)

        XCTAssert(testPickupOnlyStrategy.loadMapCalled)
        XCTAssert(testDestinationSetStrategy.loadMapCalled)
    }

    /**
     * When:    No destination is set
     * Then:    The pickup only strategy should be used
     */
    func testDestinationNotSet() {
        var details = TestUtil.getRandomJourneyDetails()
        testObject.journeyDetailsChanged(details: details)

        details.destinationLocationDetails = nil
        testDestinationSetStrategy.reset()
        testPickupOnlyStrategy.reset()

        testObject.journeyDetailsChanged(details: details)

        XCTAssertFalse(isStarted(strategy: testDestinationSetStrategy))
        XCTAssertFalse(strategyUsed(testDestinationSetStrategy))

        XCTAssert(isStarted(strategy: testPickupOnlyStrategy))
        XCTAssert(strategyUsed(testPickupOnlyStrategy))
        XCTAssertEqual(testPickupOnlyStrategy.startJourneyDetails?.originLocationDetails?.placeId,
                      details.originLocationDetails?.placeId)
    }

    /**
     * When:    Destination is set
     * Then:    The destination set strategy should be used
     */
    func testDestinationSet() {
        let details = TestUtil.getRandomJourneyDetails()
        testObject.journeyDetailsChanged(details: details)

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
        let details = TestUtil.getRandomJourneyDetails(destinationSet: false, dateSet: false)
        testObject.journeyDetailsChanged(details: details)

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
