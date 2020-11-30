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

final class AdyenCardRegistrationFlow: CardRegistrationFlow {

    private weak var baseViewController: BaseViewController?
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?
    private let paymentService: PaymentService
    private var adyenDropIn: DropInComponent?
    private var transactionId: String = ""
    private var amount: Int = 0
    private var currencyCode: String = ""
    private let adyenResponseHandler: AdyenResponseHandler
    private let paymentFactory: PaymentFactory

    private var adyenAmout: AdyenAmount {
        return AdyenAmount(currency: self.currencyCode, value: self.amount)
    }

    init(paymentService: PaymentService = Karhoo.getPaymentService(),
         adyenResponseHandler: AdyenResponseHandler = AdyenResponseHandler(),
         paymentFactory: PaymentFactory = PaymentFactory()) {
        self.paymentService = paymentService
        self.adyenResponseHandler = adyenResponseHandler
        self.paymentFactory = paymentFactory
    }

    func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    func start(cardCurrency: String,
               amount: Int,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        self.currencyCode = cardCurrency
        self.amount = amount
        self.callback = callback
        baseViewController?.showLoadingOverlay(true)

        let request = AdyenPaymentMethodsRequest(amount: adyenAmout)
        paymentService.adyenPaymentMethods(request: request).execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)
            switch result {
            case .success(let result):
                self?.getAdyenKey(dropInData: result.data)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            }
        })
    }

    private func getAdyenKey(dropInData: Data) {
        paymentService.getAdyenPublicKey().execute(callback: { [weak self] result in
            switch result {
            case .success(let result):
                self?.startDropIn(data: dropInData,
                                  adyenKey: result.key)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            }
        })
    }

    private var showStorePaymentMethod: Bool {
        switch Karhoo.configuration.authenticationMethod() {
        case .guest: return false
        case .tokenExchange: return false
        case .karhooUser: return true
        }
    }

    private func startDropIn(data: Data, adyenKey: String) {
        let paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data)

        let configuration = DropInComponent.PaymentMethodsConfiguration()
        configuration.card.publicKey = adyenKey
        configuration.card.showsStorePaymentMethodField = showStorePaymentMethod

        guard let methods = paymentMethods else {
            finish(result: .completed(value: .didFailWithError(nil)))
            return
        }

        adyenDropIn = DropInComponent(paymentMethods: methods,
                                      paymentMethodsConfiguration: configuration,
                                      style: DropInComponent.Style(tintColor: KarhooUI.colors.primary))
        adyenDropIn?.delegate = self
        adyenDropIn?.environment = paymentFactory.adyenEnvironment()
        adyenDropIn?.payment = Payment(amount: Payment.Amount(value: self.amount,
                                                              currencyCode: self.currencyCode))

        if let dropIn = adyenDropIn?.viewController {
            baseViewController?.present(dropIn, animated: true)
        }
    }

    private func finish(result: OperationResult<CardFlowResult>) {
        adyenDropIn?.viewController.dismiss(animated: true, completion: nil)
        self.callback?(result)
    }
}

extension AdyenCardRegistrationFlow: DropInComponentDelegate {

    func didSubmit(_ data: PaymentComponentData, from component: DropInComponent) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(data.paymentMethod.encodable)
            guard let adyenData = Utils.convertToDictionary(data: jsonData) else {
                finish(result: .completed(value: .didFailWithError(nil)))
                return
            }
            submitPayments(dropInJson: adyenData, storePaymentMethod: data.storePaymentMethod)
        } catch let error {
            adyenDropIn?.stopLoading()
            didFail(with: error, from: component)
        }
    }

    private func submitPayments(dropInJson: [String: Any], storePaymentMethod: Bool) {
        var adyenPayload = AdyenDropInPayload()
        adyenPayload.paymentMethod = dropInJson
        adyenPayload.amount = adyenAmout
        adyenPayload.additionalData = ["allow3DS2": "true"]
        adyenPayload.storePaymentMethod = storePaymentMethod

        let request = AdyenPaymentsRequest(paymentsPayload: adyenPayload,
                                           returnUrlSuffix: "")
        paymentService.adyenPayments(request: request).execute { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result):
                self.transactionId = result.transactionID
                let event = self.adyenResponseHandler.nextStepFor(data: result.payload,
                                                                  transactionId: result.transactionID)
                self.handle(event: event)
            case .failure(let error):
                self.finish(result: .completed(value: .didFailWithError(error)))
            }
        }
    }

    func didProvide(_ data: ActionComponentData, from component: DropInComponent) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(data.details.encodable)
            guard var adyenData = Utils.convertToDictionary(data: jsonData) else {
                return
            }

            adyenData["paymentData"] = data.paymentData
            adyenData["details"] = adyenData
            submitAdyenPaymentDetails(payload: adyenData)
        } catch let error {
            adyenDropIn?.stopLoading()
            didFail(with: error, from: component)
        }
    }

    private func submitAdyenPaymentDetails(payload: [String: Any]) {
        let request = PaymentsDetailsRequestPayload(transactionID: self.transactionId,
                                                    paymentsPayload: payload)

        paymentService.getAdyenPaymentDetails(paymentDetails: request).execute(callback: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result):
                guard let detailsRespone = Utils.convertToDictionary(data: result.data) else {
                    self.finish(result: .completed(value: .didFailWithError(nil)))
                    return
                }

                let event = self.adyenResponseHandler.nextStepFor(data: detailsRespone,
                                                                   transactionId: self.transactionId)
                self.handle(event: event)
            case .failure(let error):
                self.finish(result: .completed(value: .didFailWithError(error)))
            }
        })
    }

    func didFail(with error: Error, from component: DropInComponent) {
        if let error = error as? ComponentError, error == .cancelled {
            finish(result: .completed(value: .cancelledByUser))
        } else {
            finish(result: .completed(value: .didFailWithError(error as? KarhooError)))
        }
    }

    private func handle(event: AdyenResponseHandler.AdyenEvent) {
        switch event {
        case .failure:
            finish(result: .completed(value: .didFailWithError(nil)))
        case .paymentAuthorised(let method):
            finish(result: .completed(value: .didAddPaymentMethod(method: method)))
        case .requiresAction(let action):
            adyenDropIn?.handle(action)
        case .refused(let reason):
            finish(result: .completed(value: .didFailWithError(ErrorModel(message: reason))))
        case .handleResult(let code):
            finish(result: .completed(value: .didFailWithError(ErrorModel(message: code ?? UITexts.Errors.noDetailsAvailable))))
        }
    }
}
