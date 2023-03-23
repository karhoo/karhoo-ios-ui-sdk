//
//  MockPaymentManager.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 17/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

public class MockPaymentManager: PaymentManager {

    public enum MockPaymentServicProviderType{
        case adyen
        case braintree
    }
    
    private let psp: MockPaymentServicProviderType

    public init(_ psp: MockPaymentServicProviderType){
        self.psp = psp
    }
    public var threeDSecureProviderMock = MockThreeDSecureProvider()
    public var threeDSecureProvider: ThreeDSecureProvider? {
        threeDSecureProviderMock
    }
    
    public var cardFlowMock = CardRegistrationFlowMock()
    public var cardFlow: CardRegistrationFlow {
        cardFlowMock
    }
    public var nonceProviderMock = PaymentNonceProviderMock()
    public var nonceProvider: PaymentNonceProvider {
        nonceProviderMock
    }
    
    public func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any] {
        switch psp {
        case .adyen:
            var mutableMeta = meta
            mutableMeta["trip_id"] = nonce
            return mutableMeta
        case .braintree:
            return meta
        }
    }
}

public class CardRegistrationFlowMock: CardRegistrationFlow {
    public var setBaseViewCalled = false
    public func setBaseView(_ baseViewController: BaseViewController?) {
        setBaseViewCalled = true
    }
    
    public var startCalled = false
    public func start(cardCurrency: String, amount: Int, supplierPartnerId: String, showUpdateCardAlert: Bool, dropInAuthenticationToken: KarhooSDK.PaymentSDKToken?, callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        startCalled = true
    }
}

public class PaymentNonceProviderMock: PaymentNonceProvider {
    public var getPaymentNonceResult: OperationResult<PaymentNonceProviderResult> = .completed(
        value: PaymentNonceProviderResult.nonce(
            nonce: Nonce(nonce: "123", cardType: "456", lastFour: "0987")
        )
    )
        
    public func getPaymentNonce(
        user: UserInfo,
        organisationId: String,
        quote: Quote,
        result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    ) {
        result(getPaymentNonceResult)
    }

    public var setBaseViewControllerCalled = false
    public func set(baseViewController: BaseViewController) {
        setBaseViewControllerCalled = true
    }
}
