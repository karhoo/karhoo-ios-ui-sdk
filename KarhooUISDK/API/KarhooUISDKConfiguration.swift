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
    var isExplicitTermsAndConditionsConsentRequired: Bool { get }
    var bookingMetadata: [String: Any]? { get }
}

public extension KarhooUISDKConfiguration {

    func logo() -> UIImage { UIImage(named: "")! }

    var isExplicitTermsAndConditionsConsentRequired: Bool { false }
    
    var bookingMetadata: [String: Any]? { nil }
}
