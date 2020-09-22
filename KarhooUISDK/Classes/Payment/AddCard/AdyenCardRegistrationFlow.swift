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
    private var adyenDropIn: DropInComponent?

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
                self?.getAdyenKey(dropInData: result.data, currency: cardCurrency)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            }
        })
    }

    private func getAdyenKey(dropInData: Data, currency: String) {
        paymentService.getAdyenPublicKey().execute(callback: { [weak self] result in
            switch result {
            case .success(let result):
                self?.startDropIn(data: dropInData,
                                  currency: currency,
                                  adyenKey: result.key)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            }
        })
    }

    private func startDropIn(data: Data, currency: String, adyenKey: String) {
        let paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data)
        let configuration = DropInComponent.PaymentMethodsConfiguration()
        configuration.card.publicKey = adyenKey

        guard let methods = paymentMethods else {
            finish(result: .completed(value: .didFailWithError(nil)))
            return
        }

        adyenDropIn = DropInComponent(paymentMethods: methods,
                                      paymentMethodsConfiguration: configuration)
        adyenDropIn?.delegate = self
        adyenDropIn?.environment = .test

        adyenDropIn?.payment = Payment(amount: Payment.Amount(value: 0,
                                                                 currencyCode: currency))
        if let dropIn = adyenDropIn?.viewController {
            baseViewController?.present(dropIn, animated: true)
        }
    }

    private func finish(result: OperationResult<CardFlowResult>) {
        self.callback?(result)
    }
}

extension AdyenCardRegistrationFlow: DropInComponentDelegate {

    func didSubmit(_ data: PaymentComponentData, from component: DropInComponent) {
        print("adyen didSubmit ", data, component)
    }

    func didProvide(_ data: ActionComponentData, from component: DropInComponent) {
        print("adyen didProvide", data, component)
    }

    func didFail(with error: Error, from component: DropInComponent) {
        print("didFail", error, component)
        adyenDropIn?.viewController.dismiss(animated: true, completion: nil)
    }
}
