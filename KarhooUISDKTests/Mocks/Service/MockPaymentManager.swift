////
////  MockPaymentManager.swift
////  KarhooUISDKTests
////
////  Created by Aleksander Wedrychowski on 17/05/2022.
////  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
////
//
//import Foundation
//import KarhooSDK
//import KarhooUISDKTestUtils
//@testable import KarhooUISDK
//
//class MockPaymentManager: PaymentManager {
//
//    enum MockPaymentServicProviderType{
//        case adyen
//        case braintree
//    }
//
//    private let psp: MockPaymentServicProviderType
//
//    init(_ psp: MockPaymentServicProviderType){
//        self.psp = psp
//    }
//    var threeDSecureProviderMock = MockThreeDSecureProvider()
//    var threeDSecureProvider: ThreeDSecureProvider? {
//        threeDSecureProviderMock
//    }
//
//    var cardFlowMock = CardRegistrationFlowMock()
//    var cardFlow: CardRegistrationFlow {
//        cardFlowMock
//    }
//    var nonceProviderMock = PaymentNonceProviderMock()
//    var nonceProvider: PaymentNonceProvider {
//        nonceProviderMock
//    }
//    var shouldCheckThreeDSBeforeBooking: Bool {
//        switch psp {
//            case .adyen:
//                return false
//            case .braintree:
//                return true
//        }
//    }
//
//    var shouldGetPaymentBeforeBooking: Bool {
//        switch psp {
//        case .adyen:
//            return false
//        case .braintree:
//            return true
//        }
//    }
//
//    func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any] {
//        switch psp {
//        case .adyen:
//            var mutableMeta = meta
//            mutableMeta["trip_id"] = nonce
//            return mutableMeta
//        case .braintree:
//            return meta
//        }
//    }
//}
//
//class CardRegistrationFlowMock: CardRegistrationFlow {
//    private(set) var cardCurrencySet: String?
//    private(set) var amountSet: Int?
//    private(set) var supplierPartnerIdSet: String?
//    private(set) var showUpdateCardAlertSet: Bool?
//    private(set) var dropInAuthenticationTokenSet: KarhooSDK.PaymentSDKToken?
//    private(set) var callbackSet: ((KarhooUISDK.OperationResult<KarhooUISDK.CardFlowResult>) -> Void)?
//    private(set) var startCalled = false
//    func start(
//        cardCurrency: String,
//        amount: Int,
//        supplierPartnerId: String,
//        showUpdateCardAlert: Bool,
//        dropInAuthenticationToken: KarhooSDK.PaymentSDKToken?,
//        callback: @escaping (KarhooUISDK.OperationResult<KarhooUISDK.CardFlowResult>) -> Void
//    ) {
//        cardCurrencySet = cardCurrency
//        amountSet = amount
//        supplierPartnerIdSet = supplierPartnerId
//        showUpdateCardAlertSet = showUpdateCardAlert
//        dropInAuthenticationTokenSet = dropInAuthenticationToken
//        callbackSet = callback
//        startCalled = true
//    }
//
//    var setBaseViewCalled = false
//    func setBaseView(_ baseViewController: BaseViewController?) {
//        setBaseViewCalled = true
//    }
//}
//
//class PaymentNonceProviderMock: PaymentNonceProvider {
//    var getPaymentNonceResult: OperationResult<PaymentNonceProviderResult> = .completed(
//        value: PaymentNonceProviderResult.nonce(
//            nonce: Nonce(nonce: "123", cardType: "456", lastFour: "0987")
//        )
//    )
//
//    func getPaymentNonce(
//        user: UserInfo,
//        organisationId: String,
//        quote: Quote,
//        result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
//    ) {
//        result(getPaymentNonceResult)
//    }
//
//    var setBaseViewControllerCalled = false
//    func set(baseViewController: BaseViewController) {
//        setBaseViewControllerCalled = true
//    }
//}
