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
}
