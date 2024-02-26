//
//  Bundle+current.swift
//  KarhooUISDK
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    public static var current: Bundle {
        if let bundlePath = Bundle(for: KarhooUI.self).path(forResource: "KarhooUISDKResource", ofType: "bundle") {
            return Bundle(path: bundlePath)!
        } else {
            return Bundle(for: KarhooUI.self)
        }
    }
}
