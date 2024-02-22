//
//  KarhooUISDKConfigurationProvider.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

enum KarhooUISDKConfigurationProvider {

    private(set) static var configuration: KarhooUISDKConfiguration!

    static func set(_ configuration: KarhooUISDKConfiguration) {
        self.configuration = configuration
    }
}
