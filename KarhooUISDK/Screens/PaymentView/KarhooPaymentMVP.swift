//
//  KarhooPaymentMVP.swift
//  Analytics
//
//

import Foundation
import KarhooSDK

protocol PaymentViewActions {
    func didGetNonce(nonce: String)
}

protocol PaymentPresenter {
    func updateCardPressed(showRetryAlert: Bool)
}

protocol PaymentView: BaseView {
    func set(paymentMethod: PaymentMethod)
    func set(nonce: Nonce)
    func noPaymentMethod()
    func startRegisterCardFlow()
    var baseViewController: BaseViewController? { get set }
    var quote: Quote? { get }
    var actions: PaymentViewActions? { get }
}
