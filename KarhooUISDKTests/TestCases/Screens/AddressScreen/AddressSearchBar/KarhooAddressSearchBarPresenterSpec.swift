//
//  KarhooAddressSearchBarPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import CoreLocation
import KarhooSDK

@testable import KarhooUISDK

class KarhooAddressSearchBarPresenterSpec: XCTestCase {

    private var mockAddressSearchBar: MockAddressSearchBar!
    private var mockAddressMode: AddressType!
    private var testObject: KarhooAddressSearchBarPresenter!

    override func setUp() {
        super.setUp()

        mockAddressSearchBar = MockAddressSearchBar()
        mockAddressMode = AddressType.destination

        testObject = KarhooAddressSearchBarPresenter(addressSearchBar: mockAddressSearchBar,
                                                     addressMode: mockAddressMode)
    }

    /**
     *  When:   The presenter triggers a seach that contains exactly 0 characters
     *  Then:   The screen should be notified to hide the clear button
     */
    func testHideClearButton() {
        testObject.searchTextChanged(text: "")
        XCTAssertTrue(mockAddressSearchBar.clearButtonHidden)
    }

    /**
     *  When:   The presenter triggers a seach that contains more than 0 characters
     *  Then:   The screen should be notified to show the clear search button
     */
    func testShowClearButton() {
        testObject.searchTextChanged(text: "something")
        XCTAssertFalse(mockAddressSearchBar.clearButtonHidden)
    }

    /**
     *  When:   The presenter is initialised with address mode destination
     *  Then:   The screen should update search placeholder and ringImage
     */
    func testConfigurationForDestination() {
        XCTAssertEqual(mockAddressSearchBar.searchPlaceHolder, UITexts.AddressBar.enterDestination)
//        XCTAssertEqual(mockAddressSearchBar.ringColorSet, KarhooUI.colors.primary)
    }

    /**
     *  When:   The presenter is initialised with address mode pickup
     *  Then:   The screen should update search placeholder and ringImage
     */
    func testConfigurationForPickup() {
        testObject = KarhooAddressSearchBarPresenter(addressSearchBar: mockAddressSearchBar,
                                                     addressMode: .pickup)
        XCTAssertEqual(mockAddressSearchBar.searchPlaceHolder, UITexts.AddressBar.enterPickup)
//        XCTAssertEqual(mockAddressSearchBar.ringColorSet, KarhooUI.colors.secondary)
    }
    
    /**
    *  When:   The presenter is initialised
    *  Then:   The screen should be set with a input char limit equal to 38
    */
    func testMaxInputCharSetCorrectly() {
        XCTAssertNotEqual(mockAddressSearchBar.maxCharSet, -1)
        XCTAssertEqual(mockAddressSearchBar.maxCharSet, 38)
    }
}
