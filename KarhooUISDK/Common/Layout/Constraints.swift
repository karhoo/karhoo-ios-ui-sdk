//
//  Constraints.swift
//  HelloWorld
//
//
//  Copyright © 2017 Bespoke Code LTD. All rights reserved.
//

import UIKit

extension UIView {

    func pinEdges(to view: UIView, spacing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        pinLeftRightEdegs(to: view, leading: spacing, trailing: -spacing)
        pinTopBottomEdegs(to: view, top: spacing, bottom: -spacing)
    }

    func pinLeftRightEdegs(to view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
    }

    func pinTopBottomEdegs(to view: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }

}

final class Constraints {
    class func pinEdges(of view: UIView, to template: UIView) {
        Constraints.pinVerticalEdges(of: view, to: template)
        Constraints.pinHorizontalEdges(of: view, to: template)
    }

    class func pinVerticalEdges(of view: UIView, to template: UIView) {
        Constraints.alignTop(of: view, to: template)
        Constraints.alignBottom(of: view, to: template)
    }

    class func pinHorizontalEdges(of view: UIView, to template: UIView) {
        Constraints.alignLeft(of: view, to: template)
        Constraints.alignRight(of: view, to: template)
    }

    class func alignTop(of view: UIView, to template: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: view,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: template,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        template.addConstraint(topConstraint)
    }

    class func alignBottom(of view: UIView, to template: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let bottomConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: template,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        template.addConstraint(bottomConstraint)
    }

    class func alignRight(of view: UIView, to template: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let rightConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: template,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        template.addConstraint(rightConstraint)
    }

    class func alignLeft(of view: UIView, to template: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let leftConstraint = NSLayoutConstraint(item: view,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: template,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        template.addConstraint(leftConstraint)
    }

    class func center(subview: UIView, in superview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        Constraints.pinCenterX(of: subview, to: superview, parent: superview)
        Constraints.pinCenterY(of: subview, to: superview, parent: superview)
    }

    class func pinCenterX(of view: UIView, to template: UIView, parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: view,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: template,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        parent.addConstraint(centerX)
    }

    class func pinCenterY(of view: UIView, to template: UIView, parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let centerY = NSLayoutConstraint(item: view,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: template,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        parent.addConstraint(centerY)
    }

    class func fix(width: CGFloat, on view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: width)
        view.addConstraint(widthConstraint)
    }

    class func trail(view: UIView, to previousView: UIView, parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let leftConstraint = NSLayoutConstraint(item: view,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: previousView,
                                                attribute: .right,
                                                multiplier: 1,
                                                constant: 0)
        parent.addConstraint(leftConstraint)
    }
}
