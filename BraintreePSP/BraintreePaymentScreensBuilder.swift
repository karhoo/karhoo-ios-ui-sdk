//
//  BraintreePaymentScreensBuilder.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK
#if canImport(BraintreeDropIn)
import BraintreeDropIn
#endif
#if canImport(Braintree)
import Braintree
#endif
#if canImport(BraintreePaymentFlow)
import BraintreePaymentFlow
#endif


final public class BraintreePaymentScreenBuilder: PaymentScreenBuilder {

    public init(){}

    public func buildAddCardScreen(
        allowToSaveCard: Bool,
        paymentsToken: PaymentSDKToken,
        paymentMethodAdded: ScreenResultCallback<Nonce>?,
        flowItemCallback: ScreenResultCallback<Screen>?
    ) {
        let request = BTDropInRequest()
        request.uiCustomization = getUiCustomization()
        if allowToSaveCard {
            request.allowVaultCardOverride = true
        } else {
            request.vaultCard = false
        }
        guard let flowItem = BTDropInController(
            authorization: paymentsToken.token,
            request: request,
            handler: {( _, result: BTDropInResult?, error: Error?) in
                if error != nil {
                    paymentMethodAdded?(.failed(error: error as? KarhooError))
                } else if result?.isCanceled == true {
                    paymentMethodAdded?(.cancelled(byUser: true))
                } else if let result = result, let method = result.paymentMethod{
                    let nonce = Nonce(nonce: method.nonce, cardType: method.type, lastFour: String(result.paymentDescription.suffix(2)))
                    paymentMethodAdded?(ScreenResult.completed(result: nonce))
                }
            }
        ) else {
            flowItemCallback?(.failed(error: nil))
            return
        }
        flowItemCallback?(.completed(result: flowItem))
    }
    
    private func getUiCustomization() -> BTDropInUICustomization {
        let uiCustomization = BTDropInUICustomization(colorScheme: .light)
        uiCustomization.primaryTextColor = KarhooUI.colors.text
        uiCustomization.secondaryTextColor = KarhooUI.colors.text
        uiCustomization.formBackgroundColor = KarhooUI.colors.background2
        uiCustomization.lineColor = KarhooUI.colors.border
        uiCustomization.navigationBarTitleTextColor = KarhooUI.colors.text
        uiCustomization.tintColor = KarhooUI.colors.secondary
        uiCustomization.errorForegroundColor = KarhooUI.colors.error
        uiCustomization.disabledColor = KarhooUI.colors.inactive
        uiCustomization.placeholderTextColor = KarhooUI.colors.textLabel
        uiCustomization.switchOnTintColor = KarhooUI.colors.secondary
        return uiCustomization
    }
}
