//
//  KarhooInputViewError.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

enum KarhooTextInputViewState {
    case inactive, active, error
    
    var color: UIColor {
        switch self {
        case .inactive:
            return KarhooUI.colors.lightGrey
        case .active:
            return KarhooUI.colors.primary
        case .error:
            return .red
        }
    }
}
