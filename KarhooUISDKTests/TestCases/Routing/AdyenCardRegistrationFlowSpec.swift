//
//  AdyenCardRegistrationFlowSpec.swift
//  KarhooUISDKTests
//
//  Created by Jeevan Thandi on 08/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDKTestUtils

#if SWIFT_PACKAGE
@testable import KarhooUISDKAdyen
#endif
@testable import KarhooSDK
@testable import KarhooUISDK

final class AdyenCardRegistrationFlowSpec: KarhooTestCase {

    private var testObject: AdyenCardRegistrationFlow!
    private var mockPaymentScreensBuilder: MockPaymentScreenBuilder!
    private var mockPaymentService: MockPaymentService!
    private var testAnalytics: MockAnalyticsService!
    private var mockBaseViewController = MockBaseViewController()
    private let mockUserService = MockUserService()
    private let amount = 10
    private let mockCardCurrencyCode = "GBP"
    private let mockSupplierPartnerId = "SPID"

    private var cardRegistrationFlowCompletionResult: CardFlowResult?
    private var cardRegistrationCancelledByUser: Bool?

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
        switch result {
        case .completed(let result): cardRegistrationFlowCompletionResult = result
        case .cancelledByUser: cardRegistrationCancelledByUser = true
        }
    }

    /**
      * Given: The flow starts
      * When: Currency and Amount is provided
      * Then: AdyenPaymentMethodsRequest is made with the correct payload
      */
    func testFlowStart() {
        simulateStartFlow()

        XCTAssert(mockPaymentService.adyenPaymentMethodsCalled)
        XCTAssertEqual(amount, mockPaymentService.adyenPaymentMethodsRequest?.amount?.value)
        XCTAssertEqual(mockCardCurrencyCode, mockPaymentService.adyenPaymentMethodsRequest?.amount?.currency)
    }

    private func simulateStartFlow() {
        testObject.start(cardCurrency: mockCardCurrencyCode,
                         amount: amount,
                         supplierPartnerId: mockSupplierPartnerId,
                         showUpdateCardAlert: true,
                         callback: cardRegistrationFlowCompletion)
        
        let result = KarhooSDK.DecodableData(data: Data())
        mockPaymentService.adyenPaymentMethodsCall.triggerResult(result: .success(result: result))
    }
}
