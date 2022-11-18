//
//  KarhooBookingViewController+BuilderSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class BookingViewControllerBuilderSpec: KarhooTestCase {

    private let mockLocationService = MockLocationService()
    private var testObject: BookingScreenBuilder!

    override func setUp() {
        super.setUp()
        mockLocationService.setLocationAccessEnabled = true
        testObject = KarhooBookingScreenBuilder(locationService: mockLocationService)
    }

    /**
      * When: Side menu handler is set
      * Then: Booking View should be configured as expected
      */
    func testSideMenuSet() {
        KarhooUI.sideMenuHandler = MockSideMenuHandler()

        let output = testObject.buildBookingScreen(journeyInfo: TestUtil.getRandomJourneyInfo(),
                                                   callback: { _ in})
        let expectedNavigationControllerOutput = (output as? UINavigationController)!

        XCTAssertEqual(2, expectedNavigationControllerOutput.viewControllers.count)
    }
}
