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

final class MockCardRegistrationFlow: CardRegistrationFlow {

    private(set) var setBaseViewControllerCalled = false
    func setBaseView(_ baseViewController: BaseViewController?) {
        setBaseViewControllerCalled = true
    }

    private(set) var startCalled = false
    private(set) var currencyCodeSet: String?
    private(set) var showUpdateCardAlertSet: Bool?
    private(set) var amountSet: Int?
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?
    func start(cardCurrency: String,
               amount: Int,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        startCalled = true
        currencyCodeSet = cardCurrency
        showUpdateCardAlertSet = showUpdateCardAlert
        amountSet = amount
        self.callback = callback
    }

    func triggerAddCardResult(_ result: OperationResult<CardFlowResult>) {
        callback?(result)
    }
}
