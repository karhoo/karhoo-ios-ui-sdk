//
//  MockCardRegistrationFlow.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final public class MockCardRegistrationFlow: CardRegistrationFlow {

    public var setBaseViewControllerCalled = false
    public func setBaseView(_ baseViewController: BaseViewController?) {
        setBaseViewControllerCalled = true
    }

    public var startCalled = false
    public var currencyCodeSet: String?
    public var supplierPartnerIdSet: String?
    public var showUpdateCardAlertSet: Bool?
    public var amountSet: Int?
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?
    public func start(cardCurrency: String,
               amount: Int,
               supplierPartnerId: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        startCalled = true
        currencyCodeSet = cardCurrency
        showUpdateCardAlertSet = showUpdateCardAlert
        amountSet = amount
        supplierPartnerIdSet = supplierPartnerId
        self.callback = callback
    }

    public func triggerAddCardResult(_ result: OperationResult<CardFlowResult>) {
        callback?(result)
    }
}
