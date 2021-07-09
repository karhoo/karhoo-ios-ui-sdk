//
//  Bundle+Utils.swift
//  KarhooUISDK
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation

extension Bundle {
    static var current: Bundle {
        if let bundlePath = Bundle(for: KarhooUI.self).path(forResource: "KarhooUISDK", ofType: "bundle") {
            return Bundle(path: bundlePath)!
        } else {
            return Bundle(for: KarhooUI.self)
        }
    }
}

extension UIImage {
    
    static func uisdkImage(_ name: String) -> UIImage {
        guard let loadedImage = UIImage(named: name) else {
            return UIImage(named: name,
                           in: .current,
                           compatibleWith: nil) ?? UIImage()
        }
        return loadedImage
    }
    
    func coloured(withTint tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext(),
              let cgImage = self.cgImage else {
            return self
        }
        context.setBlendMode(.normal)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: rect)
        context.clip(to: rect, mask: cgImage)
        context.setFillColor(tintColor.cgColor)
        context.fill(rect)
        guard let colouredImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()
        return colouredImage
    }
}
