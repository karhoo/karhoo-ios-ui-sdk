//
//  PickupOnlyStrategySpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

class PickupOnlyStrategySpec: XCTestCase {

    private var mockMapView: MockKarhooMapView!
    private var mockUserLocationProvider: MockUserLocationProvider!
    private var mockAddressService: MockAddressService!
    private var mockPickupStrategyDelegate: MockPickupOnlyStrategyDelegate! // swiftlint:disable:this weak_delegate
    private var mockKarhooTime: MockTimeScheduler!
    private var testObject: PickupOnlyStrategy!
    private let mockJourneyDetailsManager = MockJourneyDetailsManager()
    private let mockLocationService = MockLocationService()

    override func setUp() {
        super.setUp()
        mockJourneyDetailsManager.journeyDetailsToReturn = TestUtil.getRandomJourneyDetails()
        mockMapView = MockKarhooMapView()
        mockUserLocationProvider = MockUserLocationProvider()
        mockAddressService = MockAddressService()
        mockKarhooTime = MockTimeScheduler()
        mockPickupStrategyDelegate = MockPickupOnlyStrategyDelegate()
        mockLocationService.setLocationAccessEnabled = true
        testObject = PickupOnlyStrategy(userLocationProvider: mockUserLocationProvider,
                                        addressService: mockAddressService,
                                        timer: mockKarhooTime,
                                        journeyDetailsManager: mockJourneyDetailsManager,
                                        locationService: mockLocationService)
        testObject.load(map: mockMapView)
        testObject.set(delegate: mockPickupStrategyDelegate)
    }

    override func tearDown() {
        super.tearDown()
        KarhooTestConfiguration.authenticationMethod = .karhooUser
    }

    /**
     * Given:   A pickup location set
     * When:    Started
     * Then:    should focus on pick up pin
     */
    func testStartWithPickup() {
        let pickup = TestUtil.getRandomLocationInfo()
        let details = JourneyDetails(originLocationDetails: pickup)
        testObject.start(journeyDetails: details)

        XCTAssertFalse(mockMapView.focusButtonHiddenSet!)
        XCTAssertFalse(mockMapView.centerPinHidden!)
        XCTAssertEqual(mockMapView.locationToCenterOn?.coordinate, pickup.position.toCLLocation().coordinate)
     }
    
    /**
     * Given:   A pickup location set
     * When:    Started
     * Then:    should focus on pick up pin if the location permissions are granted
     */
    func testStartWithPickupAndPermissions() {
        mockLocationService.setLocationAccessEnabled = false
        
        let pickup = TestUtil.getRandomLocationInfo()
        let details = JourneyDetails(originLocationDetails: pickup)
        testObject.start(journeyDetails: details)
        XCTAssertFalse(mockMapView.focusButtonHiddenSet!)
        XCTAssertTrue(mockMapView.centerPinHidden!)
        XCTAssertEqual(mockMapView.locationToCenterOn?.coordinate, pickup.position.toCLLocation().coordinate)
     }


    /**
     * Given:   A pickup location set
     * When:    Started
     * Then:    remove pin should be called
     */
    func testStop() {
        testObject.stop()

        XCTAssertTrue(mockMapView.centerPinHidden!)
    }

    /**
     * Given:   The users location has been found
     * When:    "Locate me" is pressed
     * Then:    The map should zoom to the user location
     *  And:    The address for that location should be fetched
     */
    func testLocateMeWithLocation() {
        mockUserLocationProvider.lastKnownLocation = CLLocation()

        testObject.focusMap()

        XCTAssert(mockMapView.locationToCenterOnZoom == mockUserLocationProvider.lastKnownLocation)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet,
                       mockUserLocationProvider.lastKnownLocation?.toPosition())
    }

    /**
     * Given:   The user location has not been found
     * When:    "Locate me" is pressed
     * Then:    Nothing should happen
     */
    func testLocateMeWithoutLocation() {
        testObject.focusMap()

        XCTAssertNil(mockMapView.locationsToZoomTo)
        XCTAssertNil(mockAddressService.reverseGeocodePositionSet)
    }

    /**
     * When:    The map has been panned
     * And:     The SDK is not in guest mode
     * Then:    The address for the map center should be fetched
     */
    func testPanMap() {
        let center = CLLocation()
        testObject.userStoppedMovingTheMap(center: center)
        
        XCTAssert(mockKarhooTime.events.count != 0)
        mockKarhooTime.fire()
        XCTAssertNil(mockMapView.locationsToZoomTo)
        XCTAssertEqual(center.toPosition(), mockAddressService.reverseGeocodePositionSet)
    }

    /**
     * When:    The pickup address didnt change but some other detail did
     * Then:    The map should not move
     */
    func testDetailsChangesSamePickup() {
        let pickupLocation = Position(latitude: 10, longitude: 11)
        let pickup = TestUtil.getRandomLocationInfo(position: pickupLocation)
        let details = JourneyDetails(originLocationDetails: pickup)

        testObject.changed(journeyDetails: details)

        mockMapView.locationsToZoomTo = nil
        testObject.changed(journeyDetails: details)

        XCTAssertNil(mockMapView.locationsToZoomTo)
    }

    /**
     * When:    The address is returned for an expected location
     * Then:    The delegate should be notified
     *  And:    The map should zoom to the exact coordinate
     */
    func testReverseGeocodeComplete() {
        let location = CLLocation(latitude: 0.23, longitude: 0.12)
        testObject.userStoppedMovingTheMap(center: location)
        
        mockKarhooTime.fire()

        let pickup = TestUtil.getRandomLocationInfo()
        mockAddressService.reverseGeocodeCall.triggerSuccess(pickup)
        XCTAssertNil(mockMapView.locationsToZoomTo)
        XCTAssert(mockPickupStrategyDelegate.locationDetailsSetFromMap?.placeId == pickup.placeId)
    }

    /**
     * When:    No address is returned for an expected location
     * Then:    The delegate should be notified of the failure
     */
    func testReverseGeocodeFailedToProduceAddress() {
        let location = CLLocation(latitude: 0.23, longitude: 0.12)
        testObject.userStoppedMovingTheMap(center: location)
        
        mockKarhooTime.fire()

        let error = TestUtil.getRandomError()
        mockAddressService.reverseGeocodeCall.triggerFailure(error)

        XCTAssert(mockPickupStrategyDelegate.pickupFailedToSetCalled)
        XCTAssertEqual(error.message, mockPickupStrategyDelegate.pickupFailedError?.message)
    }

    /**
     * When:    The address lookup for a specific location fails
     * Then:    The delegate should be notified of the specific error
     */
    func testReverseGeocodeError() {
        let location = CLLocation(latitude: 0.23, longitude: 0.12)
        testObject.userStoppedMovingTheMap(center: location)
        
        mockKarhooTime.fire()

        let error = TestUtil.getRandomError()
        mockAddressService.reverseGeocodeCall.triggerFailure(error)

        XCTAssert(mockPickupStrategyDelegate.pickupFailedToSetCalled)
        XCTAssertEqual(error, mockPickupStrategyDelegate.pickupFailedError as? MockError)
    }

    /**
     * When: User didn't grant location permissions
     * Then: reverse geocode should not be sent
     */
    func testGuestAuthenticationModeFocusMap() {
        mockLocationService.setLocationAccessEnabled = false
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        let location = CLLocation(latitude: 0.23, longitude: 0.12)
        testObject.userStoppedMovingTheMap(center: location)

        mockKarhooTime.fire()

        XCTAssertFalse(mockAddressService.reverseGeocodeCall.executed)
        XCTAssertNil(mockMapView.locationsToZoomTo)
    }
    
    /**
     * When: User granted location permissions
     * Then: reverse geocode should be sent
     */
    func testGuestAuthenticationModeFocusMapWithLocations() {
        mockLocationService.setLocationAccessEnabled = true
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        let location = CLLocation(latitude: 0.23, longitude: 0.12)
        testObject.userStoppedMovingTheMap(center: location)

        mockKarhooTime.fire()

        XCTAssertTrue(mockAddressService.reverseGeocodeCall.executed)
    }
}
