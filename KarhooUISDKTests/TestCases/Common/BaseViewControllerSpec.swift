//
//  BaseViewSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDK

private class SomeBaseView: MockViewController, BaseViewController {}

final class BaseViewControllerSpec: XCTestCase {

    private let testObject = SomeBaseView()

    /**
      * When: Showing an alert
      * Then: Expected alert should show
      */
    func testShowAlert() {
        testObject.showAlert(title: "title", message: "message")

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

        XCTAssertEqual(UITexts.Errors.somethingWentWrong, alert?.title)
        XCTAssertEqual(someError.userMessage, alert?.message)
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
