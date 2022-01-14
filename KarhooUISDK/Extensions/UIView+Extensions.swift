//
//  UIView+extension.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import CoreGraphics

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
    
    public func anchor(top: NSLayoutYAxisAnchor? = nil,
                       left: NSLayoutXAxisAnchor? = nil,
                       leading: NSLayoutXAxisAnchor? = nil,
                       bottom: NSLayoutYAxisAnchor? = nil,
                       right: NSLayoutXAxisAnchor? = nil,
                       trailing: NSLayoutXAxisAnchor? = nil,
                       paddingTop: CGFloat = 0,
                       paddingLeft: CGFloat = 0,
                       paddingBottom: CGFloat = 0,
                       paddingRight: CGFloat = 0,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    public func centerX(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    public func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let leftAnchor = leftAnchor {
            anchor(left: leftAnchor, paddingLeft: paddingLeft)
        }
    }
    
    public func setDimensions(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}
