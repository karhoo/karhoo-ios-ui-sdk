//
//  QuoteDatesHelperSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 11/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class QuoteDatesHelperSpec: KarhooTestCase {

    typealias sut = QuoteDatesHelper

    func testSetingExpirationDate() {
        let testDate = Date(timeIntervalSince1970: 0)
        let testQuote = Quote(id: "1")
        sut.setExpirationDate(of: testQuote, date: testDate)

        XCTAssertTrue(sut.getExpirationDate(of: testQuote) == Date(timeIntervalSince1970: 0))
    }
}
