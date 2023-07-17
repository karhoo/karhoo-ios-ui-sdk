//
//  KarhooColors+DefaultSet.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

/// For any colors functional interpretation and description please check `KarhooColors.swift` file.
struct DefaultKarhooColors: KarhooColors { }

public extension KarhooColors {
    // MARK: - UI Colors

    var primary: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#18183F"), darkModeColor: UIColor(hex: "#6F769A"))
    }

    var secondary: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#FF0082"), darkModeColor: UIColor(hex: "#FF509C"))
    }

    var accent: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#1A70C1"), darkModeColor: UIColor(hex: "#5BC0EB"))
    }

    var lightAccent: UIColor {
        // Same color for light and dark modes
        UIColor(hex: "#E1F4FC")
    }

    var border: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#EBEBEB"), darkModeColor: UIColor(hex: "#2A2A2A"))
    }

    var error: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#ED3A3A"), darkModeColor: UIColor(hex: "#EB7577"))
    }

    var success: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#12BE76"), darkModeColor: UIColor(hex: "#56CA8E"))
    }

    var inactive: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#E0E0E0"), darkModeColor: UIColor(hex: "#464646"))
    }
    
    var warning: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#F6A705"), darkModeColor: UIColor(hex: "#FAF06E"))
    }

    var white: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#FFFFFF"), darkModeColor: UIColor(hex: "#E0E0E0"))
    }

    var black: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#121212"), darkModeColor: UIColor(hex: "#121212"))
    }

    // MARK: - Background Colors

    var background1: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#FAFAFA"), darkModeColor: UIColor(hex: "#121212"))
    }

    var background2: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#FFFFFF"), darkModeColor: UIColor(hex: "#232323"))
    }

    var background3: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#F2F2F2"), darkModeColor: UIColor(hex: "#252525"))
    }

    var background4: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#E5E5E5"), darkModeColor: UIColor(hex: "#2C2C2C"))
    }

    // MARK: - Text Colors

    var text: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#383838"), darkModeColor: UIColor(hex: "#CECECE"))
    }

    var textLabel: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#757575"), darkModeColor: UIColor(hex: "#9E9E9E"))
    }

    var textInactive: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#E0E0E0"), darkModeColor: UIColor(hex: "#2C2C2C"))
    }
    
    var textError: UIColor {
        UIColor.get(lightModeColor: UIColor(hex: "#ED3A3A"), darkModeColor: UIColor(hex: "#E2E2E2"))
    }

    // MARK: - Depracated

//    var darkGrey: UIColor {
//        return  #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // #333333
//    }

//    var primaryDark: UIColor {
//        return UIColor(red: 199.0 / 255.0, green: 0.0, blue: 56.0 / 255.0, alpha: 1.0)
//    }
//
//    var secondaryDark: UIColor {
//        return UIColor(red: 0.0, green: 153.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
//    }
//
//    var infoColor: UIColor {
//        return .darkGray // #555555
//    }
//
//    var primaryTextColor: UIColor {
//        return .darkGray
//    }
//
//    var medGrey: UIColor {
//        return  UIColor(white: 153.0 / 255.0, alpha: 1.0)
//    }
//
//    var lightGrey: UIColor {
//        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
//    }

//    var regularGrey: UIColor {
//        return UIColor(white: 189.0 / 255.0, alpha: 1.0)
//    }

//    var offWhite: UIColor {
//        return UIColor(white: 247.0 / 255.0, alpha: 1.0)
//    }

    var white95: UIColor {
        return  UIColor(white: 1.0, alpha: 0.95)
    }

//    var neonRed: UIColor {
//        return #colorLiteral(red: 0.9803921569, green: 0, blue: 0.2745098039, alpha: 1) // #FA0046
//    }

//    var mapTripPath: UIColor {
//        return #colorLiteral(red: 0.4431372549, green: 0.7529411765, blue: 0.9764705882, alpha: 1) // #71C0F9
//    }

//    var mapTripPathBorder: UIColor {
//        return #colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.7333333333, alpha: 1) // #4596BB
//    }

//    var guestCheckoutLightGrey: UIColor {
//        return #colorLiteral(red: 0.5294117647, green: 0.5960784314, blue: 0.6784313725, alpha: 1) // #8798AD
//    }
//
//    var guestCheckoutDarkGrey: UIColor {
//        return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1) // #3C3C3C
//    }

//    var guestCheckoutGrey: UIColor {
//        return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) // #9E9E9E
//    }

//    var darkNavy: UIColor {
//        return #colorLiteral(red: 0.1450980392, green: 0.137254902, blue: 0.2235294118, alpha: 1) // #252339
//    }

//    var darkBlue: UIColor {
//        return #colorLiteral(red: 0.09411764706, green: 0.1019607843, blue: 0.2784313725, alpha: 1) // #181A47
//    }

//    var infoBackgroundColor: UIColor {
//        return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
//    }
    
}
