//
//  ResizingSwitcher.swift
//  ConstraintSwitcher
//
//
//  Copyright © 2016 Bespoke Code AB. All rights reserved.
//

import UIKit

/**
 * Specific case of ConstraintSwitcher which provides some context. This
 * switcher handles extended/contracted constraints
 */
public final class ResizingSwitcher: NSObject {

    public typealias SizeSwitchedClosure = (ResizeTag) -> Void

    public enum ResizeTag: Int {
        case expanded
        case contracted
    }

    @IBOutlet var expandedConstraints: [NSLayoutConstraint]?
    @IBOutlet var contractedConstraints: [NSLayoutConstraint]?

    private let constraintSwitcher: ConstraintSwitcher

    private var callback: SizeSwitchedClosure?

    // MARK: - Init functions
    public required override init() {
        self.constraintSwitcher = DefaultConstraintSwitcher()
    }

    public init(constraintSwitcher: ConstraintSwitcher) {
        self.constraintSwitcher = constraintSwitcher
    }

    // MARK: - Public functions

    public func set(animationTime: Double) {
        self.constraintSwitcher.set(animationTime: animationTime)
    }

    public func set(callback: SizeSwitchedClosure?) {
        self.callback = callback
    }

    @IBAction func expand() {
        self.expand(animated: true)
    }

    public func expand(animated: Bool) {
        self.setupConstraintSwitcherIfNeeded()
        self.constraintSwitcher.activateConstraintWithTag(tag: ResizeTag.expanded.rawValue,
                                                          animated: animated,
                                                          completion: { [weak self] in
                                                            self?.callback?(.expanded)

        })
    }

    @IBAction func contract() {
        self.contract(animated: true)
    }

    public func contract(animated: Bool, callback: (() -> Void)? = nil) {
        self.setupConstraintSwitcherIfNeeded()
        self.constraintSwitcher.activateConstraintWithTag(tag: ResizeTag.contracted.rawValue,
                                                          animated: animated,
                                                          completion: { [weak self] in
                                                            self?.callback?(.contracted)
                                                            callback?()
        })
    }

    @IBAction func toggle() {
        self.toggle(animated: true)
    }

    public func toggle(animated: Bool) {
        self.setupConstraintSwitcherIfNeeded()
        if self.isExpanded() {
            self.contract(animated: animated)
        } else {
            self.expand(animated: animated)
        }
    }

    public func isExpanded() -> Bool {
        return constraintSwitcher.isConstraintActive(tag: ResizeTag.expanded.rawValue)
    }

    // MARK: - Private functions

    fileprivate func setupConstraintSwitcherIfNeeded() {
        guard let expandedConstraints = self.expandedConstraints else {
            return
        }

        guard let contractedConstraints = self.contractedConstraints else {
            return
        }

        var primaryConstraints = expandedConstraints
        var primaryTag = ResizeTag.expanded
        var secondaryConstraints = contractedConstraints
        var secondaryTag = ResizeTag.contracted

        if contractedConstraints.first?.isActive == true {
            primaryConstraints = contractedConstraints
            primaryTag = .contracted
            secondaryConstraints = expandedConstraints
            secondaryTag = .expanded
        }

        self.constraintSwitcher.loadConstraints(primaryConstraints: primaryConstraints,
                                                primaryTag: primaryTag.rawValue,
                                                secondaryConstraints: secondaryConstraints,
                                                secondaryTag: secondaryTag.rawValue)
    }
}
