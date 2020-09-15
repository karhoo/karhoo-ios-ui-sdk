//
//  AdyenCardRegistrationFlow.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Adyen
import KarhooSDK

//TODO: verify if we can register a card without invoking a payment
final class AdyenCardRegistrationFlow: CardRegistrationFlow {

    private weak var baseViewController: BaseViewController?
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?
    private let paymentService: PaymentService

    init(paymentService: PaymentService = Karhoo.getPaymentService()) {
        self.paymentService = paymentService
    }

    func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    func start(cardCurrency: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        baseViewController?.showLoadingOverlay(true)
        self.callback = callback
        let request = AdyenPaymentMethodsRequest()
        paymentService.adyenPaymentMethods(request: request).execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)
            switch result {
            case .success(let result):
                self?.startDropIn(data: result.data, currency: cardCurrency)
            case .failure(let error): callback(.completed(value: .didFailWithError(error)))
            }
        })
    }

    private func startDropIn(data: Data, currency: String) {
        let paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data)
        let configuration = DropInComponent.PaymentMethodsConfiguration()
        configuration.card.publicKey = "..."

        guard let methods = paymentMethods else {
            finish(result: .completed(value: .didFailWithError(nil)))
            return
        }

        let dropInComponent = DropInComponent(paymentMethods: methods,
                                              paymentMethodsConfiguration: configuration)
        dropInComponent.delegate = self
        dropInComponent.environment = .test

        dropInComponent.payment = Payment(amount: Payment.Amount(value: 0,
                                                                 currencyCode: currency))

        baseViewController?.present(dropInComponent.viewController, animated: true)
    }

    private func finish(result: OperationResult<CardFlowResult>) {

    }
}

extension AdyenCardRegistrationFlow: DropInComponentDelegate {

    func didSubmit(_ data: PaymentComponentData, from component: DropInComponent) {
    }

    func didProvide(_ data: ActionComponentData, from component: DropInComponent) {
    }

    func didFail(with error: Error, from component: DropInComponent) {
    }

}
