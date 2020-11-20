//
//  BookingAddressBarPresenterSpec.swift
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

class BookingAddressBarPresenterSpec: XCTestCase {

    private var testObject: BookingAddressBarPresenter!
    private var mockBookingStatus = MockBookingStatus()
    private var testDetails = TestUtil.getRandomBookingDetails()
    private var mockDatePickerScreenBuilder = MockDatePickerScreenBuilder()
    private var mockAddressView: MockAddressBarView!
    private var prebookFormatter: KarhooDateFormatter!
    private var mockAddressService = MockAddressService()
    private var mockUserLocationProvider = MockUserLocationProvider()
    private let location = TestUtil.getRandomLocation()
    private var mockAddressScreenBuilder = MockAddressScreenBuilder()

    override func setUp() {
        super.setUp()
        mockAddressView = MockAddressBarView()
        mockUserLocationProvider.lastKnownLocation = location

        testObject = BookingAddressBarPresenter(bookingStatus: mockBookingStatus,
                                                addressService: mockAddressService,
                                                userLocationProvider: mockUserLocationProvider,
                                                addressScreenBuilder: mockAddressScreenBuilder,
                                                datePickerScreenBuilder: mockDatePickerScreenBuilder)

        prebookFormatter = KarhooDateFormatter(timeZone: testDetails.destinationLocationDetails?.timezone() ?? TimeZone.current)
         testObject.load(view: mockAddressView)
    }

    /**
     *  When:   The initialization is complete
     *  Then:   Everything should be properly set up
     */
    func testInitialization() {
        XCTAssert(mockBookingStatus.observer === testObject)
    }

    /**
     *  When:   The object is discarded
     *  Then:   Everything should be properly cleared up
     */
    func testDeinit() {
        testObject = nil
        XCTAssertNil(mockBookingStatus.observer)
    }

    /**
     *  When:   Loading the screen
     *  Then:   The current booking details should be set
     */
    func testLoadView() {
        mockBookingStatus.bookingDetailsToReturn = testDetails

        testObject.load(view: mockAddressView)

        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, testDetails.originLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, testDetails.destinationLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.prebookTimeStringSet, prebookFormatter.display(shortStyleTime: testDetails.scheduledDate))
        XCTAssertEqual(mockAddressView.prebookDateStringSet, prebookFormatter.display(mediumStyleDate: testDetails.scheduledDate))
    }

    /**
      * Given: address bar is selected
      * When: User succssfully enters pickup
      * Then: pickup on booking status should be set
      * And: Screen should dismiss
      */
    func testPickupAddressSet() {
        let somePickupAddress = TestUtil.getRandomLocationInfo()
        let expectedBias = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = expectedBias

        testObject.addressSelected(type: .pickup)
        mockAddressScreenBuilder.triggerAddressScreenResult(.completed(result: somePickupAddress))

        XCTAssertEqual(expectedBias.coordinate, mockAddressScreenBuilder.preferredLocationSet?.coordinate)
        XCTAssertEqual(somePickupAddress.placeId, mockBookingStatus.pickupSet?.placeId)
    }

    /**
     *  When:   Selecting the prebook time
     *  And:    Pickup address is a regular address WITH a timezone
     *  Then:   The time picker screen should be shown and passed the correct timezone
     */
    func testPrebookTimeSelectedWithTimeZone() {
        testDetails = TestUtil.getRandomBookingDetails(originTimeZoneIdentifier: "America/New_York")

        mockBookingStatus.bookingDetailsToReturn = testDetails

        testObject.prebookSelected()

        XCTAssertEqual(mockDatePickerScreenBuilder.timeZoneSet?.identifier, "America/New_York")
    }

    /**
      * When: Pickup is set on booking status
      * Then: Pickup state should be set
      */
    func testPickupSet() {
        let pickupOnlyDetails = TestUtil.getRandomBookingDetails(destinationSet: false)
        mockBookingStatus.triggerCallback(bookingDetails: pickupOnlyDetails)

        XCTAssertTrue(mockAddressView.pickupSetStateCalled)
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, pickupOnlyDetails.originLocationDetails?.address.displayAddress)
    }

    /**
      * When: Pickup is not set
      * Then: Pickup not set state should be set
      */
    func testPickupNotSet() {
        let pickupOnlyDetails = TestUtil.getRandomBookingDetails(originSet: false)
        mockBookingStatus.triggerCallback(bookingDetails: pickupOnlyDetails)

        XCTAssertTrue(mockAddressView.pickupNotSetStateCalled)
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, UITexts.AddressBar.addPickup)
    }

    /**
      * When: Destination is set on booking status
      * Then: Destination state should be set
      */
    func testDestinationSet() {
        let bookingDetails = TestUtil.getRandomBookingDetails(destinationSet: true)
        mockBookingStatus.triggerCallback(bookingDetails: bookingDetails)
        
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, bookingDetails.originLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, bookingDetails.destinationLocationDetails!.address.displayAddress)
    }

    /**
     * Given: address bar is selected
     * When: User succssfully enters prebook date
     * Then: scheduledDate on booking status should be set
     */
    func testScheduledDateSet() {
        testDetails = TestUtil.getRandomBookingDetails(originSet: true, originTimeZoneIdentifier: "America/New_York")
        mockBookingStatus.bookingDetailsToReturn = testDetails
        
        testObject.prebookSelected()

        let selectedDate = TestUtil.getRandomDate()
        mockDatePickerScreenBuilder.triggerScreenResult(.completed(result: selectedDate))

        XCTAssertEqual(selectedDate, mockBookingStatus.dateSet)
    }

    /**
     *  When:   Clearing the pickup address
     *  Then:   The pickup address in the booking status should be informed
     */
    func testPickupCleared() {
        testObject.addressCleared(type: .pickup)

        XCTAssert(mockBookingStatus.pickupSetCalled)
        XCTAssertNil(mockBookingStatus.pickupSet)
    }

    /**
     *  When:   Clearing the destination address
     *  Then:   The pickup address in the booking status should be informed
     */
    func testDestinationCleared() {
        testObject.addressCleared(type: .destination)

        XCTAssert(mockBookingStatus.destinationSetCalled)
        XCTAssertNil(mockBookingStatus.destinationSet)
    }

    /**
     *  When:   Clearing the pickup time
     *  Then:   The pickup address in the booking status should be informed
     */
    func testPickupTimeCleared() {
        testObject.prebookCleared()

        XCTAssert(mockBookingStatus.dateSetCalled)
        XCTAssertNil(mockBookingStatus.dateSet)
    }

    /**
     *  When:   The booking details is changed (contains info)
     *  Then:   The screen should be updated with that information
     */
    func testSettingDetails() {
        testDetails = TestUtil.getRandomBookingDetails(dateSet: true)
        mockBookingStatus.bookingDetailsToReturn = testDetails
        testObject.load(view: mockAddressView)

        mockBookingStatus.triggerCallback(bookingDetails: testDetails)
        let timeZone = mockBookingStatus.getBookingDetails()?.originLocationDetails?.timezone() ?? TimeZone.current
        let formatter = KarhooDateFormatter(timeZone: timeZone)

        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, testDetails.originLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, testDetails.destinationLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.prebookTimeStringSet, formatter.display(shortStyleTime: testDetails.scheduledDate))
        XCTAssertEqual(mockAddressView.prebookDateStringSet, formatter.display(mediumStyleDate: testDetails.scheduledDate))
    }

    /**
     *  When:   The booking details is nil
     *  Then:   The screen should be updated with that information
     */
    func testSettingNilDetails() {
        mockBookingStatus.bookingDetailsToReturn = nil
        mockBookingStatus.triggerCallback(bookingDetails: nil)

        testObject = BookingAddressBarPresenter(bookingStatus: mockBookingStatus,
                                                addressService: mockAddressService,
                                                userLocationProvider: mockUserLocationProvider)

        testObject.load(view: mockAddressView)

        XCTAssertNotNil(mockAddressView.pickupDisplayAddressSet)
        XCTAssertNil(mockAddressView.destinationDisplayAddressSet)
        XCTAssertNil(mockAddressView.prebookTimeStringSet)
        XCTAssertNil(mockAddressView.prebookDateStringSet)
    }
    
    /**
      * Given: The user swaps addresses
      * When: There is a scheduled date set
      * Then: The booking details should be swapped
      * And: The scheduled date should be retained
      * And:  The view should be updated
      */
    func testAddressBarSwapWithScheduledDate() {
        let initialBookingDetails = TestUtil.getRandomBookingDetails(destinationSet: true,
                                                                     dateSet: true)
        testObject.load(view: mockAddressView)
        mockBookingStatus.bookingDetailsToReturn = initialBookingDetails

        mockBookingStatus.triggerCallback(bookingDetails: initialBookingDetails)

        testObject.addressSwapSelected()
        
        XCTAssertEqual(mockBookingStatus.destinationSet?.placeId, initialBookingDetails.originLocationDetails?.placeId)
        XCTAssertEqual(mockBookingStatus.pickupSet?.placeId, initialBookingDetails.destinationLocationDetails?.placeId)
        
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, initialBookingDetails.destinationLocationDetails!.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, initialBookingDetails.originLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.prebookTimeStringSet, prebookFormatter.display(shortStyleTime: initialBookingDetails.scheduledDate))
        XCTAssertEqual(mockAddressView.prebookDateStringSet, prebookFormatter.display(mediumStyleDate: initialBookingDetails.scheduledDate))
    }
    
    /**
     * Given: The user swaps addresses
     * When: There is NO scheduled date set
     * Then: The booking details should be swapped
     * And:  View should have a nil scheduled date
     * And:  The view should be updated
     */
    func testAddressBarSwapWithNilScheduledDate() {
        let initialBookingDetails = TestUtil.getRandomBookingDetails(destinationSet: true,
                                                                     dateSet: false)
        mockBookingStatus.bookingDetailsToReturn = initialBookingDetails

        testObject.load(view: mockAddressView)

        testObject.addressSwapSelected()
        
        XCTAssertEqual(mockBookingStatus.destinationSet?.placeId, initialBookingDetails.originLocationDetails?.placeId)
        XCTAssertEqual(mockBookingStatus.pickupSet?.placeId, initialBookingDetails.destinationLocationDetails?.placeId)
        
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, initialBookingDetails.destinationLocationDetails!.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, initialBookingDetails.originLocationDetails?.address.displayAddress)
        XCTAssertNil(mockAddressView.prebookTimeStringSet)
        XCTAssertNil(mockAddressView.prebookDateStringSet)
    }
    
    /**
    * Given: A JourneyInfo is injected
    * Then: JourneyInfo object's component for pickUp is reverse geolocated successfully
    * And: The pickupState is updated
    * And: The prebookTime is updated
    */
    func testReverseGeocodeJourneyInfoSuccessPickUp() {
        let journeyInfo = JourneyInfo(origin: CLLocation(latitude: 51.421360, longitude: -0.207590),
                                      destination: CLLocation(latitude: 51.438240, longitude: -0.156670),
                                      date: Date(timeIntervalSince1970: 1576518267))
        
        testObject.reverseGeocodeLocation(journeyInfo.origin, type: .pickup)
        let locationInfo = TestUtil.getRandomLocationInfo()
        mockAddressService.reverseGeocodeCall.triggerSuccess(locationInfo)
    
        XCTAssertTrue(mockAddressView.setPickupCalled)
        XCTAssertTrue(mockAddressView.defaultPrebookStateSet)
    }
    
    /**
    * Given: A JourneyInfo is injected
    * Then: JourneyInfo object's component for dropOff is reverse geolocated successfully
    * And: The pickupState is updated
    * And: The Destination state is updated
    */
    func testReverseGeocodeJourneyInfoSuccessDropOff() {
        let journeyInfo = JourneyInfo(origin: CLLocation(latitude: 51.421360, longitude: -0.207590),
                                      destination: CLLocation(latitude: 51.438240, longitude: -0.156670),
                                      date: Date(timeIntervalSince1970: 1576518267))
        
        testObject.reverseGeocodeLocation(journeyInfo.destination!, type: .destination)

        let locationInfo = TestUtil.getRandomLocationInfo()
        mockAddressService.reverseGeocodeCall.triggerSuccess(locationInfo)
    
        XCTAssertTrue(mockAddressView.destinationSetStateCalled)
    }
    
    /**
    * Given: A JourneyInfo is injected
    * Then: JourneyInfo object's components are NOT reverse geolocated
    * And: The pickupState is not updated
    * And: The Destination state is not updated
    */
    func testReverseGeocodeJourneyInfoFailure() {
        let journeyInfo = JourneyInfo(origin: CLLocation(latitude: 51.421360, longitude: -0.207590),
                                      destination: CLLocation(latitude: 51.438240, longitude: -0.156670),
                                      date: nil)
        
        testObject.setJourneyInfo(journeyInfo)
        let error = TestUtil.getRandomError()
        mockAddressService.reverseGeocodeCall.triggerFailure(error)

        XCTAssertEqual(mockBookingStatus.pickupSet?.placeId, nil)
        XCTAssertEqual(mockBookingStatus.destinationSet?.placeId, nil)
    }
}
