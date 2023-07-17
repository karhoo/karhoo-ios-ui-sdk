//
//  KarhooUI.colors.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public protocol KarhooColors {
    // MARK: - UI Colors

    /// The primary color is used for display components without clickable interaction
    var primary: UIColor { get }

    /// The secondary color is used for 1st-level actions that allows changing step and validating
    var secondary: UIColor { get }

    /// The lighter variation of accent color
    @available(*, deprecated, message: "This color has been deprecated and will be removed in a future release")
    var lightAccent: UIColor { get }

    /// The accent color is used for secondary category actions (links, filters)
    var accent: UIColor { get }

    /// The color designed to be used for views borders.
    var border: UIColor { get }

    var error: UIColor { get }

    var success: UIColor { get }

    var inactive: UIColor { get }
    
    var warning: UIColor { get }

    /// White color fit for both light and dark mode.
    var white: UIColor { get }

    /// Black color fit for both light and dark mode.
    var black: UIColor { get }

    // MARK: - Background Colors

    var background1: UIColor { get }

    var background2: UIColor { get }

    var background3: UIColor { get }

    var background4: UIColor { get }

    // MARK: - Text Colors

    var text: UIColor { get }

    /// Used for the input, text area and dropdown by default when they are not selected, not filled or are inactive.
    var textLabel: UIColor { get }

    var textInactive: UIColor { get }
    
    var textError: UIColor { get }

    // MARK: - Depracated
//
//    @available(*, deprecated, message: "Colors are prepared to be used with Dark Mode, therefore, exact colors are no longer supported")
//    var darkGrey: UIColor { get }
    
//    @available(*, deprecated, message: "Colors are prepared to be used with Dark Mode, therefore, dark/light color variants are no longer supported")
//    var primaryDark: UIColor { get }

//    @available(*, deprecated, message: "Colors are prepared to be used with Dark Mode, therefore, dark/light color variants are no longer supported")
//    var secondaryDark: UIColor { get }

//    /// InfoColor is used for text or icons associated with informational texts (titles, body, captions, some icons)
//    @available(*, deprecated, message: "Please use one of colors included in 'Text Colors' section")
//    var infoColor: UIColor { get }
//
//    /// PrimaryTextColor is used for informational texts
//    @available(*, deprecated, renamed: "text")
//    var primaryTextColor: UIColor { get }
//
//    @available(*, deprecated, message: "")
//    var medGrey: UIColor { get }

//    /// The light grey is used for text backgrounds
//    @available(*, deprecated, message: "")
//    var lightGrey: UIColor { get }
    
//    /// The regular grey is used for borders for cards, line dividers and unselected and incomplete inputs
//    @available(*, deprecated, message: "")
//    var regularGrey: UIColor { get }

//    @available(*, deprecated, message: "")
//    var offWhite: UIColor { get }

    @available(*, deprecated, message: "")
    var white95: UIColor { get }

//    @available(*, deprecated, message: "")
//    var neonRed: UIColor { get }
//
//    @available(*, deprecated, message: "")
//    var mapTripPath: UIColor { get }
//
//    @available(*, deprecated, message: "")
//    var mapTripPathBorder: UIColor { get }
    
//    @available(*, deprecated, message: "")
//    var guestCheckoutLightGrey: UIColor { get }
}
