//
//  CardRegistrationFlow.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 21/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol CardRegistrationFlow {
    func setBaseView(_ baseViewController: BaseViewController?)
    func start(cardCurrency: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void)
    var amount: Int { get set }
}

public extension CardRegistrationFlow {
    var amount: Int {
        get {
            return 0
        }
        set {}
    }
}

public enum CardFlowResult {
    case didAddPaymentMethod(method: PaymentMethod)
    case didFailWithError(_ error: KarhooError?)
    case cancelledByUser
}
