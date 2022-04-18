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
    private var tripId: String = ""
    private var amount: Int = 0
    private var currencyCode: String = ""
    private var supplierPartnerId: String = ""
    private let adyenResponseHandler: AdyenResponseHandler
    private let paymentFactory: PaymentFactory
    private let threeDSecureUtil: ThreeDSecureUtils

    private var adyenAmount: AdyenAmount {
         AdyenAmount(currency: currencyCode, value: amount)
    }

    init(paymentService: PaymentService = Karhoo.getPaymentService(),
         adyenResponseHandler: AdyenResponseHandler = AdyenResponseHandler(),
         paymentFactory: PaymentFactory = PaymentFactory(),
         threeDSecureUtil: ThreeDSecureUtils = AdyenThreeDSecureUtils()) {
        self.paymentService = paymentService
        self.adyenResponseHandler = adyenResponseHandler
        self.paymentFactory = paymentFactory
        self.threeDSecureUtil = threeDSecureUtil
    }

    func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    func start(cardCurrency: String,
               amount: Int,
               supplierPartnerId: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        currencyCode = cardCurrency
        self.amount = amount
        self.supplierPartnerId = supplierPartnerId
        self.callback = callback
        baseViewController?.showLoadingOverlay(true)

        let request = AdyenPaymentMethodsRequest(amount: adyenAmount, shopperLocale: UITexts.Generic.locale)
        paymentService.adyenPaymentMethods(request: request).execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)
            switch result {
            case .success(let result):
                self?.getAdyenKey(dropInData: result.data)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
            }
        })
    }

    private func getAdyenKey(dropInData: Data) {
        paymentService.getAdyenClientKey().execute(callback: { [weak self] result in
            switch result {
            case .success(let result):
                self?.showClientKey(result, dropInData: dropInData)
//                self?.startDropIn(data: dropInData, adyenKey: result.clientKey)
            case .failure(let error):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
            }
        })
    }
    
    private func showClientKey(_ result: AdyenClientKey, dropInData: Data) {
        let message = "Key: \(result.clientKey)\nEnvironment: \(result.environment)"
        let alert = UIAlertController.create(
            title: "Adyen Client Key",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.startDropIn(data: dropInData, adyenKey: result.clientKey)
        }))
        baseViewController?.present(alert, animated: true, completion: nil)
    }

    private var showStorePaymentMethod: Bool {
        switch Karhoo.configuration.authenticationMethod() {
        case .guest: return false
        case .tokenExchange: return false
        case .karhooUser: return true
        @unknown default:
            assertionFailure()
            return false
        }
    }

    private func startDropIn(data: Data, adyenKey: String) {
        let apiContext = APIContext(environment: paymentFactory.adyenEnvironment(), clientKey: adyenKey)
        let paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data)
        let configuration = DropInComponent.Configuration(apiContext: apiContext)
        configuration.card.showsStorePaymentMethodField = showStorePaymentMethod
        configuration.card.showsHolderNameField = true
        let countryCode = NSLocale.current.regionCode ?? "GB"
        configuration.payment = Payment(
            amount: Amount(value: amount, currencyCode: currencyCode),
            countryCode: countryCode
        )
        guard let methods = paymentMethods else {
            finish(result: .completed(value: .didFailWithError(nil)))
            return
        }
        let adyenDropInStyle = DropInComponent.Style(tintColor: KarhooUI.colors.secondary)

        adyenDropIn = DropInComponent(
            paymentMethods: methods,
            configuration: configuration,
            style: adyenDropInStyle
        )
        adyenDropIn?.delegate = self
        adyenDropIn?.viewController.forceLightMode()

        if let dropIn = adyenDropIn?.viewController {
            baseViewController?.present(dropIn, animated: true)
        }
    }

    private func finish(result: OperationResult<CardFlowResult>) {
        if let presentedViewController = adyenDropIn?.viewController.presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.closeAdyenDropIn(result: result)
            }
        } else {
            closeAdyenDropIn(result: result)
        }
    }
    
    private func closeAdyenDropIn(result: OperationResult<CardFlowResult>) {
        if let dropInViewController = adyenDropIn?.viewController {
            dropInViewController.dismiss(animated: true) { [weak self] in
                self?.callback?(result)
            }
        } else {
            callback?(result)
        }
    }
}

extension AdyenCardRegistrationFlow: DropInComponentDelegate {
    func didSubmit(
        _ data: PaymentComponentData,
        for paymentMethod: PaymentMethod,
        from component: DropInComponent
    ){
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(data.paymentMethod.encodable)
            guard let adyenData = Utils.convertToDictionary(data: jsonData) else {
                finish(result: .completed(value: .didFailWithError(nil)))
                return
            }
            submitPayments(dropInJson: adyenData, storePaymentMethod: data.storePaymentMethod)
        } catch let error {
            adyenDropIn?.stopLoadingIfNeeded()
            didFail(with: error, from: component)
        }
    }

    private func submitPayments(dropInJson: [String: Any], storePaymentMethod: Bool) {
        var adyenPayload = AdyenDropInPayload()
        adyenPayload.paymentMethod = dropInJson
        adyenPayload.amount = adyenAmount
        adyenPayload.additionalData = ["allow3DS2": "true"]
        adyenPayload.storePaymentMethod = storePaymentMethod
        adyenPayload.returnUrl = threeDSecureUtil.current3DSReturnUrl
        adyenPayload.browserInfo = AdyenBrowserInfo(
            userAgent: threeDSecureUtil.userAgent,
            acceptHeader: threeDSecureUtil.acceptHeader
        )
        let request = AdyenPaymentsRequest(paymentsPayload: adyenPayload, supplyPartnerID: supplierPartnerId)
        paymentService.adyenPayments(request: request).execute { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result):
                self.tripId = result.tripId
                let event = self.adyenResponseHandler.nextStepFor(data: result.payload,
                                                                  tripId: result.tripId)
                self.handle(event: event)
            case .failure(let error):
                self.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
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
            adyenDropIn?.stopLoadingIfNeeded()
            didFail(with: error, from: component)
        }
    }

    private func submitAdyenPaymentDetails(payload: [String: Any]) {
        let request = PaymentsDetailsRequestPayload(tripId: tripId,
                                                    paymentsPayload: payload)

        paymentService.getAdyenPaymentDetails(paymentDetails: request).execute(callback: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result):
                guard let detailsResponse = Utils.convertToDictionary(data: result.data) else {
                    self.finish(result: .completed(value: .didFailWithError(nil)))
                    return
                }

                let event = self.adyenResponseHandler.nextStepFor(data: detailsResponse,
                                                                  tripId: self.tripId)
                self.handle(event: event)
            case .failure(let error):
                self.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
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

    func didCancel(component: PaymentComponent, from dropInComponent: DropInComponent) {
        finish(result: .cancelledByUser)
    }
    func didComplete(from component: DropInComponent) { }

    private func handle(event: AdyenResponseHandler.AdyenEvent) {
        switch event {
        case .failure:
            finish(result: .completed(value: .didFailWithError(nil)))
        case .paymentAuthorised(let nonce):
            finish(result: .completed(value: .didAddPaymentMethod(nonce: nonce)))
        case .requiresAction(let action):
            adyenDropIn?.handle(action)
        case .refused(let reason, let code):
            finish(result: .completed(value: .didFailWithError(ErrorModel(message: reason, code: code))))
        case .handleResult(let code):
            finish(result: .completed(value: .didFailWithError(ErrorModel(message: code ?? UITexts.Errors.noDetailsAvailable, code: code ?? UITexts.Errors.noDetailsAvailable))))
        }
    }
}
