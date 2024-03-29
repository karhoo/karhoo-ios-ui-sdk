//
//  BraintreeThreeDSecureProviderSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDKTestUtils
import XCTest

#if SWIFT_PACKAGE
@testable import KarhooUISDKBraintree
#endif
@testable import KarhooUISDK

final class BraintreeThreeDSecureProviderSpec: KarhooTestCase {

    private var testObject: BraintreeThreeDSecureProvider!
    private var mockPaymentService = MockPaymentService()
    private let mockBaseView: MockBaseViewController = MockBaseViewController()
    private let mockUserService: MockUserService = MockUserService()
    private let callbackExpectation = XCTestExpectation(description: "callback called")
    private let currencyCode = "GBP"

    override func setUp() {
        super.setUp()
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(inOrganisation: true)
        testObject = BraintreeThreeDSecureProvider(paymentService: mockPaymentService,
                                                   userService: mockUserService)
        testObject.set(baseViewController: mockBaseView)
    }

    /**
     * Given: 3DSecure check is started
     * When: Payment service succeeds to init sdk token
     * Then: Callback should not be called
     */
    func testGetSDKTokenSuccess() {
        testObject.threeDSecureCheck(
            authToken: PaymentSDKToken(token: ""),
            nonce: "",
            currencyCode: currencyCode,
            paymentAmount: 10.0,
            callback: { _ in
                XCTFail("not expecting callback")
            }
        )

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "some"))
    }

    /**
      * When: BTPaymentflow driver request view to show hide
      * Then: Views should show / dismiss accordingly
      */
    func testViewShowsAndDismisses() {
        let mockView = MockViewController()
        let any: Any = ""

        testObject.paymentDriver(any, requestsPresentationOf: mockView)
        XCTAssertEqual(mockBaseView.presentedView, mockView)

        testObject.paymentDriver(any, requestsDismissalOf: mockView)
        XCTAssertTrue(mockView.dismissCalled)
    }
}
