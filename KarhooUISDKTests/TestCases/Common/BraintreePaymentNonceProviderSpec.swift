//
//  KarhooBookTripHandlerSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooUISDKTestUtils

#if SWIFT_PACKAGE
@testable import KarhooUISDKBraintree
#endif
@testable import KarhooSDK
@testable import KarhooUISDK

final class BraintreePaymentNonceProviderSpec: KarhooTestCase {

    private var testObject: BraintreePaymentNonceProvider!

    private let mockUserService = MockUserService()
    private let mockTripService = MockTripService()
    private let mockPaymentService = MockPaymentService()
    private let callbackExpectation = XCTestExpectation(description: "callback called")
    private let mockThreeDSecureProvider = MockThreeDSecureProvider()
    private let mockCardRegistrationFlow = MockCardRegistrationFlow()
    private let userInAnOrg: UserInfo = TestUtil.getRandomUser(inOrganisation: true)
    private let mockOrganisation = "OrgId"
    private let mockQuote = TestUtil.getRandomQuote()
    private var mockBaseView = MockBaseViewController()
    private var getNonceResult: PaymentNonceProviderResult?
    private var getNonceCancelledByUser: Bool?

    override func setUp() {
        super.setUp()

        mockUserService.currentUserToReturn = userInAnOrg
        testObject = BraintreePaymentNonceProvider(
            paymentService: mockPaymentService,
            threeDSecureProvider: mockThreeDSecureProvider,
            cardRegistrationFlow: mockCardRegistrationFlow
        )
        testObject.set(baseViewController: mockBaseView)
    }

    private func getPaymentNonceResult(operationResult: OperationResult<PaymentNonceProviderResult>) {
        switch operationResult {
        case .completed(let result): getNonceResult = result
        case .cancelledByUser: getNonceCancelledByUser = true
        }
    }

    private func loadTestObject() {
        testObject.getPaymentNonce(
            user: userInAnOrg,
            organisationId: mockOrganisation,
            quote: mockQuote,
            result: getPaymentNonceResult
        )
    }
    
    /**
      * When: Setting base view
      * Then: Base view should be set on three d secure provider and card registration flow
      */
    func testSetBaseView() {
        testObject.set(baseViewController: mockBaseView)

        XCTAssertTrue(mockThreeDSecureProvider.setBaseViewControllerCalled)
        XCTAssertTrue(mockCardRegistrationFlow.setBaseViewControllerCalled)
    }
    
    /**
      * Given: Getting a nonce
      * When: intialise payment SDK succeeds
      * Then: Get nonce should NOT be called on payment service
      */
    func testSDKInitSuccess() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))

        XCTAssertFalse(mockPaymentService.getNonceCalled)
    }

    /**
     * Given: Getting a nonce
     * When: intialise payment SDK fails
     * Then: Callback should be called with expected result
     */
    func testSDKInitFail() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerFailure(TestUtil.getRandomError())

        guard case .failedToInitialisePaymentService? = getNonceResult else {
            XCTFail("wrong result")
            return
        }
    }

    /**
     * When: Getting a nonce
      * And: Get nonce fails
     * Then: Add new card flow should start
      */
    func testGetNonceFails() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))

        mockPaymentService.getNonceCall.triggerFailure(TestUtil.getRandomError())

        XCTAssertTrue(mockCardRegistrationFlow.startCalled)
    }

    /**
     * Given: Adding a card
     * When: Add card succeeds
     * Then: ThreeDSecure check should be done on nonce from added card
     */
    func testAddCardSuccess() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))
        mockPaymentService.getNonceCall.triggerFailure(TestUtil.getRandomError())
        mockBaseView.selectUpdateCardOnAddCardAlert()

        let paymentAdded = TestUtil.getRandomBraintreePaymentMethod(nonce: "some_nonce")
        mockCardRegistrationFlow.triggerAddCardResult(.completed(value: .didAddPaymentMethod(nonce: paymentAdded)))

        XCTAssertEqual(mockThreeDSecureProvider.currencyCodeSet, mockQuote.price.currencyCode)
        XCTAssertEqual(mockThreeDSecureProvider.paymentAmountSet, NSDecimalNumber(value: mockQuote.price.highPrice))
        XCTAssertEqual(mockThreeDSecureProvider.nonceSet, "some_nonce")
    }

    /**
     * Given: Adding a card
     * And: Add card fails
     * Then: ThreeDSecure check should not be done
     * And: Callback should finish with expected result
     */
    func testAddCardFails() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))
        mockPaymentService.getNonceCall.triggerFailure(TestUtil.getRandomError())
        mockBaseView.selectUpdateCardOnAddCardAlert()
        mockCardRegistrationFlow.triggerAddCardResult(.completed(value: .didFailWithError(TestUtil.getRandomError())))

        XCTAssertNil(mockThreeDSecureProvider.currencyCodeSet)
        XCTAssertNil(mockThreeDSecureProvider.nonceSet)

        guard case .failedToAddCard? = getNonceResult else {
            XCTFail("unexpected result")
            return
        }
    }

    /**
     * When: Getting a nonce from a new card
     * And: Get nonce succeeds
     * Then: ThreeDSecure check should be done on nonce
     */
    func testGetNonceSuccess() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))
        
        let paymentAdded = TestUtil.getRandomBraintreePaymentMethod(nonce: "some_nonce")
        mockCardRegistrationFlow.triggerAddCardResult(.completed(value: .didAddPaymentMethod(nonce: paymentAdded)))
        
        XCTAssertEqual(mockThreeDSecureProvider.currencyCodeSet, mockQuote.price.currencyCode)
        XCTAssertEqual(mockThreeDSecureProvider.paymentAmountSet, NSDecimalNumber(value: mockQuote.price.highPrice))
        XCTAssertEqual(mockThreeDSecureProvider.nonceSet, "some_nonce")
    }

    /**
     * When: Getting a nonce
     * And: ThreeDSecure check fails
     * And: card registration flow should trigger so user can add new payment method
     */
    func testThreeDSecureCheckFails() {
        loadTestObject()

        mockPaymentService.paymentSDKTokenCall.triggerSuccess(PaymentSDKToken(token: "someToken"))
        mockPaymentService.getNonceCall.triggerSuccess(Nonce(nonce: "some_nonce"))
        mockThreeDSecureProvider.triggerResult(OperationResult.completed(value: .threeDSecureAuthenticationFailed))
        mockBaseView.selectUpdateCardOnAddCardAlert()

        XCTAssertEqual(mockCardRegistrationFlow.currencyCodeSet, mockQuote.price.currencyCode)
        XCTAssertTrue(mockCardRegistrationFlow.startCalled)
    }
}
