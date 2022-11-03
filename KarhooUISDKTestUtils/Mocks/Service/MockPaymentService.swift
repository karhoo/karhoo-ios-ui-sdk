//
//  MockPaymentService.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

public class MockPaymentService: PaymentService {

    public var getNonceCalled = false
    public var getNoncePayloadSet: NonceRequestPayload?
    public let getNonceCall = MockCall<Nonce>()
    public func getNonce(nonceRequestPayload: NonceRequestPayload) -> Call<Nonce> {
        getNonceCalled = true
        getNoncePayloadSet = nonceRequestPayload
        return getNonceCall
    }

    public let addPaymentDetailsCall = MockCall<Nonce>()
    public var addPaymentDetailsPayloadSet: AddPaymentDetailsPayload?
    public func addPaymentDetails(addPaymentDetailsPayload: AddPaymentDetailsPayload) -> Call<Nonce> {
        addPaymentDetailsPayloadSet = addPaymentDetailsPayload
        return addPaymentDetailsCall
    }

    public let paymentSDKTokenCall = MockCall<PaymentSDKToken>()
    public var initialisePaymentSDKCalled = false
    public var paymentSDKTokenPayloadSet: PaymentSDKTokenPayload?
    public func initialisePaymentSDK(paymentSDKTokenPayload: PaymentSDKTokenPayload) -> Call<PaymentSDKToken> {
        initialisePaymentSDKCalled = true
        paymentSDKTokenPayloadSet = paymentSDKTokenPayload
        return paymentSDKTokenCall
    }

    public let paymentProviderCall = MockCall<PaymentProvider>()
    public func getPaymentProvider() -> Call<PaymentProvider> {
        paymentProviderCall
    }

    public let adyenPayment = MockCall<AdyenPayments>()
    public func adyenPayments(request: AdyenPaymentsRequest) -> Call<AdyenPayments> {
        adyenPayment
    }

     public let adyenPaymentDetails = MockCall<DecodableData>()
    public func getAdyenPaymentDetails(paymentDetails: PaymentsDetailsRequestPayload) -> Call<DecodableData> {
        return adyenPaymentDetails
    }

    public let adyenPublicKey = MockCall<AdyenPublicKey>()
    public func getAdyenPublicKey() -> Call<AdyenPublicKey> {
        adyenPublicKey
    }

    public let adyenClientKey = MockCall<AdyenClientKey>()
    public func getAdyenClientKey() -> Call<AdyenClientKey> {
        adyenClientKey
    }

    public let adyenPaymentMethodsCall = MockCall<DecodableData>()
    public var adyenPaymentMethodsCalled = false
    public var adyenPaymentMethodsRequest: AdyenPaymentMethodsRequest?
    public func adyenPaymentMethods(request: AdyenPaymentMethodsRequest) -> Call<DecodableData> {
        adyenPaymentMethodsCalled = true
        adyenPaymentMethodsRequest = request
        return adyenPaymentMethodsCall
    }
}
