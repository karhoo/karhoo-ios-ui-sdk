//
//  TripMapPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class TripMapPresenterSpec: KarhooTestCase {

    private var mockMapView: MockKarhooMapView = MockKarhooMapView()
    private var testObject: TripMapPresenter!
    private var mockScreen: MockTripView!
    private var mockPickupPoint: TripLocationDetails!
    private var mockDestinationPoint: TripLocationDetails!
    private var mockMapViewActions: MockMapViewActions!

    override func setUp() {
        super.setUp()
        mockPickupPoint = TestUtil.getRandomTripLocationDetails()
        mockScreen = MockTripView()
        mockDestinationPoint = TestUtil.getRandomTripLocationDetails()
        mockMapViewActions = MockMapViewActions()
        testObject = KarhooTripMapPresenter(originAddress: mockPickupPoint,
                                               destinationAddress: mockDestinationPoint)

        testObject.load(map: mockMapView, onLocationPermissionDenied: nil)
        mockMapView.set(actions: mockMapViewActions)
    }

    /**
     * When: The presenter loads
     * Then: The center pin should be removed
     * And: Should zoom to default level (15)
     * And: The minimum and maximum view should be set to 0 and 18
     */
    func testLoad() {
        XCTAssertTrue(mockMapView.centerPinHidden!)
        XCTAssertTrue(mockMapView.zoomedToDefaultLevelCalled)
        XCTAssert(mockMapView.minimumZoomSet == 0 && mockMapView.maximumZoomSet == mockMapView.idealMaximumZoom)
    }

    /**
      * When: The pins are plotted
      * Then: The map view should be set up accordingly
      */
    func testPlottingPins() {
        testObject.plotPins()
        XCTAssertEqual(mockMapView.addedPins[TripPinTags.pickup]?.latitude,
                       mockPickupPoint.position.toCLLocation().coordinate.latitude)
        XCTAssertEqual(mockMapView.addedPins[TripPinTags.pickup]?.longitude,
                       mockPickupPoint.position.toCLLocation().coordinate.longitude)

        XCTAssertEqual(mockMapView.addedPins[TripPinTags.destination]?.latitude,
                       mockDestinationPoint.position.toCLLocation().coordinate.latitude)
        XCTAssertEqual(mockMapView.addedPins[TripPinTags.destination]?.longitude,
                       mockDestinationPoint.position.toCLLocation().coordinate.longitude)
    }

    /**
     * When: The driver location is updated
     * Then: The map view should be set up accordingly
     */
    func testPlottingDriver() {
        testObject.plotPins()
        let randomLocation = TestUtil.getRandomLocation()
        testObject.updateDriver(location: randomLocation)
        XCTAssert(mockMapView.addedPins[TripPinTags.driverLocation] == randomLocation.coordinate)
    }

    /**
      * When: The user moves the map
      * Then: The delegate should be notified
      */
    func testUserMovesMap() {
        mockMapViewActions.mapGestureDetected()
        XCTAssertTrue(mockMapViewActions.gestureDetectedCalled)
    }
}
