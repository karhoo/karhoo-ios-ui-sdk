//
// Created by Bartlomiej Sopala on 06/05/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol PSPCore {
    func getCardFlow() -> CardRegistrationFlow
    func getNonceProvider() -> PaymentNonceProvider
}
