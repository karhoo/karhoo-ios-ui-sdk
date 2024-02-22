//
//  BookingDetailsSpec.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

class BookingDetailsSpec: KarhooTestCase {

    /**
     *  Given:  Scheduled date is now
     *  When:   Checking if "is scheduled"
     *  Then:   Should return true
     */
    func testIsScheduledWhenScheduled() {
        var journeyDetails = JourneyDetails(originLocationDetails: TestUtil.getRandomLocationInfo())
        journeyDetails.scheduledDate = Date()

        XCTAssert(journeyDetails.isScheduled)
    }

    /**
     *  Given:  Scheduled date is nil
     *  When:   Checking if "is scheduled"
     *  Then:   Should return false
     */
    func testIsScheduledNil() {
        let journeyDetails = JourneyDetails(originLocationDetails: TestUtil.getRandomLocationInfo())

        XCTAssertFalse(journeyDetails.isScheduled)
    }

    /**
     *  Given:  Scheduled date is 1970-01-01 00:00
     *  When:   Checking if "is scheduled"
     *  Then:   Should return false
     */
    func testIsScheduledFor1970() {
        var journeyDetails = JourneyDetails(originLocationDetails: TestUtil.getRandomLocationInfo())
        journeyDetails.scheduledDate = Date(timeIntervalSince1970: 0)

        XCTAssertFalse(journeyDetails.isScheduled)
    }
}
