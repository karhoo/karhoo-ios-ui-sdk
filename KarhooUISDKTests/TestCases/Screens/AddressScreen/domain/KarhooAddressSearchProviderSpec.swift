//
//  KarhooAddressSearchProviderSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

// swiftlint:disable weak_delegate

import XCTest
import KarhooSDK
import CoreLocation
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class KarhooAddressSearchProviderSpec: KarhooTestCase {

    private var mockAddressService: MockAddressService!
    private var mockAddressSearchProviderDelegate: MockAddressSearchProviderDelegate!
    private var testObject: KarhooAddressSearchProvider!
    private var mockPrefferedLocation: CLLocation = TestUtil.getRandomLocation()

    override func setUp() {
        super.setUp()

        mockAddressService = MockAddressService()
        mockAddressSearchProviderDelegate = MockAddressSearchProviderDelegate()
        testObject = KarhooAddressSearchProvider(addressService: mockAddressService)
        testObject.set(delegate: mockAddressSearchProviderDelegate)
        testObject.set(preferredLocation: mockPrefferedLocation)
    }

    /**
     *  When:   Searching for nothing (empty string)
     *  Then:   No search should be made
     */
    func testSearchForEmptyString() {
        testObject.search(for: "")

        XCTAssertNil(mockAddressService.placeSearchSet)
        XCTAssertFalse(mockAddressSearchProviderDelegate.searchInProgressCalled)
    }

    /**
     *  Given:  A search text with 3 characters
     *  When:   Searching for an address
     *  Then:   A search should be made
     *   And:   The delegate should be informed that a search is in progress
     */
    func testSearchThreeCharacters() {
        testObject.search(for: "abc")

        XCTAssertEqual("abc", mockAddressService.placeSearchSet?.query)
        XCTAssert(mockAddressSearchProviderDelegate.searchInProgressCalled == true)
    }

    /**
     *  When:   Setting a preferred location
     *  Then:   All searches should include that preferred location
     */
    func testPreferredLocation() {
        let location = TestUtil.getRandomLocation()
        testObject.set(preferredLocation: location)
        testObject.search(for: "abc")

        XCTAssertEqual(location.toPosition(), mockAddressService.placeSearchSet?.position)
    }

    /**
     *  Given:  Two search texts with more than 3 characters
     *  When:   Searching for an address and before the result is received the 
     *          second search is made
     *  Then:   Both searches should be fired
     *   And:   The delegate should be informed that a search is in progress
     */
    func testTwoFastSearches() {
        let text1 = "lköö"
        testObject.search(for: text1)

        XCTAssertEqual(text1, mockAddressService.placeSearchSet?.query)

        let text2 = "dljhk"
        testObject.search(for: text2)

        XCTAssertEqual(text2, mockAddressService.placeSearchSet?.query)

        XCTAssertTrue(mockAddressSearchProviderDelegate.searchInProgressCalled)
    }

    /**
     *  When:  A search text with less than 3 characters
     *  Then:  Search should be called and query should be set
     */
    func testLessThanThreeCharacters() {
        testObject.search(for: "ab")

        XCTAssertNil(mockAddressService.placeSearchSet?.query)
        XCTAssertFalse(mockAddressSearchProviderDelegate.searchInProgressCalled)
    }

    /**
     *  When:   A result of a lonely search is received
     *  Then:   It should be passed to the delegate
     */
    func testSuccessResponse() {
        testObject.search(for: "apa")

        let returnPlace = Place(placeId: "ANY_PLACE_ID", displayAddress: "apa")
        mockAddressService.placeSearchCall.triggerSuccess(Places(places: [returnPlace]))

        XCTAssertEqual(mockAddressSearchProviderDelegate.searchCompletedWithPlaces![0].displayAddress,
                       returnPlace.displayAddress)
    }

    /**
     *  Given:  Two searches has been made where the second search IS a
     *          continuation of the first (i.e the first search string IS a
     *          prefix of the second)
     *  When:   The result of the first search is received
     *  Then:   It SHOULD be passed to the delegate
     */
    func testTwoConsecutiveSearches() {
        testObject.search(for: "apa")
        testObject.search(for: "apan")

        let returnPlace = Place(placeId: "apa", displayAddress: "apa")
        mockAddressService.placeSearchCall.triggerSuccess(Places(places: [returnPlace]))

        XCTAssertEqual(mockAddressSearchProviderDelegate.searchCompletedWithPlaces![0].displayAddress,
                       returnPlace.displayAddress)
    }

    /**
     *  Given:  That a search is made with 3 characters
     *   And:   A second search is immediately made with 2 characters
     *  When:   The first search is returned
     *  Then:   The delegate should not be informed of the result of the first
     *          search
     */
    func testSearchShouldNotOverwriteDefaults() {
        testObject.search(for: "apa")
        testObject.search(for: "ap")

        let returnPlace = Place(placeId: "apa", displayAddress: "apa")
        mockAddressService.placeSearchCall.triggerSuccess(Places(places: [returnPlace]))

        XCTAssertNil(mockAddressSearchProviderDelegate.searchCompletedWithPlaces)
    }

    /**
     *  Given:  Only one search in progress
     *  When:   A search returns an error
     *  Then:   The delegate should be informed of the error
     */
    func testFailureResponse() {
        testObject.search(for: "Andrew")

        let error = TestUtil.getRandomError()

        mockAddressService.placeSearchCall.triggerFailure(error)

        XCTAssertTrue(mockAddressSearchProviderDelegate.searchFailedCalled)
        XCTAssertTrue(error.equals(mockAddressSearchProviderDelegate.error))
    }
}
