//
//  KarhooUISDKConfiguration.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

public let karhooUiSdkVersion = "1.12.1"

public protocol KarhooUISDKConfiguration: KarhooSDKConfiguration {
    func logo() -> UIImage

    func analytics() -> Analytics

    var isExplicitTermsAndConditionsConsentRequired: Bool { get }

    var bookingMetadata: [String: Any]? { get }
    
    var paymentManager: PaymentManager { get }

    /// Return `true` if you want `Karhoo UISDK` to use `Add to calendar` feature, allowing users to add scheduled ride to the device main calendar. This feature required host app’s `info.plist` to have `Privacy - Calendars Usage Description` marked as used. If you do not want to modify your `info.plist`, or you don’t want user to see this feature, return `false`.
    var useAddToCalendarFeature: Bool { get }
}

public extension KarhooUISDKConfiguration {

    func logo() -> UIImage { UIImage(named: "")! }

    func analytics() -> Analytics {
        KarhooAnalytics()
    }

    var isExplicitTermsAndConditionsConsentRequired: Bool { false }
    
    var bookingMetadata: [String: Any]? { nil }
}
