//
//  LoyalityMode.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/08/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

@available(*, deprecated, renamed: "KarhooLoyaltyError")
public typealias LoyaltyErrorType = KarhooLoyaltyError

public enum KarhooLoyaltyError: KarhooError {
    case none, insufficientBalance, unsupportedCurrency, unknownError
    
    var text: String {
        switch self {
        case .none:
            return ""
        case .insufficientBalance:
            return UITexts.Errors.insufficientBalanceForLoyaltyBurning
        case .unsupportedCurrency:
            return UITexts.Errors.unsupportedCurrency
        case .unknownError:
            return UITexts.Errors.unknownLoyaltyError
        }
    }

    var localizedMessage: String {
        text
    }
}

public enum LoyaltyMode: Equatable {
    case none
    case earn
    case burn
    case error(type: KarhooLoyaltyError)
    
    var isError: Bool {
        self == .error(type: .unsupportedCurrency) ||
        self == .error(type: .unknownError) ||
        self == .error(type: .insufficientBalance)
    }
    
    var isEligibleForPreAuth: Bool {
        switch self {
        case .none:
            return false
        case .earn, .burn:
            return true
        case .error(let type):
            switch type {
            // Note: When in error mode the component is considered to be in earn / none mode
            // (as far as the loyalty nonce retrival is concerned)
            // The error mode only prevents the user from burning points, not earning (when available)
            // .unsupportedCurrency is the only exception because the pre-auth call will always fail in this case
            case .unsupportedCurrency:
                return false
            default:
                return true
            }
        }
    }

    public static func != (lhs: LoyaltyMode, rhs: LoyaltyMode) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return false
        case (.earn, .earn):
            return false
        case (.burn, .burn):
            return false
        case (let .error(type1), let.error(type2)):
            return type1 != type2
        default:
            return true
        }
    }
}
