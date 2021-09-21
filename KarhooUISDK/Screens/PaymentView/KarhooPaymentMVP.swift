//
//  KarhooPaymentMVP.swift
//  Analytics
//
//

import Foundation
import KarhooSDK

public protocol PaymentViewActions {
    func didGetNonce(nonce: String)
}

extension PaymentViewActions {
    func didGetNonce(nonce: String) {}
}

protocol PaymentPresenter {
    func updateCardPressed(showRetryAlert: Bool)
}

protocol PaymentView: BaseView {
    func set(paymentMethod: PaymentMethod)
    func set(nonce: Nonce)
    func noPaymentMethod()
    func startRegisterCardFlow(showRetryAlert: Bool)
    var baseViewController: BaseViewController? { get set }
    var quote: Quote? { get set }
    var actions: PaymentViewActions? { get set }
}
