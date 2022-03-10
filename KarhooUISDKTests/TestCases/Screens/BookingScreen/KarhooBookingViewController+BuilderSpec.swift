//
//  KarhooBookingViewController+BuilderSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDK

final class BookingViewControllerBuilderSpec: XCTestCase {

    private let mockLocationService = MockLocationService()
    private var testObject: BookingScreenBuilder!

    override func setUp() {
        super.setUp()
        mockLocationService.setLocationAccessEnabled = true
        testObject = KarhooBookingScreenBuilder(locationService: mockLocationService)
    }

    // TODO: replace this unit test with snapshot/ui test
    /**
      * When: Side menu handler is set
      * Then: Booking View should be configured as expected
      */
//    func testSideMenuSet() {
//        KarhooUI.sideMenuHandler = MockSideMenuHandler()
//
//        let output = testObject.buildBookingScreen(journeyInfo: TestUtil.getRandomJourneyInfo(),
//                                                   callback: { _ in})
//        let expectedNavigationControllerOutput = (output as? UINavigationController)!
//
//        expectedNavigationControllerOutput.viewControllers.forEach { $0.loadViewIfNeeded() }
//        XCTAssertTrue(expectedNavigationControllerOutput.isNavigationBarHidden)
//        XCTAssertEqual(2, expectedNavigationControllerOutput.viewControllers.count)
//    }

    /**
      * When: No side menu handler is set
      * Then: Booking View should be congigured as expected
      */
//    func testNoSideMenu() {
//        KarhooUI.sideMenuHandler = nil
//        let output = testObject.buildBookingScreen(journeyInfo: nil,
//                                                   callback: { _ in})
//        XCTAssertNil(output as? UINavigationController)
//    }

    /**
      * When: sideMenuHandler is set
      * Then: Booking View should be nested inside navigation stack
      */
    func testNavigationStackWhenSideMenuHanlderIsSet() {
        KarhooUI.sideMenuHandler = MockSideMenuHandler()
        let output = testObject.buildBookingScreen(journeyInfo: nil,
                                                   callback: { _ in})
        XCTAssertNotNil(output as? UINavigationController)
    }

    /**
      * When: sideMenuHandler is set to nil
      * Then: Booking View should be nested inside navigation stack
      */
    func testNavigationStackWhenSideMenuHanlderIsNotSet() {
        KarhooUI.sideMenuHandler = nil
        let output = testObject.buildBookingScreen(journeyInfo: nil,
                                                   callback: { _ in})
        XCTAssertNotNil(output as? UINavigationController)
    }
}
