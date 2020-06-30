//
//  MessageBanner.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public protocol BannerView {
    func set(message: String?)
    func attachTo(view: UIView?)
    func show()
    func dismiss()
}

public final class MessageBanner: UIView, BannerView {

    @IBOutlet private weak var messageLabel: UILabel?

    private let duration = 4.0
    private let animationTime = 0.5

    private weak var hostView: UIView?
    private var presentedStateConstraint: NSLayoutConstraint?
    private var hiddenStateConstraint: NSLayoutConstraint?

    public var dismissesAfterDelay = true

    public class func instantiateFromNib() -> MessageBanner? {
        let myClassNib = UINib(nibName: "MessageBanner", bundle: .current)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as? MessageBanner
    }

    public func set(message: String?) {
        messageLabel?.text = message
    }

    public func attachTo(view: UIView?) {
        guard let host = view else {
            return
        }

        if host == hostView {
            return
        }

        hostView = host
        host.addSubview(self)
        constructConstraints()
        host.layoutIfNeeded()
    }

    public func show() {
        activatePresentedStateConstraints()
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.hostView?.layoutIfNeeded()
            self?.scheduleDismissAfterDurationIfNeeded()
        }
    }

    private func activatePresentedStateConstraints() {
        hiddenStateConstraint?.isActive = false
        presentedStateConstraint?.isActive = true
    }

    private func scheduleDismissAfterDurationIfNeeded() {
        guard self.dismissesAfterDelay else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismiss()
        }
    }

    public func dismiss() {
        activateHiddenStateConstraints()

        UIView.animate(withDuration: animationTime, delay: 0.0, options: [], animations: {
            self.hostView?.layoutIfNeeded()
        })
    }

    private func activateHiddenStateConstraints() {
        presentedStateConstraint?.isActive = false
        hiddenStateConstraint?.isActive = true
    }

    private func constructConstraints() {
        guard let host = hostView else {
            return
        }

        presentedStateConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                                               toItem: host, attribute: .top, multiplier: 1,
                                               constant: 0)

        presentedStateConstraint?.priority = UILayoutPriority(rawValue: 999)

        hiddenStateConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                                               toItem: host, attribute: .top, multiplier: 1,
                                               constant: 0)
        Constraints.pinHorizontalEdges(of: self, to: host)

        activateHiddenStateConstraints()

        host.addConstraints([presentedStateConstraint ?? NSLayoutConstraint(),
                             hiddenStateConstraint ?? NSLayoutConstraint()])

        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
