//
//  AdyenResponseHandler.swift
//  KarhooUISDK
//
//  This class transforms adyen backend data into an event to progress the users payment trip
//  https://docs.adyen.com/online-payments/ios/drop-in#step-4-additional-client-app
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK
#if canImport(Adyen)
import Adyen
#endif
#if canImport(AdyenActions)
import AdyenActions
#endif


struct AdyenResponseHandler {

    let authorised = "Authorised"
    let refused = "Refused"
    let action = "action"
    let resultCode = "resultCode"
    let additionalData = "additionalData"
    let paymentMethod = "paymentMethod"
    let cardSummary = "cardSummary"
    let refusalReason = "refusalReason"

    enum AdyenEvent {
        case requiresAction(_ action: Action)
        case paymentAuthorised(_ method: Nonce)
        case refused(reason: String, code: String)
        case handleResult(code: String?)
        case failure
    }

    func nextStepFor(data: [String: Any], tripId: String) -> AdyenEvent {
        guard let adyenActionObject = data[action] as? [String: Any] else {
            return resolve(data: data, tripId: tripId)
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

    private func resolve(data: [String: Any], tripId: String) -> AdyenEvent {
        let result = data[resultCode] as? String ?? ""

        if result == authorised {
            let paymentData = data[additionalData] as? [String: Any]
            let lastFour = paymentData?[cardSummary] as? String ?? ""
            let icon = paymentIcon(adyenDescription: paymentData?[paymentMethod] as? String)

            let nonce = Nonce(nonce: tripId, cardType: icon, lastFour: lastFour)
            return .paymentAuthorised(nonce)
        }

        if result == refused {
            return .refused(reason: (data[refusalReason] as? String) ?? UITexts.Errors.noDetailsAvailable, code: (data[resultCode] as? String) ?? UITexts.Errors.noDetailsAvailable)
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
