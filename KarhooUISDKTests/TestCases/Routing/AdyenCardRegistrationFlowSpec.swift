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

final class AdyenCardRegistrationFlowSpec: XCTestCase {

    private var testObject: AdyenCardRegistrationFlow!
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
        testObject = AdyenCardRegistrationFlow(paymentService: mockPaymentService)

        testObject.setBaseView(mockBaseViewController)
    }

    private func cardRegistrationFlowCompletion(result: OperationResult<CardFlowResult>) {
        self.capturedCardFlowResult = result
    }

    func testStartingDropIn() {
        
    }
}
