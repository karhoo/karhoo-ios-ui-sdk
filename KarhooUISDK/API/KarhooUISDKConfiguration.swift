//
//  KarhooUISDKConfiguration.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

public protocol KarhooUISDKConfiguration: KarhooSDKConfiguration {
    func logo() -> UIImage

    func analytics() -> Analytics

    var isExplicitTermsAndConditionsConsentRequired: Bool { get }

    var bookingMetadata: [String: Any]? { get }
}

public extension KarhooUISDKConfiguration {

    func logo() -> UIImage { UIImage(named: "")! }

    func analytics() -> Analytics {
        KarhooAnalytics()
    }

    var isExplicitTermsAndConditionsConsentRequired: Bool { false }
    
    var bookingMetadata: [String: Any]? { nil }
}
