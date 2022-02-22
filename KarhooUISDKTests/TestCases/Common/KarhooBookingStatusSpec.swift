//
//  KarhooBookingStatusSpec.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooBookingStatusSpec: XCTestCase {

    private var testBroadcaster: TestBroadcaster!
    private var testObserver: MockBookingDetailsObserver!
    private var testObject: KarhooBookingStatus!
    private var mockAddressService = MockAddressService()

    override func setUp() {
        super.setUp()

        testObserver = MockBookingDetailsObserver()
        testBroadcaster = TestBroadcaster()
        testObject = KarhooBookingStatus(broadcaster: testBroadcaster, addressService: mockAddressService)

        testObject.add(observer: testObserver)
    }

    /**
     *  When:   Adding an observer
     *  Then:   The observer should be added
     */
    func testAddObserver() {
        XCTAssert(testBroadcaster.lastListenerAdded === testObserver)
    }

    /**
     *  When:   Removing the observer
     *  Then:   It should no longer receive updates
     */
    func testRemoveObserver() {
        testObject.remove(observer: testObserver)

        XCTAssert(testBroadcaster.lastListenerRemoved === testObserver)
    }

    /**
     *  When:   Setting a pickup location
     *  Then:   The pickup location should be set
     *   And:   The observers should be notified
     */
    func testSettingPickup() {
        let locationOne = TestUtil.getRandomLocationInfo()
        let locationTwo = TestUtil.getRandomLocationInfo()

        testObject.set(pickup: locationOne)
        assert(bookingDetails: testObserver.lastBookingState,
                originLocationDetails: locationOne,
                destination: nil,
                date: nil)

        testObject.set(pickup: locationTwo)
        assert(bookingDetails: testObserver.lastBookingState,
               originLocationDetails: locationTwo,
               destination: nil, date: nil)
    }

    /**
     *  When:   Clearing the pickup address
     *  Then:   The booking should be cleared
     *   And:   The observers should be notified
     */
    func testClearingPickup() {
        testObject.set(pickup: TestUtil.getRandomLocationInfo())
        testObject.set(pickup: nil)

        XCTAssertTrue(testObserver.bookingStateChangedCalled)
    }

    /**
     *  Given:  A pickup address has been set
     *  When:   Setting a destination address
     *  Then:   The observers should be notified
     *   And:   The destination should be set
     */
    func testSettingDestination() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)
        let destination = TestUtil.getRandomLocationInfo()
        testObject.set(destination: destination)

        assert(bookingDetails: testObserver.lastBookingState,
               originLocationDetails: pickup,
               destination: destination,
               date: nil)
    }

    /**
     *  Given:  No pickup address
     *  When:   Setting a destination address
     *  Then:   Nothing should happen
     */
    func testSettingDestinationNoPickup() {
        let destination = TestUtil.getRandomLocationInfo()
        testObject.set(destination: destination)

        XCTAssertNil(testObserver.lastBookingState)
        XCTAssertFalse(testObserver.bookingStateChangedCalled)
    }

    /**
     *  Given:  A prebook time has been set
     *  When:   Clearing the destination address
     *  Then:   The booking should not contain any destination
     *   And:   The booking should not contain any prebook time
     *   And:   The observers should be notified
     */
    func testClearingDestination() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)
        let destination = TestUtil.getRandomLocationInfo()
        testObject.set(destination: destination)

        testObject.set(destination: nil)

        assert(bookingDetails: testObserver.lastBookingState,
               originLocationDetails: pickup, destination: nil, date: nil)
    }

    /**
     *  Given:  A pickup location is set
     *  When:   Setting a prebook time
     *  Then:   The prebook time should be set
     */
    func testSetPrebookTime() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)

        let prebookTime = Date()
        testObject.set(prebookDate: prebookTime)

        assert(bookingDetails: testObserver.lastBookingState,
               originLocationDetails: pickup,
               destination: nil,
               date: prebookTime)
    }

    /**
     *  Given:  A pickup location is set
     *  When:   Clearing the prebook time
     *  Then:   The prebook time should be cleared
     */
    func testClearPrebookTime() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)

        let prebookTime = Date()
        testObject.set(prebookDate: prebookTime)
        testObject.set(prebookDate: nil)

        assert(bookingDetails: testObserver.lastBookingState,
               originLocationDetails: pickup,
               destination: nil,
               date: nil)
    }

    /**
     *  Given:  No pickup location has been set
     *  When:   Setting a prebook time
     *  Then:   Nothing should happen
     */
    func testSetPrebookTimeNoPickup() {

        let prebookTime = Date()
        testObject.set(prebookDate: prebookTime)

        XCTAssertNil(testObserver.lastBookingState)
        XCTAssertFalse(testObserver.bookingStateChangedCalled)
    }

    /**
     *  When:   Getting the booking details
     *  Then:   The current booking details should be returned
     */
    func testGetBookingDetails() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)
        let destinationAddress = TestUtil.getRandomLocationInfo()
        testObject.set(destination: destinationAddress)
        let date = Date()
        testObject.set(prebookDate: date)
        let bookingDetails = testObject.getBookingDetails()

        assert(bookingDetails: bookingDetails,
               originLocationDetails: pickup,
               destination: destinationAddress,
               date: date)
    }

    /**
      *  When:   Resetting the booking details
      *  Then:   The current booking details should be nil
      *   And:   observers should be notified
      */
    func testResettingBookingDetails() {
        let pickup = TestUtil.getRandomLocationInfo()
        testObject.set(pickup: pickup)
        let destinationAddress = TestUtil.getRandomLocationInfo()
        testObject.set(destination: destinationAddress)
        let date = Date()
        testObject.set(prebookDate: date)

        testObject.reset()

        XCTAssertNil(testObject.getBookingDetails())
        XCTAssertNil(testObserver.lastBookingState)
    }

    /**
     *  When:   Setting a JourneyInfo
     *  Then:   The correct data should be set AND the observers should be notified
     */
    func testSetJourney() {
        let journeyInfo: JourneyInfo = TestUtil.getRandomJourneyInfo()
        testObject.setJourneyInfo(journeyInfo: journeyInfo)

        let pickup = TestUtil.getRandomLocationInfo()
        let destination = TestUtil.getRandomLocationInfo()
        mockAddressService.reverseGeocodeCall.triggerSuccess(pickup)
        mockAddressService.reverseGeocodeCall.triggerSuccess(destination)

        assert(bookingDetails: testObject.getBookingDetails(),
               originLocationDetails: pickup,
               destination: destination,
               date: journeyInfo.date)
        XCTAssertTrue(testObserver.bookingStateChangedCalled)

    }

    private func assert(journeyDetails: JourneyDetails?,
                        originLocationDetails: LocationInfo?,
                        destination: LocationInfo?,
                        date: Date?) {
        XCTAssertEqual(originLocationDetails?.placeId, journeyDetails?.originLocationDetails?.placeId)
        XCTAssertEqual(destination?.placeId, journeyDetails?.destinationLocationDetails?.placeId)
        XCTAssertEqual(date, journeyDetails?.scheduledDate)
    }
}
