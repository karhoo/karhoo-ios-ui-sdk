//
//  ConstraintSwitcher.swift
//  ConstraintSwitcher
//
//
//  Copyright © 2016 Bespoke Code AB. All rights reserved.
//

import Foundation

import UIKit

public protocol ConstraintSwitcher: class {
    func loadConstraints(primaryConstraints: [NSLayoutConstraint],
                         primaryTag: Int,
                         secondaryConstraints: [NSLayoutConstraint],
                         secondaryTag: Int)

    func switchConstraints(animated: Bool, completion: ConstraintSwitcherCompletedClosure?)
    func activateConstraintWithTag(tag: Int, animated: Bool, completion: ConstraintSwitcherCompletedClosure?)
    func isConstraintActive(tag: Int?) -> Bool
    func set(animationTime: Double)
}

/**
 * Class which helps toggle between different constraints.
 */
public typealias ConstraintSwitcherCompletedClosure = () -> Void

public final class DefaultConstraintSwitcher: ConstraintSwitcher {

    //Configuration
    fileprivate var animationTime = 0.75

    fileprivate var primaryConstraints: [NSLayoutConstraint]?
    fileprivate var secondaryConstraints: [NSLayoutConstraint]?

    fileprivate var primaryConstraintsTag: Int?
    fileprivate var secondaryConstraintsTag: Int?

    // MARK: - Public functions.

    public func loadConstraints(primaryConstraints: [NSLayoutConstraint],
                                primaryTag: Int,
                                secondaryConstraints: [NSLayoutConstraint],
                                secondaryTag: Int) {
        
        self.primaryConstraints = primaryConstraints
        self.secondaryConstraints = secondaryConstraints
        
        self.primaryConstraintsTag = primaryTag
        self.secondaryConstraintsTag = secondaryTag
    }

    public func set(animationTime: Double) {
        self.animationTime = animationTime
    }

    public func switchConstraints(animated: Bool, completion: ConstraintSwitcherCompletedClosure?) {
        let animationTime = animated ? self.animationTime : 0

        let primaryConstraintActive = self.isConstraintActive(tag: self.primaryConstraintsTag)
        let toActivate = primaryConstraintActive ? self.secondaryConstraints : self.primaryConstraints
        let toDeactivate = primaryConstraintActive ? self.primaryConstraints : self.secondaryConstraints

        let view = self.primaryConstraints?.first?.firstItem as? UIView
        UIView.animate(withDuration: animationTime,
                                   delay: 0,
                                   options: [.layoutSubviews],
                                   animations: {
                                    self.deactivate(constraints: toDeactivate)
                                    self.activate(constraints: toActivate)
                                    view?.superview?.layoutIfNeeded()
            }, completion: { (_: Bool) in
                completion?()
        })
    }

    public func activateConstraintWithTag(tag: Int, animated: Bool, completion: ConstraintSwitcherCompletedClosure?) {
        guard !self.isConstraintActive(tag: tag) else {
            return
        }

        self.switchConstraints(animated: animated, completion: completion)
    }

    public func isConstraintActive(tag: Int?) -> Bool {
        if tag == self.primaryConstraintsTag {
            return self.primaryConstraints?.first?.isActive == true
        }

        return self.secondaryConstraints?.first?.isActive == true
    }

    // MARK: - Private functions
    fileprivate func deactivate(constraints: [NSLayoutConstraint]?) {
        constraints?.forEach { (constraint: NSLayoutConstraint) in
            constraint.isActive = false
        }
    }

    fileprivate func activate(constraints: [NSLayoutConstraint]?) {
        constraints?.forEach { (constraint: NSLayoutConstraint) in
            constraint.isActive = true
        }
    }
}
