//
//  AdyenResponseHandler.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 07/10/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Adyen

struct AdyenResponseHandler {

    enum AdyenEvent {
        case requiresAction(_ action: Action)
        case paymentAuthorised(_ transactionId: String)
        case refused(_ reason: String)
        case handleResult(code: String?)
        case failure
    }

    func nextStepFor(data: [String: Any], transactionId: String) -> AdyenEvent {
        guard let adyenActionObject = data["action"] as? [String: Any] else {
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
        let result = data["resultCode"] as? String ?? ""

        if result == "Authorised" {
            return .paymentAuthorised(transactionId)
        }

        if result == "Refused" {
            return .refused("")
        }

        return .handleResult(code: result)
    }
}
