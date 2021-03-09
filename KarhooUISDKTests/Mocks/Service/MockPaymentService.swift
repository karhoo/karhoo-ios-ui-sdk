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

class MockPaymentService: PaymentService {

    private(set) var getNonceCalled = false
    private(set) var getNoncePayloadSet: NonceRequestPayload?
    let getNonceCall = MockCall<Nonce>()
    func getNonce(nonceRequestPayload: NonceRequestPayload) -> Call<Nonce> {
        getNonceCalled = true
        getNoncePayloadSet = nonceRequestPayload
        return getNonceCall
    }

    let addPaymentDetailsCall = MockCall<Nonce>()
    var addPaymentDetailsPayloadSet: AddPaymentDetailsPayload?
    func addPaymentDetails(addPaymentDetailsPayload: AddPaymentDetailsPayload) -> Call<Nonce> {
        addPaymentDetailsPayloadSet = addPaymentDetailsPayload
        return addPaymentDetailsCall
    }

    let paymentSDKTokenCall = MockCall<PaymentSDKToken>()
    private(set) var initialisePaymentSDKCalled = false
    private(set) var paymentSDKTokenPayloadSet: PaymentSDKTokenPayload?
    func initialisePaymentSDK(paymentSDKTokenPayload: PaymentSDKTokenPayload) -> Call<PaymentSDKToken> {
        initialisePaymentSDKCalled = true
        paymentSDKTokenPayloadSet = paymentSDKTokenPayload
        return paymentSDKTokenCall
    }

    let paymentProviderCall = MockCall<PaymentProvider>()
    func getPaymentProvider() -> Call<PaymentProvider> {
        return paymentProviderCall
    }

    let adyenPayment = MockCall<AdyenPayments>()
    func adyenPayments(request: AdyenPaymentsRequest) -> Call<AdyenPayments> {
        return adyenPayment
    }

    let adyenPaymentDetails = MockCall<DecodableData>()
    func getAdyenPaymentDetails(paymentDetails: PaymentsDetailsRequestPayload) -> Call<DecodableData> {
        return adyenPaymentDetails
    }

    let adyenPublicKey = MockCall<AdyenPublicKey>()
    func getAdyenPublicKey() -> Call<AdyenPublicKey> {
        return adyenPublicKey
    }

    let adyenPaymentMethodsCall = MockCall<DecodableData>()
    private(set) var adyenPaymentMethodsCalled = false
    private(set) var adyenPaymentMethodsRequest: AdyenPaymentMethodsRequest?
    func adyenPaymentMethods(request: AdyenPaymentMethodsRequest) -> Call<DecodableData> {
        adyenPaymentMethodsCalled = true
        adyenPaymentMethodsRequest = request
        return adyenPaymentMethodsCall
    }
}
