//
//  KarhooAddressMapPresenterSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class KarhooAddressMapPresenterSpec: KarhooTestCase {

    private var testObject: KarhooAddressMapPresenter!
    private var mockAddressMapView = MockAddressMapView()
    private var mockPickupOnlyStrategy = MockPickupOnlyStrategy()

    override func setUp() {
        super.setUp()

        testObject = KarhooAddressMapPresenter(view: mockAddressMapView,
                                               mapStrategy: mockPickupOnlyStrategy)
    }

    /**
     * When: Presenter loads
     * Then: Strategy should locate user
     */
    func testInit() {
        XCTAssertTrue(mockPickupOnlyStrategy.locateUserCalled)
    }

    /**
     * When: Map loads a new location
     * And: View requests last location from map
     * Then: Presenter should return that location
     * A
     */
    func testReturningALocation() {
        let someSelectedLocation = TestUtil.getRandomLocationInfo()
        testObject.setFromMap(pickup: someSelectedLocation)
        XCTAssertEqual(someSelectedLocation.address.displayAddress, mockAddressMapView.addressBarTextSet)
        XCTAssertEqual(testObject.lastSelectedLocation()?.placeId, someSelectedLocation.placeId)
    }
}
