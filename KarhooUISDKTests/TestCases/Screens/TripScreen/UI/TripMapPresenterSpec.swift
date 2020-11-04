//
//  JourneyMapPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation

@testable import KarhooUISDK

class JourneyMapPresenterSpec: XCTestCase {

    private var mockMapView: MockKarhooMapView = MockKarhooMapView()
    private var testObject: JourneyMapPresenter!
    private var mockScreen: MockJourneyView!
    private var mockPickupPoint: TripLocationDetails!
    private var mockDestinationPoint: TripLocationDetails!
    private var mockMapViewActions: MockMapViewActions!

    override func setUp() {
        super.setUp()
        mockPickupPoint = TestUtil.getRandomTripLocationDetails()
        mockScreen = MockJourneyView()
        mockDestinationPoint = TestUtil.getRandomTripLocationDetails()
        mockMapViewActions = MockMapViewActions()
        testObject = KarhooJourneyMapPresenter(originAddress: mockPickupPoint,
                                               destinationAddress: mockDestinationPoint)

        testObject.load(map: mockMapView)
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
        XCTAssertEqual(mockMapView.addedPins[1]?.coordinate.latitude,
                       mockPickupPoint.position.toCLLocation().coordinate.latitude)
        XCTAssertEqual(mockMapView.addedPins[1]?.coordinate.longitude,
                       mockPickupPoint.position.toCLLocation().coordinate.longitude)

        XCTAssertEqual(mockMapView.addedPins[2]?.coordinate.latitude,
                       mockDestinationPoint.position.toCLLocation().coordinate.latitude)
        XCTAssertEqual(mockMapView.addedPins[2]?.coordinate.longitude,
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
        XCTAssert(mockMapView.addedPins[3] == randomLocation)
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
