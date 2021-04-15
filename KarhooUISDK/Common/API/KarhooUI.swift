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

    public static var fontFamily: FontFamily = FontFamily() {
        willSet {
            fonts = KarhooFonts(family: newValue)
        }
    }

    internal static var fonts: KarhooFonts = KarhooFonts(family: FontFamily())

    public init() {}

    public static func set(configuration: KarhooUISDKConfiguration) {
        Karhoo.set(configuration: configuration)
        KarhooUISDKConfigurationProvider.set(configuration)
    }
}
