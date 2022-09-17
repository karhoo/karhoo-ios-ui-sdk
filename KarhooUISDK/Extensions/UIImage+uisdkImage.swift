//
//  UIImage+uisdkImage.swift
//  KarhooUISDK
//  Copyright © 2022 Karhoo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func uisdkImage(_ name: String) -> UIImage {
        guard let loadedImage = UIImage(named: name) else {
            guard let imageInCurrent = UIImage(
                named: name,
                in: .current,
                compatibleWith: nil) else {
                fatalError()
            }
            return imageInCurrent
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
