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
    
    var isLight : Bool {
        guard let components = cgColor.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()),
                       green: CGFloat(drand48()),
                       blue: CGFloat(drand48()),
                       alpha: 1.0)
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1) {
        var hex = hex

        if !hex.hasPrefix("#") || hex.count != 7 {
            assertionFailure("# + six digits color code expected to decode hex value")
            UIColor.adjustInvalidHex(&hex)
        }

        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue: CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha
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
    
    func getColor() -> Color {
        return Color(
            .sRGB,
            red: self.cgColor.components![0],
            green:self.cgColor.components![1],
            blue: self.cgColor.components![2],
            opacity: 1
        )
    }
}
