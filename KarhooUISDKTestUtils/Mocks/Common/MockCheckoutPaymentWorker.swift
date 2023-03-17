//
//  MockCheckoutPaymentWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 09/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

public class MockCheckoutPaymentWorker: CheckoutPaymentWorker {
    public init() {}

    public var quote: Quote?
    public var storedPaymentNonce: Nonce?
    public var paymentNonceResult: PaymentNonceProviderResult?
    public var requestNewPaymentMethodResult: () -> CardFlowResult = { .cancelledByUser }

    public var setupCalled = false
    public func setup(using quote: Quote) {
        setupCalled = true
        self.quote = quote
    }

    public func getStoredPaymentNonce() -> Nonce? {
        return storedPaymentNonce
    }

    public var getPaymentNonceResult = OperationResult<PaymentNonceProviderResult>.completed(value: .failedToInitialisePaymentService(error: ErrorModel.unknown()))
    public var getPaymentNonceCalled = false
    public func getPaymentNonce(
        organisationId: String,
        completion: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    ) {
        getPaymentNonceCalled = true
        completion(getPaymentNonceResult)
    }
    
    public func clearStoredPaymentNonce() {
        storedPaymentNonce = nil
    }

    public var requestNewPaymentMethodCalled = false
    public func requestNewPaymentMethod(
        showRetryAlert: Bool,
        addCardResultCompletion: @escaping (CardFlowResult) -> Void
    ) {
        requestNewPaymentMethodCalled = true
        addCardResultCompletion(requestNewPaymentMethodResult())
    }

    public var threeDSecureNonceCheckCalled = false
    public var threeDSSecureNonceCheckResult = OperationResult<ThreeDSecureCheckResult>.completed(value: .failedToInitialisePaymentService)
    public func threeDSecureNonceCheck(
        organisationId: String,
        passengerDetails: PassengerDetails,
        resultCompletion: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void
    ) {
        threeDSecureNonceCheckCalled = true
        resultCompletion(threeDSSecureNonceCheckResult)
    }
}
