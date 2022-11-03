//
//  BookingAllocationSpinnerPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class BookingAllocationSpinnerPresenterSpec: KarhooTestCase {

    private var testObject: KarhooBookingAllocationSpinnerPresenter!
    private var mockAppStateNotifier: MockAppStateNotifier!
    private var mockView: MockBookingAllocationSpinnerView!

    override func setUp() {
        super.setUp()
        mockAppStateNotifier = MockAppStateNotifier()
        mockView = MockBookingAllocationSpinnerView()

        testObject = KarhooBookingAllocationSpinnerPresenter(appStateNotifier: mockAppStateNotifier,
                                                             view: mockView)
    }

    /**
      * When: Starting
      * Then: Should subscribe app state notifier
      */
    func testStart() {
        testObject.startMonitoringAppState()

        XCTAssertEqual(1, mockAppStateNotifier.registrationsCount)
    }

    /**
     * When: stopping
     * Then: Should unsubscribe app state notifier
     */
    func testStop() {
        testObject.stopMonitoringAppState()

        XCTAssertEqual(0, mockAppStateNotifier.registrationsCount)
    }

    /**
      * When: App goes to background
      * Then: View should stop rotation
      */
    func testAppGoesToBackground() {
        testObject.startMonitoringAppState()

        mockAppStateNotifier.signalAppWillResignActive()

        XCTAssertTrue(mockView.stopRotationCalled)
    }

    /**
     * When: App becomes active
     * Then: View should start rotation
     */
    func testAppBecomesActive() {
        testObject.startMonitoringAppState()

        mockAppStateNotifier.signalAppDidBecomeActive()

        XCTAssertTrue(mockView.startRotationCalled)
    }

}
