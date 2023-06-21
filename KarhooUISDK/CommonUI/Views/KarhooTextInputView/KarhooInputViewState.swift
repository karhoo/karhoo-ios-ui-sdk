//
//  KarhooInputViewError.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

enum KarhooTextInputViewState {
    case inactive, active, error
    
    var color: UIColor {
        switch self {
        case .inactive:
            return KarhooUI.colors.textLabel
        case .active:
            return KarhooUI.colors.secondary
        case .error:
            return .red
        }
    }
}
