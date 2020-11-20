//
//  UIView+extension.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

extension UIView {
 
    public func applyRoundCorners(corners: UIRectCorner = [.topLeft, .topRight],
                                  radius: CGFloat = 20) {
        let bottomOffset: CGFloat = 100

        let roundCornersPath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                                y: 0,
                                                                width: bounds.width,
                                                                height: bounds.height + bottomOffset),
                                            byRoundingCorners: corners,
                                            cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = roundCornersPath.cgPath
        layer.mask = maskLayer
    }
    
    public func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    public func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        
        layer.add(animation, forKey: "position")
    }
    
    func  addOuterShadow(opacity: Float = 0.5,
                         radious: CGFloat = 5,
                         rasterize: Bool = true,
                         color: UIColor = .black) {
        if layer.shadowPath == nil {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shadowRadius = radious
            layer.shadowOffset = .zero
            layer.shouldRasterize = rasterize
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    func visualDebugMode(_ value: Bool) {
        self.subviews.forEach { $0.backgroundColor = .random()}
    }
}
