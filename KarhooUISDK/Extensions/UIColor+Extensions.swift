//
//  UIColor+Extensions.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
    
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
    
    /// Accepts two formats: #ffffff and ffffff
    public convenience init(hex: String, alpha: CGFloat = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            self.init(cgColor: UIColor.gray.cgColor)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    private static func adjustInvalidHex(_ hex: inout String) {
        if !hex.hasPrefix("#") {
            assertionFailure("# expected at the begining of hex value")
            hex = "#" + hex
        }

        if hex.count != 7 {
            assertionFailure("Six digits color code expected expected")
            switch hex.count {
            case ..<7:
                hex += (1 ..< 7 - hex.count).map { _ in "0" }.joined()
            case 7:
                break
            case 7...:
                hex.removeLast(7 - hex.count)
            default:
                assertionFailure()
            }
        }
    }

    static func get(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
        // return always light color until SDK starts to support dark mode
        return lightModeColor
        /*
            /**
             UIColor instance build using `dinamicProvider` constructor is, in fact, only factory method for UIColor that is genereted on the go, depending on user interface style.
             Therefore it is impossible to perform equality check with any other UIColor.
             That's why the `properColor` is CGColor instance that hold all required data.
             
             In next step the CGColor instance is wrapped into UIColor class instance so it is easy to use.
             
              HINT: if there is any other way to make sure that UIColor build using `dinamicProvider` can be compared to other UIColor instance, it should replace current solution.
             */
            let properColor = UIColor { (traitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ? darkModeColor : lightModeColor
            }.cgColor
            return UIColor(cgColor: properColor)
        */
    }
}
