//
//  Bundle+Utils.swift
//  KarhooUISDK
//  Copyright © 2022 Karhoo. All rights reserved.
//


import Foundation

import UIKit
import Foundation

extension Bundle{
//    The Swift Package Manager creates a static extension on Bundle for the package module. You access the resource by specifying Bundle.module as the bundle.
    public static var current: Bundle {
        return .module
    }
}
