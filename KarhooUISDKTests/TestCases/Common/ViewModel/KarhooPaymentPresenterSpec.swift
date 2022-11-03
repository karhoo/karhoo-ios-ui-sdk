//
//  KarhooPaymentPresenterSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class KarhooPaymentPresenterSpec: KarhooTestCase {

    private var testObject: KarhooAddPaymentPresenter!
    private var mockAnalytics = MockAnalytics()
    private var mockUserService = MockUserService()
    private var mockView = MockKarhooPaymentView()
    private var mockCardRegistrationFlow = MockCardRegistrationFlow()

    override func setUp() {
        super.setUp()
        loadTestObject()
    }

    private func loadTestObject(user: UserInfo? = nil,
                                quote: Quote? = TestUtil.getRandomQuote()) {
        mockUserService.currentUserToReturn = user
        mockView.quote = TestUtil.getRandomQuote()

        testObject = KarhooAddPaymentPresenter(
            analytics: mockAnalytics,
            userService: mockUserService,
            cardRegistrationFlow: mockCardRegistrationFlow,
            view: mockView,
            quote: quote
        )
    }

    /**
     When: The current user has no associated nonce
     Then: View should set up in a blank state
     */
    func testNoPaymentMethodForUserSet() {
        loadTestObject(user: TestUtil.getRandomUser(nonce: nil))

        XCTAssertTrue(mockView.noPaymentMethodCalled)
    }

    func testUserPaymentNonceSet() {
        let userWithNonce = TestUtil.getRandomUser(nonce: Nonce())
        loadTestObject(user: userWithNonce)

        XCTAssertEqual(userWithNonce.nonce, mockView.nonceSet)
    }

    /**
     When: user intends to change their payment method
     Then: The card registration flow should start
     */
    func testCardRegistrationFlowStarted() {
        testObject.updateCardPressed(showRetryAlert: false)

        XCTAssertTrue(mockCardRegistrationFlow.setBaseViewControllerCalled)
        XCTAssertEqual("GBP", mockCardRegistrationFlow.currencyCodeSet)
    }

    /**
     When: a preauth has failed or there was an error with the previous card
     Then: The card registration flow should start
     And:  Cardflow should show force update alert
     */
    func testForceReryCardFlowStart() {
        testObject.updateCardPressed(showRetryAlert: true)
        XCTAssertTrue(mockCardRegistrationFlow.showUpdateCardAlertSet!)
    }

    /**
     When: I've added a card as a guest
     Then: I should get a payment method
     And: View should set up with the registered payment method
     */
    func testCardRegistrationFlowFinishedAsGuest() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: TestUtil.getRandomGuestSettings())
        KarhooUI.set(configuration: KarhooTestConfiguration())

        testObject.updateCardPressed(showRetryAlert: false)
        let paymentMethodAdded = TestUtil.getRandomBraintreePaymentMethod()
        mockCardRegistrationFlow.triggerAddCardResult(
            .completed(value: .didAddPaymentMethod(nonce: paymentMethodAdded)))

        XCTAssertEqual(paymentMethodAdded, mockView.nonceSet)

        KarhooTestConfiguration.authenticationMethod = .karhooUser
        KarhooUI.set(configuration: KarhooTestConfiguration())
    }

    /**
     When: I've added a card as a user
     And: User nonce is updated
     And: user service should update nonce and view updates nonce
     */
    func testCardRegistrationFlowFinishedAsUser() {
        testObject.updateCardPressed(showRetryAlert: false)
        let paymentMethodAdded = TestUtil.getRandomBraintreePaymentMethod()
        mockCardRegistrationFlow.triggerAddCardResult(
            .completed(value: .didAddPaymentMethod(nonce: paymentMethodAdded)))

        let updatedUser = TestUtil.getRandomUser(nonce: Nonce(nonce: "some_nonce"))
        mockUserService.currentUserToReturn = updatedUser
        mockUserService.triggerUserStateChange(user: updatedUser)

        XCTAssertEqual("some_nonce", mockView.nonceSet!.nonce)
    }

    /**
     When There's no quote currency
     Then Card flow should not start
     */
    func testNoQuoteCurrencyCodeAvailable() {
        loadTestObject(quote: nil)
        XCTAssertNil(mockCardRegistrationFlow.currencyCodeSet)
    }

    /**
     * Given: SendChangeButtonPressed is invoked
     * Then: Analytics Service should send the correct event
     */
    func testCorrectEventIsSent() {
        testObject.updateCardPressed(showRetryAlert: false)
        XCTAssertTrue(mockAnalytics.changePaymentDetailsCalled)
    }
}
