//
//  PrebookConfirmationFormatterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

class PrebookConfirmationFormatterSpec: KarhooTestCase {

    /**
      * When: Passed booking details
      * Then: Then (PrebookConfirmationFormatter) should return the correct text copy
      */
    func testOutput() {
        let testBookingDetails = TestUtil.getRandomJourneyDetails(dateSet: true)

        let output = PrebookConfirmationFormatter.confirmationMessage(withDetails: testBookingDetails)
        let pickup = testBookingDetails.originLocationDetails!.address.displayAddress
        let destination = testBookingDetails.destinationLocationDetails!.address.displayAddress
        let dateFormatter = KarhooDateFormatter(timeZone: testBookingDetails.originLocationDetails!.timezone())
        let scheduledDate = dateFormatter.display(detailStyleDate: testBookingDetails.scheduledDate)

        let expectedOutput = String(format: UITexts.Booking.prebookConfirmation, pickup, destination, scheduledDate)
        XCTAssertEqual(output, expectedOutput)
    }
}
