//
//  AddressViewControllerPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import CoreLocation
import KarhooSDK

@testable import KarhooUISDK

class KarhooAddressPresenterSpec: XCTestCase {

    private var mockLocation: CLLocation!
    private var mockAddressMode: AddressType!
    private var mockAddressView: MockAddressView!
    private var mockAddressSearchProvider: MockAddressSearchProvider!
    private var mockAddressService: MockAddressService!
    private var mockAppAnalytics: MockAnalytics!
    private var mockLocationService: MockLocationService!
    private var testObject: KarhooAddressPresenter!
    private var mockLocationInfoResult: ScreenResult<LocationInfo>?
    private var searchDelay = 0.1
    private var mockRecentAddressProvider = MockRecentAddressProvider()
    private var mockUserLocationProvider = MockUserLocationProvider()

    override func setUp() {
        super.setUp()
        mockLocation = CLLocation()
        mockAddressMode = .destination
        mockAddressSearchProvider = MockAddressSearchProvider()
        mockAddressService = MockAddressService()
        mockAddressView = MockAddressView()
        mockAppAnalytics = MockAnalytics()

        testObject = KarhooAddressPresenter(preferredLocation: mockLocation,
                                            addressMode: mockAddressMode,
                                            selectionCallback: { self.mockLocationInfoResult = $0 },
                                            searchProvider: mockAddressSearchProvider,
                                            userLocationProvider: mockUserLocationProvider,
                                            addressService: mockAddressService,
                                            analytics: mockAppAnalytics,
                                            recentAddressProvider: mockRecentAddressProvider,
                                            searchDelay: searchDelay)

        testObject.set(view: mockAddressView)
    }

    /**
     *  When:   The presenter has been initialized
     *  Then:   The search provider should be correctly configured
     */
    func testInitialization() {
        XCTAssertNotNil(mockAddressSearchProvider.delegate)
        XCTAssert(mockAddressSearchProvider.preferredLocation == mockLocation)
    }

    /**
     *  When:   Entering a destination address
     *  Then:   The screen should show the destination hint
     *   And:   The default addresses should be fetched
     *   And:   The title should set to Destination
     *   And:   The keyboard should rise
     */
    func testViewShown() {
        testObject.set(view: mockAddressView)
        testObject.viewWillShow()

        XCTAssertEqual(mockAddressView.titleString, UITexts.Generic.destination)
        XCTAssertEqual(mockAddressView.mapPickerIconSet, .mapDropOff)
        XCTAssertTrue(mockAddressSearchProvider.fetchDefaultValuesCalled)
        XCTAssertTrue(mockAddressView.focusInputFieldCalled)
    }

    /**
     *  When:   Entering a pickup address
     *  Then:   The screen should show the destination hint
     *   And:   The default addresses should be fetched
     *   And:   The title should set to Destination
     */
    func testPickupViewShown() {
        let pickupInput = KarhooAddressPresenter(preferredLocation: mockLocation,
                                                 addressMode: AddressType.pickup,
                                                 selectionCallback: { self.mockLocationInfoResult = $0 },
                                                 searchProvider: mockAddressSearchProvider,
                                                 addressService: mockAddressService)

        pickupInput.set(view: mockAddressView)
        pickupInput.viewWillShow()

        XCTAssert(mockAddressView.titleString == UITexts.Generic.pickup)
        XCTAssertEqual(mockAddressView.mapPickerIconSet, .mapPickUp)

    }
    
    /**
     *  When the presenter needs to check the location permissions
     *  In case the permissions are denied
     *  Then the view's disableLocationOptions method will be called
     */
    func testCheckingTheLocationPermissionsDenied() {
        mockLocationService = MockLocationService()
        mockLocationService.setLocationAccessEnabled = false
        
        let presenter = KarhooAddressPresenter(preferredLocation: mockLocation,
                                                 addressMode: AddressType.pickup,
                                                 selectionCallback: { self.mockLocationInfoResult = $0 },
                                                 searchProvider: mockAddressSearchProvider,
                                                 addressService: mockAddressService,
                                                 locationService: mockLocationService)

        presenter.set(view: mockAddressView)
        presenter.checkLocationPermissions()
        
        XCTAssertFalse(mockAddressView.hasCalledTheBuildMapViewMethod)
        XCTAssertTrue(mockAddressView.hasCalledDisableLocationOptionsMethod)
    }
    
    /**
     *  When the presenter needs to check the location permissions
     *  In case the permissions are granted
     *  Then the view's buildAddressMapView method will be called
     */
    func testCheckingTheLocationPermissionsGranted() {
        mockLocationService = MockLocationService()
        mockLocationService.setLocationAccessEnabled = true
        
        let presenter = KarhooAddressPresenter(preferredLocation: mockLocation,
                                                 addressMode: AddressType.pickup,
                                                 selectionCallback: { self.mockLocationInfoResult = $0 },
                                                 searchProvider: mockAddressSearchProvider,
                                                 addressService: mockAddressService,
                                                 locationService: mockLocationService)

        presenter.set(view: mockAddressView)
        presenter.checkLocationPermissions()
        
        XCTAssertTrue(mockAddressView.hasCalledTheBuildMapViewMethod)
        XCTAssertFalse(mockAddressView.hasCalledDisableLocationOptionsMethod)
    }
    
    /**
     *  When:   Close is pressed
     *  Then:   The callback should be called without an address
     */
    func testClose() {
        testObject.close()

        XCTAssertNotNil(mockLocationInfoResult)
        XCTAssertNil(mockLocationInfoResult?.completedValue())
    }

    /**
     *  When:   An address is selected
     *  Then:   The details for that address should be fetched
     *  And:    The keyboard should be dismised
     */
    func testSelectedAddress() {
        let address = TestUtil.getRandomLocationInfo()
        let addressViewModel = AddressCellViewModel(address: address)
        testObject.selected(address: addressViewModel)

        XCTAssertTrue(mockAddressView.unfocusInputFieldCalled)
        XCTAssertEqual(address.placeId, mockAddressService.locationInfoSearchSet?.placeId)
        XCTAssertEqual(mockAddressService.locationInfoSearchSet?.sessionToken, mockAddressSearchProvider.sessionToken)
    }

    /**
     *  When:   Details for an address has been fetched
     *  Then:   That detailed address should be passed back through the callback
     */
    func testDetailsSuccessful() {
        let address = TestUtil.getRandomLocationInfo(placeId: "test")
        let addressViewModel = AddressCellViewModel(address: address)

        testObject.selected(address: addressViewModel)
        mockAddressService.locationInfoCall.triggerSuccess(TestUtil.getRandomLocationInfo(placeId: "test"))

        XCTAssertEqual(address.placeId, mockLocationInfoResult?.completedValue()?.placeId)
        XCTAssertEqual(mockRecentAddressProvider.addedRecent?.placeId, address.placeId)
        XCTAssertTrue(mockAppAnalytics.destinationAddressSelected)
    }

    /**
     *  When:   Getting the details for an address fails
     *  Then:   At least it shouldnt crash
     *  And:    The keyboard should focus
     */
    func testDetailsFailure() {
        testObject.set(view: mockAddressView)

        testObject.selected(address: AddressCellViewModel(address: TestUtil.getRandomLocationInfo()))
        let error = TestUtil.getRandomError()
        mockAddressService.locationInfoCall.triggerFailure(error)
        XCTAssertTrue(mockAddressView.focusInputFieldCalled)
        XCTAssert(error.equals(mockAddressView.errorToShow!))
        XCTAssertFalse(mockAppAnalytics.destinationAddressSelected)
        XCTAssertNil(mockRecentAddressProvider.addedRecent)
    }

    /**
     *  When:   The user enters some search text
     *  Then:   That text should be passed on to the search
     */
    func testSearch() {
        testObject = KarhooAddressPresenter(
            preferredLocation: mockLocation,
            addressMode: mockAddressMode,
            selectionCallback: { self.mockLocationInfoResult = $0 },
            searchProvider: mockAddressSearchProvider,
            userLocationProvider: mockUserLocationProvider,
            addressService: mockAddressService,
            analytics: mockAppAnalytics,
            recentAddressProvider: mockRecentAddressProvider,
            searchDelay: 0
        )

        testObject.set(view: mockAddressView)

        mockUserLocationProvider.lastKnownLocation = TestUtil.getRandomLocation()
        let searchText = "Some text"
        testObject.search(text: searchText)

        let expectation = XCTestExpectation()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2, execute: {
            XCTAssertEqual(self.mockAddressSearchProvider.searchString, searchText)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)
    }

    /**
     *  When:   The user removes the previously searched text
     *  Then:   The search should be updated accordingly
     */
    func testEmptySearch() {
        let searchText = "Some text"
        testObject.search(text: searchText)
        testObject.search(text: nil)

        let expectation = XCTestExpectation()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            XCTAssert(self.mockAddressSearchProvider.searchString == "")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)
    }

    /**
     *  When:   Results from the search providers are received
     *  Then:   Those results should be passed on to the screen
     *  And:    Empty Data set should hide
     */
    func testAddressSearchResults() {
        let place1 = Place(placeId: "hej", displayAddress: "Address1Line1")
        let place2 = Place(placeId: "jeh", displayAddress: "Address2Line1")

        testObject.set(view: mockAddressView)
        mockAddressSearchProvider.triggerSuccessResponse(places: [place2, place1])

        XCTAssert(mockAddressView.addressCellsToShow?.count == 2)
        XCTAssert(mockAddressView.addressCellsToShow?.first?.displayAddress == place2.displayAddress)
        XCTAssert(mockAddressView.addressCellsToShow!.first!.subtitleAddress.isEmpty)
        XCTAssert(mockAddressView.addressCellsToShow?.last?.displayAddress == place1.displayAddress)
        XCTAssert(mockAddressView.addressCellsToShow!.last!.subtitleAddress.isEmpty)
        XCTAssertTrue(mockAddressView.hideEmptyDataSetCalled)
    }

    /**
     *  When:   The search provider provides the default addresses to show
     *  Then:   The screen should be notified accordingly
     */
    func testDefaultAddresses() {
        let recent = TestUtil.getRandomLocationInfo()

        testObject.set(view: mockAddressView)
        mockAddressSearchProvider.triggerDefaultResponse(recents: [recent])

        XCTAssert(mockAddressView.addressCellsToShow?.first?.placeId == recent.placeId)
        XCTAssert(mockAddressView.addressCellsToShow?.first?.displayAddress == recent.address.displayAddress)
        XCTAssert(mockAddressView.addressCellsToShow?.first?.subtitleAddress == recent.address.lineOne)

        XCTAssertTrue(mockAddressView.hideEmptyDataSetCalled)
    }

    /**
     *  Given:   The search provider provides the default addresses to show
     *  When:    Recent addresses are empty
     *  Then:    The screen should set empty data set message to no recent address
     */
    func testNoDefaultAddresses() {
        testObject.set(view: mockAddressView)
        mockAddressSearchProvider.triggerDefaultResponse(recents: [])

        XCTAssertEqual(mockAddressView.emptyDataSetMessageSet, UITexts.AddressScreen.noRecentAddresses)
    }

    /**
     *  When:   The search provider notifies of a search in progress
     *  Then:   The screen should be notified accordingly
     */
    func testSearchInProgress() {
        testObject.set(view: mockAddressView)
        mockAddressSearchProvider.triggerSearchInProgress()

        XCTAssertTrue(mockAddressView.showLoadingIndicatorCalled)
    }
    
    /**
     * When: Results from the search providers are recieved
     * Then: Those results are empty
     * And: Empty Data set should show with message
     */
    func testNoSearchResultsFound() {
        testObject.set(view: mockAddressView)
        mockAddressSearchProvider.triggerSuccessResponse(places: [])
        
        XCTAssertNil(mockAddressView.addressCellsToShow)
        XCTAssertFalse(mockAddressView.hideEmptyDataSetCalled)
        XCTAssertEqual("\(UITexts.Errors.noResultsFound)", mockAddressView.emptyDataSetMessageSet)
    }

    /**
     *  When:   The search provider fails (no results found)
     *  Then:   View should show empty data set
     */
    func testSearchFailedNoResultsFound() {
        testObject.set(view: mockAddressView)
        let error = TestUtil.getRandomError(code: "K2002")
        mockAddressSearchProvider.triggerFailedSearch(error: error)

        XCTAssertEqual(UITexts.Errors.noResultsFound, mockAddressView.emptyDataSetMessageSet)
    }

    /**
     *  When:   The search provider fails for some other reason
     *  Then:   View should not show empty data set
     */
    func testSearchFailedUnexpectedError() {
        testObject.set(view: mockAddressView)
        let error = TestUtil.getRandomError(code: "unexpectedCode")
        mockAddressSearchProvider.triggerFailedSearch(error: error)

        XCTAssertNil(mockAddressView.emptyDataSetMessageSet)
        XCTAssertTrue(mockAddressView.hideEmptyDataSetCalled)
    }

    /**
     *  When:   The presenter clears the search
     *  Then:   The screen should be notified clear search input
     *  And:    Hide loading indicator and empty data set view
     */
    func tesClearSearch() {
        testObject.set(view: mockAddressView)
        testObject.clearSearch()
        XCTAssertTrue(mockAddressView.clearSearchFieldCalled)
        XCTAssertTrue(mockAddressView.hideLoadingIndicatorCalled)
        XCTAssertTrue(mockAddressView.hideEmptyDataSetCalled)
        XCTAssertEqual("", mockAddressSearchProvider.searchString)
    }

    /**
     *  When:   User selects address from the map view
     *  Then:   Address should be passed on to the completion handler
     */
    func testAddressPickedFromMap() {
        let mockLocationInfo = TestUtil.getRandomLocationInfo()
        testObject.addressMapViewSelected(location: mockLocationInfo)

        XCTAssertTrue(mockAddressView.unfocusInputFieldCalled)
        XCTAssertEqual(mockRecentAddressProvider.addedRecent?.placeId, mockLocationInfo.placeId)
        XCTAssertTrue(mockAppAnalytics.destinationAddressSelected)
    }
    
    /**
        *  Given:   User taps on Current location
        *  When:    The location should be reverse geolocated successfully
        *  Then:    Address provided shouldn't be saved
        *  And:     Analytics service tracks current location pressed and drop off event
        *  And:     Location is given back to completion handler
        */
    func testCurrentLocationSuccess() {
        let location = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location

        testObject.getCurrentLocation()
        
        let locationInfo = TestUtil.getRandomLocationInfo()
        
        mockAddressService.reverseGeocodeCall.triggerSuccess(locationInfo)
        
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.latitude, location.coordinate.latitude)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.longitude, location.coordinate.longitude)
        XCTAssertNotNil(mockLocationInfoResult)
        XCTAssertEqual(mockLocationInfoResult?.completedValue()?.placeId, locationInfo.placeId)
    }
    
    /**
        *  Given:   User taps on Current location
        *  When:    The location fails
        *  Then:    Address View should focus input field
        *  And:     Address View should show error
        */
    func testCurrentLocationFailure() {
        
        let location = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location
        
        testObject.getCurrentLocation()
    
        let error = TestUtil.getRandomError()
        mockAddressService.reverseGeocodeCall.triggerFailure(error)
        
        XCTAssertTrue(mockAddressView.focusInputFieldCalled)
        XCTAssertEqual(mockAddressView?.errorToShow?.code, error.code)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.latitude, location.coordinate.latitude)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.longitude, location.coordinate.longitude)
    }
    
    /**
        *  Given:   User taps on Current location
        *  When:    The location provider fails
        *  Then:    Nothing should happen
        */
    func testCurrentLocationReturnsNil() {
        mockUserLocationProvider.lastKnownLocation = nil
        testObject.getCurrentLocation()
        XCTAssertNil(mockAddressService.reverseGeocodePositionSet)
    }

    func testIfReverseGeocodingDidNotSendResponseShouldNotReverseGeocodeAnotherCurrentLocation() {
        let location1 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location1
        testObject.getCurrentLocation()

        let location2 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location2
        testObject.getCurrentLocation()

        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.latitude, location1.coordinate.latitude)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.longitude, location1.coordinate.longitude)
    }

    func testShouldBeAbleReverseGeocodeCurrentLocationAgainAfterGeocodingFailureResponse() {
        let location1 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location1
        testObject.getCurrentLocation()

        let error = TestUtil.getRandomError()
        mockAddressService.reverseGeocodeCall.triggerFailure(error)

        let location2 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location2
        testObject.getCurrentLocation()

        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.latitude, location2.coordinate.latitude)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.longitude, location2.coordinate.longitude)
    }

    func testShouldBeAbleReverseGeocodeCurrentLocationAgainAfterGeocodingSuccessfulResponse() {
        let location1 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location1
        testObject.getCurrentLocation()

        let locationInfo = TestUtil.getRandomLocationInfo()
        mockAddressService.reverseGeocodeCall.triggerSuccess(locationInfo)

        let location2 = TestUtil.getRandomLocation()
        mockUserLocationProvider.lastKnownLocation = location2
        testObject.getCurrentLocation()

        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.latitude, location2.coordinate.latitude)
        XCTAssertEqual(mockAddressService.reverseGeocodePositionSet?.longitude, location2.coordinate.longitude)
    }
}
