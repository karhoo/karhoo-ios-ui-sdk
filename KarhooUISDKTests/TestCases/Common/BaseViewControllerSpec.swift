//
//  BaseViewSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

private class SomeBaseView: MockViewController, BaseViewController {}

final class BaseViewControllerSpec: KarhooTestCase {

    private let testObject = SomeBaseView()

    /**
      * When: Showing an alert
      * Then: Expected alert should show
      */
    func testShowAlert() {
        testObject.showAlert(title: "title", message: "message", error: nil)

        let alert = testObject.presentedItem as? UIAlertController

        XCTAssertEqual("title", alert?.title)
        XCTAssertEqual("message", alert?.message)
    }

    /**
      * When: Showing a karhoo error
      * Then: Expected alert should be shwon
      */
    func testShowError() {
        let someError = TestUtil.getRandomError()

        testObject.show(error: someError)

        let alert = testObject.presentedItem as? UIAlertController
        let expectedMessage = "\(someError.userMessage) [\(someError.code)]"

        XCTAssertEqual(UITexts.Errors.somethingWentWrong, alert?.title)
        XCTAssertEqual(expectedMessage, alert?.message)
    }

    /**
     * When: Showing pre auth alert error
     * Then: Expected alert should show
     */
    func testPreAuthAlert() {
        testObject.showUpdatePaymentCardAlert(updateCardSelected: {})

        let alert = testObject.presentedItem as? UIAlertController

        XCTAssertEqual(UITexts.PaymentError.paymentAlertTitle, alert?.title)
        XCTAssertEqual(UITexts.PaymentError.paymentAlertMessage, alert?.message)
    }
}
