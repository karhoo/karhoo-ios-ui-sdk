//
//  BraintreeThreeDSecureProviderSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK

@testable import BraintreePSP
@testable import KarhooUISDK

final class BraintreeThreeDSecureProviderSpec: XCTestCase {

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
      * When: 3DSecure check is started
      * And: The user is signed in (negation handled by UserStateObserver)
      * Then: Payment service should get sdk token
      */
    func testGetSDKToken() {
        testObject.threeDSecureCheck(nonce: "",
                                     currencyCode: currencyCode,
                                     paymentAmout: 10.0,
                                     callback: {_ in})

        XCTAssertTrue(mockPaymentService.initialisePaymentSDKCalled)
    }

    /**
     * Given: 3DSecure check is started
     * When: Payment service fails to init sdk token
     * Then: Callback should be called with expected error
     */
    func testGetSDKTokenFails() {
        let error = TestUtil.getRandomError()
        testObject.threeDSecureCheck(nonce: "",
                                     currencyCode: currencyCode,
                                     paymentAmout: 10.0,
                                     callback: { _ in
                                        self.callbackExpectation.fulfill()
                                        
        })

        mockPaymentService.paymentSDKTokenCall.triggerFailure(error)
        self.wait(for: [callbackExpectation], timeout: 1)
    }

    /**
     * Given: 3DSecure check is started
     * When: Payment service succeeds to init sdk token
     * Then: Callback should not be called
     */
    func testGetSDKTokenSuccess() {
        testObject.threeDSecureCheck(nonce: "",
                                     currencyCode: currencyCode,
                                     paymentAmout: 10.0,
                                     callback: { _ in
                                        XCTFail("not expecting callback")
        })

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
