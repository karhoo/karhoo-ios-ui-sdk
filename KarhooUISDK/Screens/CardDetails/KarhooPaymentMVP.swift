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

protocol PaymentView {
    func set(paymentMethod: PaymentMethod)
    func set(nonce: Nonce)
    func noPaymentMethod()
    var baseViewController: BaseViewController? { get }
    var quote: Quote? { get }
    var actions: PaymentViewActions? { get }
}
