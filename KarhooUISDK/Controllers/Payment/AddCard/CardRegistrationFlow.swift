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
               amount: Int,
               supplierPartnerId: String,
               showUpdateCardAlert: Bool,
               dropInAuthenticationToken: PaymentSDKToken?, // used only in Braintree
               callback: @escaping (OperationResult<CardFlowResult>) -> Void)
}

public enum CardFlowResult {
    case didAddPaymentMethod(nonce: Nonce)
    case didFailWithError(_ error: KarhooError?)
    case cancelledByUser
}
