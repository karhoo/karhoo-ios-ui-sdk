//
//  Bundle+Utils.swift
//  KarhooUISDK
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation

extension Bundle {
    public static var current: Bundle {
        if let bundlePath = Bundle(for: KarhooUI.self).path(forResource: "KarhooUISDK", ofType: "bundle") {
            return Bundle(path: bundlePath)!
        } else {
            return Bundle(for: KarhooUI.self)
        }
    }
}
