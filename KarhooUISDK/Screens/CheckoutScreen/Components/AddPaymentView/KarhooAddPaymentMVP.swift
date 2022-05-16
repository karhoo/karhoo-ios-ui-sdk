//
//  KarhooPaymentMVP.swift
//  Analytics
//
//

import Foundation
import KarhooSDK

protocol AddPaymentViewDelegate {
    func didGetNonce(nonce: Nonce)
}

protocol AddPaymentPresenter {
    func updateCardPressed(showRetryAlert: Bool)
}

protocol AddPaymentView: BaseView {
    func set(nonce: Nonce)
    func noPaymentMethod()
    func startRegisterCardFlow(showRetryAlert: Bool)
    var baseViewController: BaseViewController? { get set }
    var quote: Quote? { get set }
    var actions: AddPaymentViewDelegate? { get set }
}
