//
//  KarhooPaymentMVP.swift
//  Analytics
//
//

import Foundation
import KarhooSDK

//protocol AddPaymentViewDelegate {
//    func didGetNonce(nonce: Nonce)
//}

protocol AddPaymentPresenter {
    func updateCardPressed(showRetryAlert: Bool)
    func setQuote(_ quote: Quote)
}

protocol AddPaymentView: BaseView {
    func set(nonce: Nonce)
    func noPaymentMethod()
    func startRegisterCardFlow(showRetryAlert: Bool)
    var baseViewController: BaseViewController? { get set }
    var quote: Quote? { get set }
//    var actions: AddPaymentViewDelegate? { get set }
}
