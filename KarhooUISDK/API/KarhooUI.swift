//
//  KarhooUI.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public final class KarhooUI {

    public static var colors: KarhooColors = DefaultKarhooColors()
    public static var sideMenuHandler: SideMenuHandler?
    public static var components = KarhooComponents.shared
    private static var featureFlagsService = FeatureFlagsService(
        currentSdkVersion: karhooUiSdkVersion
    )

    public static var fontFamily: FontFamily = FontFamily() {
        willSet {
            fonts = KarhooFonts(family: newValue)
        }
    }

    static var fonts: KarhooFonts = KarhooFonts(family: FontFamily())

    public init() {}

    public static func setRouting(routing: ScreenBuilders) {
        UISDKScreenRouting.default.set(routing: routing)
    }

    public static func set(configuration: KarhooUISDKConfiguration) {
        Karhoo.set(configuration: configuration)
        KarhooUISDKConfigurationProvider.set(configuration)
        featureFlagsService.update()
    }
    
    public func screens() -> Routing {
        return UISDKScreenRouting.default
    }
}
