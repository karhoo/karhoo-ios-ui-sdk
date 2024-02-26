//
//  UIView+Extensions.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreGraphics
import UIKit

extension UIView {
 
    func applyRoundCorners(
        _ cornerMask: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
        radius: CGFloat
    ) {
        layer.cornerRadius = radius
        layer.maskedCorners = cornerMask
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
    
    public func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingRight: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
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
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    public func anchorToSuperview(
        paddingTop: CGFloat = 0,
        paddingLeading: CGFloat = 0,
        paddingTrailing: CGFloat = 0,
        paddingBottom: CGFloat = 0
    ) {
        guard let superview = self.superview else {
            print("There is no superview the view can be aligned to.")
            return
        }
        anchor(
            top: superview.topAnchor,
            leading: superview.leadingAnchor,
            trailing: superview.trailingAnchor,
            bottom: superview.bottomAnchor,
            paddingTop: paddingTop,
            paddingLeft: paddingLeading,
            paddingRight: paddingTrailing,
            paddingBottom: paddingBottom
        )
    }

    func anchorToSuperview(padding: CGFloat) {
        anchorToSuperview(
            paddingTop: padding,
            paddingLeading: padding,
            paddingTrailing: padding,
            paddingBottom: padding
        )
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
    
    public func setDimensions(height: CGFloat? = nil, width: CGFloat? = nil, priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).do {
                $0.priority = priority
                $0.isActive = true
            }
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).do {
                $0.priority = priority
                $0.isActive = true
            }
        }
    }

    /// Add shadow with given opacity (default = 0.5) and radius (default from UIKit = 3) and 0.5,0.5 offset.
    func addShadow(_ opacity: CGFloat = UIConstants.Alpha.shadow, radius: CGFloat = 3) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
        layer.masksToBounds = false
        layer.shadowRadius = radius
    }
}
