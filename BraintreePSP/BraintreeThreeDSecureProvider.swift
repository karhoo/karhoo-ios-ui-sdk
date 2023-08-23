//
//  BraintreeThreeDSecureProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK // Even if the import may not be required in some configurations, it is needed for SPM linking. Do not remove unless you are sure a new solution allowes SPM-based project/app to be compiled.
#if canImport(Braintree)
import Braintree
#endif
#if canImport(BraintreeThreeDSecure)
import BraintreeThreeDSecure
#endif

final class BraintreeThreeDSecureProvider: NSObject, ThreeDSecureProvider, BTViewControllerPresentingDelegate {

    private let paymentService: PaymentService
    private var paymentFlowDriver: BTPaymentFlowDriver?
    private let userService: UserService
    private var baseViewController: BaseViewController?
    private var resultCallback: ((OperationResult<ThreeDSecureCheckResult>) -> Void)?

    init(
        paymentService: PaymentService = Karhoo.getPaymentService(),
        userService: UserService = Karhoo.getUserService()
    ) {
        self.paymentService = paymentService
        self.userService = userService
    }

    func set(baseViewController: BaseViewController) {
        self.baseViewController = baseViewController
    }

    func threeDSecureCheck(
        authToken: PaymentSDKToken,
        nonce: String,
        currencyCode: String,
        paymentAmount: NSDecimalNumber,
        callback: @escaping (OperationResult<ThreeDSecureCheckResult>) -> Void
    ) {
        self.resultCallback = callback
        
        start3DSecureCheck(authToken: authToken, nonce: nonce, amount: paymentAmount)
    }

    private func start3DSecureCheck(
        authToken: PaymentSDKToken,
        nonce: String,
        amount: NSDecimalNumber
    ) {
        guard let apiClient = BTAPIClient(authorization: authToken.token) else {
            return
        }

        paymentFlowDriver = BTPaymentFlowDriver(apiClient: apiClient)
        paymentFlowDriver?.viewControllerPresentingDelegate = self

        let request = BTThreeDSecureRequest()
        request.nonce = nonce
        request.versionRequested = .version2
        request.threeDSecureRequestDelegate = self

        let decimalNumberHandler = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        request.amount = amount.rounding(accordingToBehavior: decimalNumberHandler)
        paymentFlowDriver?.startPaymentFlow(request) { [weak self] (result, error) in
            if error?._code == BTPaymentFlowDriverErrorType.canceled.rawValue {
                self?.resultCallback?(.cancelledByUser)
                return
            }

            guard let result = result as? BTThreeDSecureResult else {
                self?.resultCallback?(.completed(value: .threeDSecureAuthenticationFailed))
                return
            }

            self?.threeDSecureResponseHandler(result: result)
        }
    }

    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        baseViewController?.present(viewController, animated: true, completion: nil)
    }
}

extension BraintreeThreeDSecureProvider: BTThreeDSecureRequestDelegate {
    func onLookupComplete(
        _ request: BTThreeDSecureRequest,
        lookupResult result: BTThreeDSecureResult,
        next: @escaping () -> Void
    ) {
        next()
    }


    func onLookupComplete(
        _ request: BTThreeDSecureRequest,
        result: BTThreeDSecureLookup,
        next: @escaping () -> Void
    ) {
        next()
    }

    private func threeDSecureResponseHandler(result: BTThreeDSecureResult) {
        if result.tokenizedCard?.nonce != nil {
            resultCallback?(.completed(value: .success(nonce: result.tokenizedCard?.nonce ?? "")))
        } else {
            resultCallback?(.completed(value: .threeDSecureAuthenticationFailed))
        }
    }
}

