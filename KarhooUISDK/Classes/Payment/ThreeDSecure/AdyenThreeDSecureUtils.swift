//
//  AdyenThreeDSecureUtils.swift
//  KarhooSDK
//
//  Created by Mostafa Hadian on 04/03/2021.
//

import Foundation

public struct AdyenThreeDSecureUtils: ThreeDSecureUtils {
    public init() {}
    
    public var userAgent: String {
        return "KH/UISDK/iOS/\(KarhooUISDKVersionNumber)"
    }
    
    public var acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    
    public var current3DSReturnUrl: String {
        "\(current3DSReturnUrlScheme)://"
    }
    
    public var current3DSReturnUrlScheme: String {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return ""
        }

        return "\(bundleId).adyen"
    }

}
