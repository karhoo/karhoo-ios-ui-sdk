//
//  KarhooJourneyOptionsPresenterSpec.swift
//  KarhooTests
//
//  Created by Jeevan on 12/11/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import XCTest
@testable import Karhoo

final class KarhooJourneyOptionsPresenterSpec: XCTestCase {

    private var testObject: KarhooJourneyOptionsPresenter!
    private var mockPhoneNumberCaller: MockPhoneNumberCaller!

    override func setUp() {
        super.setUp()

        mockPhoneNumberCaller = MockPhoneNumberCaller()
        testObject = KarhooJourneyOptionsPresenter(phoneNumberCaller: mockPhoneNumberCaller)
    }

    /**
      * When: Calling a number
      * Then: Phone number caller should be called
      */
    func testCallNumber() {
        testObject.call(phoneNumber: "123")

        XCTAssertEqual(mockPhoneNumberCaller.numberCalled, "123")
    }

}
