//
//  UISDKSettings.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooUISDKConfigurationProvider {

    private(set) static var configuration: KarhooUISDKConfiguration!

    private init() {}

    static func set(_ configuration: KarhooUISDKConfiguration) {
        self.configuration = configuration
    }
}
