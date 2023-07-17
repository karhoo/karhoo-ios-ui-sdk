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

    @available(*, deprecated, message: "")
    var white95: UIColor { get }
}
