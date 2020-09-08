//
//  AdyenCardRegistrationFlowSpec.swift
//  KarhooUISDKTests
//
//  Created by Jeevan Thandi on 08/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

@testable import KarhooUISDK

//TODO: verify if we can register a card without invoking a payment
final class AdyenCardRegistrationFlowSpec: XCTestCase {

    private var testObject: KarhooCardRegistrationFlow!
    private var mockPaymentScreensBuilder: MockPaymentScreenBuilder!
    private var mockPaymentService: MockPaymentService!
    private var testAnalytics: MockAnalyticsService!
    private var mockBaseViewController = MockBaseViewController()
    private let mockUserService = MockUserService()
    private let mockCardCurrencyCode = "GBP"

    private var capturedCardFlowResult: OperationResult<CardFlowResult>?

    override func setUp() {
        super.setUp()
        mockPaymentScreensBuilder = MockPaymentScreenBuilder()
        mockPaymentService = MockPaymentService()
        testAnalytics = MockAnalyticsService()
        mockBaseViewController = MockBaseViewController()
        mockUserService.currentUserToReturn = TestUtil.getRandomUser(inOrganisation: true)
        testObject = KarhooCardRegistrationFlow(paymentScreenBuilder: mockPaymentScreensBuilder,
                                                paymentService: mockPaymentService,
                                                userService: mockUserService,
                                                analytics: testAnalytics)

        testObject.setBaseView(mockBaseViewController)
    }

    private func cardRegistrationFlowCompletion(result: OperationResult<CardFlowResult>) {
        self.capturedCardFlowResult = result
    }

    func testStartingDropIn() {
        
    }
}
