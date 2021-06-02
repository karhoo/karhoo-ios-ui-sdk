//
//  KarhooUISDKConfiguration.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol KarhooUISDKConfiguration: KarhooSDKConfiguration {
    func logo() -> UIImage
    
    func bookingMetadata() -> [String: Any]
}

public extension KarhooUISDKConfiguration {

    func logo() -> UIImage {
        return UIImage(named: "")!
    }
    
    func bookingMetadata() -> [String: Any] {
        [:]
    }
}
