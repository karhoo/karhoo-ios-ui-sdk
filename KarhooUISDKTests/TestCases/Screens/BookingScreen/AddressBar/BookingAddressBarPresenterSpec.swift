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
@testable import KarhooUISDK

class BookingAddressBarPresenterSpec: XCTestCase {

    private var testObject: BookingAddressBarPresenter!
    private var mockJourneyDetailsController = MockJourneyDetailsController()
    private var testDetails = TestUtil.getRandomJourneyDetails()
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

        testObject = BookingAddressBarPresenter(journeyDetailsController: mockJourneyDetailsController,
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
        XCTAssert(mockJourneyDetailsController.observer === testObject)
    }

    /**
     *  When:   The object is discarded
     *  Then:   Everything should be properly cleared up
     */
    func testDeinit() {
        testObject = nil
        XCTAssertNil(mockJourneyDetailsController.observer)
    }

    /**
     *  When:   Loading the screen
     *  Then:   The current booking details should be set
     */
    func testLoadView() {
        mockJourneyDetailsController.journeyDetailsToReturn = testDetails

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
        XCTAssertEqual(somePickupAddress.placeId, mockJourneyDetailsController.pickupSet?.placeId)
    }

    /**
     *  When:   Selecting the prebook time
     *  And:    Pickup address is a regular address WITH a timezone
     *  Then:   The time picker screen should be shown and passed the correct timezone
     */
    func testPrebookTimeSelectedWithTimeZone() {
        testDetails = TestUtil.getRandomJourneyDetails(originTimeZoneIdentifier: "America/New_York")

        mockJourneyDetailsController.journeyDetailsToReturn = testDetails

        testObject.prebookSelected()

        XCTAssertEqual(mockDatePickerScreenBuilder.timeZoneSet?.identifier, "America/New_York")
    }

    /**
      * When: Pickup is set on booking status
      * Then: Pickup state should be set
      */
    func testPickupSet() {
        let pickupOnlyDetails = TestUtil.getRandomJourneyDetails(destinationSet: false)
        mockJourneyDetailsController.triggerCallback(journeyDetails: pickupOnlyDetails)

        XCTAssertTrue(mockAddressView.pickupSetStateCalled)
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, pickupOnlyDetails.originLocationDetails?.address.displayAddress)
    }

    /**
      * When: Pickup is not set
      * Then: Pickup not set state should be set
      */
    func testPickupNotSet() {
        let pickupOnlyDetails = TestUtil.getRandomJourneyDetails(originSet: false)
        mockJourneyDetailsController.triggerCallback(journeyDetails: pickupOnlyDetails)

        XCTAssertTrue(mockAddressView.pickupNotSetStateCalled)
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, UITexts.AddressBar.addPickup)
    }

    /**
      * When: Destination is set on booking status
      * Then: Destination state should be set
      */
    func testDestinationSet() {
        let bookingDetails = TestUtil.getRandomJourneyDetails(destinationSet: true)
        mockJourneyDetailsController.triggerCallback(journeyDetails: bookingDetails)
        
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, bookingDetails.originLocationDetails?.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, bookingDetails.destinationLocationDetails!.address.displayAddress)
    }

    /**
     * Given: address bar is selected
     * When: User succssfully enters prebook date
     * Then: scheduledDate on booking status should be set
     */
    func testScheduledDateSet() {
        testDetails = TestUtil.getRandomJourneyDetails(originSet: true, originTimeZoneIdentifier: "America/New_York")
        mockJourneyDetailsController.journeyDetailsToReturn = testDetails
        
        testObject.prebookSelected()

        let selectedDate = TestUtil.getRandomDate()
        mockDatePickerScreenBuilder.triggerScreenResult(.completed(result: selectedDate))

        XCTAssertEqual(selectedDate, mockJourneyDetailsController.dateSet)
    }

    /**
     *  When:   Clearing the pickup address
     *  Then:   The pickup address in the booking status should be informed
     */
    func testPickupCleared() {
        testObject.addressCleared(type: .pickup)

        XCTAssert(mockJourneyDetailsController.pickupSetCalled)
        XCTAssertNil(mockJourneyDetailsController.pickupSet)
    }

    /**
     *  When:   Clearing the destination address
     *  Then:   The pickup address in the booking status should be informed
     */
    func testDestinationCleared() {
        testObject.addressCleared(type: .destination)

        XCTAssert(mockJourneyDetailsController.destinationSetCalled)
        XCTAssertNil(mockJourneyDetailsController.destinationSet)
    }

    /**
     *  When:   Clearing the pickup time
     *  Then:   The pickup address in the booking status should be informed
     */
    func testPickupTimeCleared() {
        testObject.prebookCleared()

        XCTAssert(mockJourneyDetailsController.dateSetCalled)
        XCTAssertNil(mockJourneyDetailsController.dateSet)
    }

    /**
     *  When:   The booking details is changed (contains info)
     *  Then:   The screen should be updated with that information
     */
    func testSettingDetails() {
        testDetails = TestUtil.getRandomJourneyDetails(dateSet: true)
        mockJourneyDetailsController.journeyDetailsToReturn = testDetails
        testObject.load(view: mockAddressView)

        mockJourneyDetailsController.triggerCallback(journeyDetails: testDetails)
        let timeZone = mockJourneyDetailsController.getJourneyDetails()?.originLocationDetails?.timezone() ?? TimeZone.current
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
        mockJourneyDetailsController.journeyDetailsToReturn = nil
        mockJourneyDetailsController.triggerCallback(journeyDetails: nil)

        testObject = BookingAddressBarPresenter(journeyDetailsController: mockJourneyDetailsController,
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
        let initialBookingDetails = TestUtil.getRandomJourneyDetails(destinationSet: true,
                                                                     dateSet: true)
        testObject.load(view: mockAddressView)
        mockJourneyDetailsController.journeyDetailsToReturn = initialBookingDetails

        mockJourneyDetailsController.triggerCallback(journeyDetails: initialBookingDetails)

        testObject.addressSwapSelected()
        
        XCTAssertEqual(mockJourneyDetailsController.destinationSet?.placeId, initialBookingDetails.originLocationDetails?.placeId)
        XCTAssertEqual(mockJourneyDetailsController.pickupSet?.placeId, initialBookingDetails.destinationLocationDetails?.placeId)
        
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
        let initialBookingDetails = TestUtil.getRandomJourneyDetails(destinationSet: true,
                                                                     dateSet: false)
        mockJourneyDetailsController.journeyDetailsToReturn = initialBookingDetails

        testObject.load(view: mockAddressView)

        testObject.addressSwapSelected()
        
        XCTAssertEqual(mockJourneyDetailsController.destinationSet?.placeId, initialBookingDetails.originLocationDetails?.placeId)
        XCTAssertEqual(mockJourneyDetailsController.pickupSet?.placeId, initialBookingDetails.destinationLocationDetails?.placeId)
        
        XCTAssertEqual(mockAddressView.pickupDisplayAddressSet, initialBookingDetails.destinationLocationDetails!.address.displayAddress)
        XCTAssertEqual(mockAddressView.destinationDisplayAddressSet, initialBookingDetails.originLocationDetails?.address.displayAddress)
        XCTAssertNil(mockAddressView.prebookTimeStringSet)
        XCTAssertNil(mockAddressView.prebookDateStringSet)
    }
}
