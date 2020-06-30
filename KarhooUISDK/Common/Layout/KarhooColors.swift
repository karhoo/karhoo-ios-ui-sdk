//
//  KarhooUI.colors.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public protocol KarhooColors {
    var darkGrey: UIColor { get }

    var primary: UIColor { get }

    var primaryDark: UIColor { get }

    var secondary: UIColor { get }
    var secondaryDark: UIColor { get }

    var tertiary: UIColor { get }
    var tertiaryDark: UIColor { get }

    var quaternaryDark: UIColor { get }
    var quaternary: UIColor { get }

    var black: UIColor { get }
    var medGrey: UIColor { get }
    var lightGrey: UIColor { get }
    var offWhite: UIColor { get }
    var white: UIColor { get }
    var white95: UIColor { get }
    var neonRed: UIColor { get }

    var mapJourneyPath: UIColor { get }
    var mapJourneyPathBorder: UIColor { get }
    
    var guestCheckoutLightGrey: UIColor { get }
}

public extension KarhooColors {
    var darkGrey: UIColor {
        return  #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // #333333
    }

    var primary: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 1.0 / 255.0, blue: 128.0 / 255.0, alpha: 1) // #FF0182
    }

    var primaryDark: UIColor {
        return UIColor(red: 199.0 / 255.0, green: 0.0, blue: 56.0 / 255.0, alpha: 1.0)
    }

    var secondary: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 20.0 / 255.0, blue: 71.0 / 255.0, alpha: 1)
    }

    var secondaryDark: UIColor {
        return UIColor(red: 0.0, green: 153.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }

    var tertiary: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 188.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    var tertiaryDark: UIColor {
        return UIColor(red: 0.0, green: 147.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    }

    var quaternaryDark: UIColor {
        return UIColor(red: 224.0 / 255.0, green: 147.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
    var quaternary: UIColor {
        return UIColor(red: 1.0, green: 188.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
    }

    var black: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    var medGrey: UIColor {
        return  UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    var lightGrey: UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }
    var offWhite: UIColor {
        return UIColor(white: 247.0 / 255.0, alpha: 1.0)
    }
    var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    var white95: UIColor {
        return  UIColor(white: 1.0, alpha: 0.95)
    }
    var neonRed: UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0, blue: 0.2745098039, alpha: 1) // #FA0046
    }

    var mapJourneyPath: UIColor {
        return #colorLiteral(red: 0.4431372549, green: 0.7529411765, blue: 0.9764705882, alpha: 1) // #71C0F9
    }
    var mapJourneyPathBorder: UIColor {
        return #colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.7333333333, alpha: 1) // #4596BB
    }
    var guestCheckoutLightGrey: UIColor {
        return #colorLiteral(red: 0.5294117647, green: 0.5960784314, blue: 0.6784313725, alpha: 1) // #8798AD
    }
    var guestCheckoutDarkGrey: UIColor {
        return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1) // #3C3C3C
    }
    var guestCheckoutGrey: UIColor {
        return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) // #9E9E9E
    }
    var darkNavy: UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.137254902, blue: 0.2235294118, alpha: 1) // #252339
    }
    var darkBlue: UIColor {
        return #colorLiteral(red: 0.09411764706, green: 0.1019607843, blue: 0.2784313725, alpha: 1) // #181A47
    }
    var paymentLightGrey: UIColor {
        return #colorLiteral(red: 0.5176470588, green: 0.5960784314, blue: 0.6784313725, alpha: 1)
    }
}

struct DefaultKarhooColors: KarhooColors { }
