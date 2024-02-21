//
//  NavigationItemDelegate.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

/**
 *  This class might not be used anymore. We were using it to make modal transitions
 *  not modal (but with modal animation) - I think we don't do that anymore
 */
public final class NavigationItemDelegate: NSObject, UINavigationControllerDelegate {

    enum PresentationType: Int {
        case none
        case normal
        case modal
    }

    var nextPushType: PresentationType = .none

    private var modalPushedControllers = NSPointerArray(options: [.weakMemory])

    @objc public func navigationController(_ navigationController: UINavigationController,
                                           animationControllerFor operation: UINavigationController.Operation,
                                           from fromVC: UIViewController,
                                           to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var animation: UIViewControllerAnimatedTransitioning?

        modalPushedControllers.compact()

        if nextPushType == .modal && operation != .pop {
            animation = ModalAnimation(operation: operation)
            modalPushedControllers.addPointer(Unmanaged.passUnretained(toVC).toOpaque())
        } else if operation == .pop {
            for pointer in self.modalPushedControllers.allObjects {
                if let safePointer = pointer as? NSObject {
                    if safePointer == fromVC {
                        animation = ModalAnimation(operation: operation)
                    }
                }
            }
        }

        nextPushType = .normal

        return animation
    }

}

private final class ModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let operation: UINavigationController.Operation

    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }

    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        let hiddenFrame = CGRect(x: 0,
                                 y: from.view.bounds.size.height,
                                 width: to.view.bounds.size.width,
                                 height: to.view.bounds.size.height)

        if operation == .push || operation == .none {

            transitionContext.containerView.addSubview(to.view)
            to.view.frame = hiddenFrame

            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                                       animations: { () in
                to.view.frame = transitionContext.finalFrame(for: to)
            }, completion: { (completed: Bool) in
                transitionContext.completeTransition(completed)
            })
        } else {
            let containerView = transitionContext.containerView
            containerView.addSubview(to.view)
            containerView.addSubview(from.view)

            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           animations: { () in
                from.view.frame = hiddenFrame
            }, completion: { (completed: Bool) in
                transitionContext.completeTransition(completed)
            })
        }

    }
}
