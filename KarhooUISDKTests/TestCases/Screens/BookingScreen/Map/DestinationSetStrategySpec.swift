//
//  DestinationSetStrategySpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import CoreLocation
import KarhooSDK
import KarhooUISDK

@testable import KarhooUISDK

class DestinationSetStrategySpec: XCTestCase {

    var mockMap: MockKarhooMapView!
    var testObject: DestinationSetStrategy!

    private let pickupPinTag = 1321
    private let destinationPinTag = 12

    override func setUp() {
        super.setUp()

        mockMap = MockKarhooMapView()
        testObject = DestinationSetStrategy(pickupPinTag: pickupPinTag,
                                            destinationPinTag: destinationPinTag)

        testObject.load(map: mockMap)
    }

    /**
     * When:    Started
     * Then:    The route for the current booking should be fetched
     *  And:    Pickup pin should be set
     *  And:    Destination pin should be set
     */
    func testStart() {
        let details = TestUtil.getRandomBookingDetails()
        testObject.start(bookingDetails: details)

        XCTAssert(mockMap.locationsToZoomTo?.count == 2)
        
        assertLocationsToZoomOn(map: mockMap, details: details)

        XCTAssertEqual(mockMap.addedPins[pickupPinTag]?.coordinate,
                       details.originLocationDetails!.position.toCLLocation().coordinate)
        XCTAssertEqual(mockMap.addedPins[destinationPinTag]?.coordinate,
                       details.destinationLocationDetails!.position.toCLLocation().coordinate)
    }

    private func assertLocationsToZoomOn(map: MockKarhooMapView, details: BookingDetails) {
        let containsDestination = map.locationsToZoomTo?.contains {
            $0.coordinate == details.destinationLocationDetails!.position.toCLLocation().coordinate
        }
        
        let containsPickup = map.locationsToZoomTo?.contains {
            $0.coordinate == details.originLocationDetails!.position.toCLLocation().coordinate
        }
        
        XCTAssertTrue(containsDestination!)
        XCTAssertTrue(containsPickup!)
    }
    /**
     * When:    Stopped
     * Then:    Nothing should happen
     */
    func testStop() {
        testObject.stop()

        XCTAssert(mockMap.removedPins.count == 2)
        XCTAssert(mockMap.removedPins.contains(pickupPinTag))
        XCTAssert(mockMap.removedPins.contains(destinationPinTag))
        XCTAssertFalse(mockMap.addJourneyLineCalled)
    }

    /**
     * Given:   Destination and pickup addresses not set
     * When:    Booking details are set
     * Then:    The map should be updated
     */
    func testBookingDetailsChangesFromNotSet() {

        let details = TestUtil.getRandomBookingDetails()

        testObject.changed(bookingDetails: details)

        XCTAssert(mockMap.locationsToZoomTo?.count == 2)
        
        assertLocationsToZoomOn(map: mockMap, details: details)
        
        XCTAssert(mockMap.removedPins.contains(pickupPinTag))

        XCTAssertEqual(mockMap.addedPins[pickupPinTag]?.coordinate,
                       details.originLocationDetails!.position.toCLLocation().coordinate)
        
        XCTAssertEqual(mockMap.addedPins[destinationPinTag]?.coordinate,
                       details.destinationLocationDetails!.position.toCLLocation().coordinate)

        XCTAssertTrue(mockMap.addJourneyLineCalled)
    }

    /**
     * NOTE: This test use to utilise mapView.movePin. This caused a threading issue in iOS 11
     * So the behaviour for moving the destination pin is now to remove the existing tag and add a new one
     * Given:   Destination and pickup addresses set
     * When:    Booking details are changed
     * Then:    The map should be updated
     */
    func testBookingDetailsChangesFromSet() {

        var details = TestUtil.getRandomBookingDetails()
        testObject.changed(bookingDetails: details)

        mockMap = MockKarhooMapView() // Start with empty
        testObject.load(map: mockMap)

        details = TestUtil.getRandomBookingDetails()
        testObject.changed(bookingDetails: details)

        XCTAssert(mockMap.locationsToZoomTo?.count == 2)
        
        assertLocationsToZoomOn(map: mockMap, details: details)
        
        XCTAssert(mockMap.removedPins.contains(pickupPinTag))
        XCTAssertEqual(mockMap.addedPins[pickupPinTag]?.coordinate,
                       details.originLocationDetails!.position.toCLLocation().coordinate)
        
        XCTAssert(mockMap.removedPins.contains(destinationPinTag))
        
        XCTAssertEqual(mockMap.addedPins[destinationPinTag]?.coordinate,
                       details.destinationLocationDetails!.position.toCLLocation().coordinate)

        XCTAssertTrue(mockMap.addJourneyLineCalled)
    }

    /**
     * When:    Booking details changes to nil
     * Then:    The map should be updated
     */
    func testNilBookingDetails() {

        testObject.changed(bookingDetails: nil)

        XCTAssertNil(mockMap.locationsToZoomTo)
        XCTAssert(mockMap.addedPins.count == 0)
    }

    /**
     * Given:   Destination not set
     * When:    Booking details changes
     * Then:    The map should be updated
     */
    func testBookingDetailsChangesNoDestination() {

        let details = TestUtil.getRandomBookingDetails(destinationSet: false)

        testObject.changed(bookingDetails: details)

        XCTAssertNil(mockMap.locationsToZoomTo)
        XCTAssert(mockMap.addedPins.count == 0)
    }

    /**
     * Given:   Neither destination nor pickup have been changed
     * When:    Booking details changes (scheduled time)
     * Then:    Nothing should happen
     */
    func testUnimportnatBookingDetailsChanges() {
        var details = TestUtil.getRandomBookingDetails()
        testObject.changed(bookingDetails: details)

        mockMap.locationsToZoomTo = nil
        mockMap.addedPins = [:]

        details.scheduledDate =  Date()
        testObject.changed(bookingDetails: details)

        XCTAssertNil(mockMap.locationsToZoomTo)
        XCTAssert(mockMap.addedPins.count == 0)
    }

    /**
     * Given:   Pickup and destination set
     * When:    "Locate me" is pressed
     * Then:    The map should zoom to the current trip
     */
    func testLocateUser() {
        let details = TestUtil.getRandomBookingDetails()
        testObject.changed(bookingDetails: details)

        mockMap.locationsToZoomTo = nil

        testObject.focusMap()

        XCTAssert(mockMap.locationsToZoomTo?.count == 2)
        
        assertLocationsToZoomOn(map: mockMap, details: details)
    }

    /**
     * Given:   Pickup not set
     * When:    "Locate me" is pressed
     * Then:    Nothing should happen
     */
    func testLocateUserNoPickup() {
        testObject.focusMap()

        XCTAssertNil(mockMap.locationsToZoomTo)
    }
}
