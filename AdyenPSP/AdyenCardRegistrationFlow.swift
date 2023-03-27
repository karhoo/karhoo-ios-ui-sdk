//
//  AdyenCardRegistrationFlow.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK
#if canImport(Adyen)
import Adyen
#endif
#if canImport(AdyenDropIn)
import AdyenDropIn
import AdyenActions
#endif


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
    private let threeDSecureUtil: ThreeDSecureUtils

    private var adyenAmount: AdyenAmount {
         AdyenAmount(currency: currencyCode, value: amount)
    }

    init(
        paymentService: PaymentService = Karhoo.getPaymentService(),
        adyenResponseHandler: AdyenResponseHandler = AdyenResponseHandler(),
        threeDSecureUtil: ThreeDSecureUtils = AdyenThreeDSecureUtils()
    ) {
        self.paymentService = paymentService
        self.adyenResponseHandler = adyenResponseHandler
        self.threeDSecureUtil = threeDSecureUtil
    }

    func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    func start(
        cardCurrency: String,
        amount: Int,
        supplierPartnerId: String,
        showUpdateCardAlert: Bool,
        dropInAuthenticationToken: PaymentSDKToken?,
        callback: @escaping (OperationResult<CardFlowResult>) -> Void
    ) {
        currencyCode = cardCurrency
        self.amount = amount
        self.supplierPartnerId = supplierPartnerId
        self.callback = callback
        baseViewController?.showLoadingOverlay(true)

        let request = AdyenPaymentMethodsRequest(amount: adyenAmount, shopperLocale: UITexts.Generic.locale)
        paymentService.adyenPaymentMethods(request: request).execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)
            switch result {
            case .success(let result, _):
                self?.getAdyenKey(dropInData: result.data)
            case .failure(let error, _):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
            }
        })
    }

    private func getAdyenKey(dropInData: Data) {
        paymentService.getAdyenClientKey().execute(callback: { [weak self] result in
            switch result {
            case .success(let result, _):
                self?.startDropIn(data: dropInData, adyenKey: result.clientKey)
            case .failure(let error, _):
                self?.finish(result: .completed(value: .didFailWithError(error)))
            @unknown default:
                assertionFailure()
            }
        })
    }

    private var showStorePaymentMethod: Bool {
        switch Karhoo.configuration.authenticationMethod() {
        case .guest: return false
        case .tokenExchange: return true
        case .karhooUser: return true
        @unknown default:
            assertionFailure()
            return false
        }
    }

    private func startDropIn(data: Data, adyenKey: String) {
        let apiContext = APIContext(environment: getAdyenEnvironment(), clientKey: adyenKey)
        let paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data)
        let configuration = DropInComponent.Configuration(apiContext: apiContext)
        configuration.card.showsStorePaymentMethodField = showStorePaymentMethod
        configuration.card.showsHolderNameField = true
        configuration.localizationParameters = LocalizationParameters(bundle: .current)
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
    
    private func getAdyenEnvironment() -> Adyen.Environment {
        switch Karhoo.configuration.environment() {
            case .production: return .live
            default: return .test
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
        let request = AdyenPaymentsRequest(
            paymentsPayload: adyenPayload,
            consentModeSupported: showStorePaymentMethod,
            supplyPartnerID: supplierPartnerId
        )
        paymentService.adyenPayments(request: request).execute { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result, _):
                self.tripId = result.tripId
                let event = self.adyenResponseHandler.nextStepFor(data: result.payload,
                                                                  tripId: result.tripId)
                self.handle(event: event)
            case .failure(let error, _):
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
            case .success(let result, _):
                guard let detailsResponse = Utils.convertToDictionary(data: result.data) else {
                    self.finish(result: .completed(value: .didFailWithError(nil)))
                    return
                }

                let event = self.adyenResponseHandler.nextStepFor(data: detailsResponse,
                                                                  tripId: self.tripId)
                self.handle(event: event)
            case .failure(let error, _):
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
            finish(result: .completed(value: .didFailWithError(
                ErrorModel(message: getRefusalMessage(forCode: code) ?? reason, code: code)
            )))
        case .handleResult(let code):
            let error = ErrorModel(
                message: code ?? UITexts.Errors.noDetailsAvailable,
                code: code ?? UITexts.Errors.noDetailsAvailable
            )
            finish(result: .completed(value: .didFailWithError(error)))
        }
    }

    private func getRefusalMessage(forCode code: String) -> String? {
        let translationPrefix = "kh_uisdk_adyen_payment_error_"
        let translationsKey = translationPrefix + code
        return translationsKey.localized != translationsKey ? translationsKey.localized : nil
    }
}
