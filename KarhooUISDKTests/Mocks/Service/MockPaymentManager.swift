//
//  MockPaymentManager.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 17/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockPaymentManager: PaymentManager {
    var gerCardFlowMock = CardRegistrationFlowMock()
    var getCardFlow: CardRegistrationFlow {
        gerCardFlowMock
    }
    var getNonceProvider: PaymentNonceProvider {
        AdyenPaymentNonceProvider()
    }

    var shouldGetPaymentBeforeBookValue = false
    var shouldGetPaymentBeforeBook: Bool { shouldGetPaymentBeforeBookValue }
    
    var shouldCheckThreeDSBeforeBookValue = true
    var shouldCheckThreeDSBeforeBook: Bool { shouldCheckThreeDSBeforeBookValue }

    var getMetaWithUpdateTripIdIfRequiredValue = [String: Any]()
    func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any] {
        getMetaWithUpdateTripIdIfRequiredValue
    }
    
}

class CardRegistrationFlowMock: CardRegistrationFlow {
    var setBaseViewCalled = false
    func setBaseView(_ baseViewController: BaseViewController?) {
        setBaseViewCalled = true
    }
    
    var startCalled = false
    func start(cardCurrency: String, amount: Int, supplierPartnerId: String, showUpdateCardAlert: Bool, callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        startCalled = true
    }
}
