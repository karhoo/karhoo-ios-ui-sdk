//
//  UIStatusBarStyle+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 29/03/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import UIKit

extension UIStatusBarStyle {

    static var getPrimaryStyle: UIStatusBarStyle {
        switch KarhooUI.colors.primary.isLight {
        case true: return .darkContent
        case false: return .lightContent
        }
    }
}
