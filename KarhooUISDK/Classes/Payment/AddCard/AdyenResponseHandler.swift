//
//  AdyenResponseHandler.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 07/10/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

/**
  * this class transforms adyen backend data into an event to progress the users payment journey *
  * https://docs.adyen.com/checkout/ios/drop-in#step-4-additional-client-app
 */
import Adyen

struct AdyenResponseHandler {

    let authorised = "Authorised"
    let refused = "Refused"
    let action = "action"
    let resultCode = "resultCode"
    let additionalData = "additionalData"
    let paymentMethod = "paymentMethod"
    let cardSummary = "cardSummary"
    
    enum AdyenEvent {
        case requiresAction(_ action: Action)
        case paymentAuthorised(_ method: PaymentMethod)
        case refused(_ reason: String)
        case handleResult(code: String?)
        case failure
    }

    func nextStepFor(data: [String: Any], transactionId: String) -> AdyenEvent {
        guard let adyenActionObject = data[action] as? [String: Any] else {
            return resolve(data: data, transactionId: transactionId)
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: adyenActionObject, options: []) else {
            return .failure
        }

        guard let adyenAction = try? JSONDecoder().decode(Action.self,
                                                          from: jsonData) else {
            return .failure
        }
        return .requiresAction(adyenAction)
    }

    private func resolve(data: [String: Any], transactionId: String) -> AdyenEvent {
        let result = data[resultCode] as? String ?? ""
        print("result data: \(data)")

        if result == authorised {
            let paymentData = data[additionalData] as? [String: Any]
            let lastFour = paymentData?[cardSummary] as? String ?? ""
            let icon = paymentIcon(adyenDescription: paymentData?[paymentMethod] as? String)

            let method = PaymentMethod(nonce: transactionId,
                                       nonceType: icon,
                                       paymentDescription: lastFour)

            print("Adding method: \(method)")
            
            return .paymentAuthorised(method)
        }

        if result == refused {
            return .refused("")
        }

        return .handleResult(code: result)
    }

    private func paymentIcon(adyenDescription: String?) -> String {
        switch adyenDescription {
        case "mc": return "MasterCard"
        case "visa": return "Visa"
        default: return ""
        }
    }
}
