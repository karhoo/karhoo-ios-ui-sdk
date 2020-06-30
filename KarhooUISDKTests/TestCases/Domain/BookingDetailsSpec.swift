//
//  BookingDetailsSpec.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

@testable import KarhooUISDK

class BookingDetailsSpec: XCTestCase {

    /**
     *  Given:  Scheduled date is now
     *  When:   Checking if "is scheduled"
     *  Then:   Should return true
     */
    func testIsScheduledWhenScheduled() {
        var bookingDetails = BookingDetails(originLocationDetails: TestUtil.getRandomLocationInfo())
        bookingDetails.scheduledDate = Date()

        XCTAssert(bookingDetails.isScheduled)
    }

    /**
     *  Given:  Scheduled date is nil
     *  When:   Checking if "is scheduled"
     *  Then:   Should return false
     */
    func testIsScheduledNil() {
        let bookingDetails = BookingDetails(originLocationDetails: TestUtil.getRandomLocationInfo())

        XCTAssertFalse(bookingDetails.isScheduled)
    }

    /**
     *  Given:  Scheduled date is 1970-01-01 00:00
     *  When:   Checking if "is scheduled"
     *  Then:   Should return false
     */
    func testIsScheduledFor1970() {
        var bookingDetails = BookingDetails(originLocationDetails: TestUtil.getRandomLocationInfo())
        bookingDetails.scheduledDate = Date(timeIntervalSince1970: 0)

        XCTAssertFalse(bookingDetails.isScheduled)
    }
}
