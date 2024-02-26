//
//  KarhooBookingViewController+BuilderSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

final class BookingViewControllerBuilderSpec: KarhooTestCase {

    private let mockLocationService = MockLocationService()
    private var testObject: BookingScreenBuilder!

    override func setUp() {
        super.setUp()
        mockLocationService.setLocationAccessEnabled = true
        testObject = KarhooBookingScreenBuilder(locationService: mockLocationService)
    }
}
