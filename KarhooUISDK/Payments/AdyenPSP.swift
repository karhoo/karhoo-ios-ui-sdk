//
// Created by Bartlomiej Sopala on 06/05/2022.
//

import Foundation

public class AdyenPSPCore: PSPCore {
    
    public init() {
        
    }

    public func getCardFlow() -> CardRegistrationFlow {
        return AdyenCardRegistrationFlow()
    }

    public func getNonceProvider() -> PaymentNonceProvider {
        return AdyenPaymentNonceProvider()
    }
}



public class BraintreePSPCore: PSPCore {

    public func getCardFlow() -> CardRegistrationFlow {
        return BraintreeCardRegistrationFlow()
    }

    public func getNonceProvider() -> PaymentNonceProvider {
        return BraintreePaymentNonceProvider()
    }
}
