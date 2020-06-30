//
//  KarhooNavigation.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public final class UINavigation: UIViewController, NavigationItem {

    private let controller: UINavigationController
    private let controllerDelegate: NavigationItemDelegate // swiftlint:disable:this weak_delegate

    public init(controller: UINavigationController,
                controllerDelegate: NavigationItemDelegate = NavigationItemDelegate()) {
        self.controller = controller
        self.controllerDelegate = controllerDelegate
        controller.delegate = controllerDelegate

        super.init(nibName: nil, bundle: nil)
        addController()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show(item: Screen, animated: Bool) {
        controller.pushViewController(item, animated: animated)
    }

    public func showAsModal(item: Screen, animated: Bool) {
        controllerDelegate.nextPushType = .modal
        controller.pushViewController(item, animated: animated)
    }

    public func presentAsModal(item: Screen, animated: Bool) {
        item.modalPresentationStyle = .fullScreen
        controller.present(item, animated: animated, completion: nil)
    }

    public func showAsOverlay(item: Screen, animated: Bool) {
        item.modalPresentationStyle = .overCurrentContext

        if let currentView = controller.presentedViewController {
            if currentView.isBeingDismissed || currentView.isBeingPresented {
                controller.present(item, animated: animated, completion: nil)
                return
            }
            currentView.present(item, animated: animated, completion: nil)
        } else {
            controller.present(item, animated: animated, completion: nil)
        }
    }

    public override func dismiss(animated: Bool, completion: (() -> Void)?) {
        controller.dismiss(animated: animated, completion: completion)
    }

    public func hideTopItem(animated: Bool, completion: (() -> Void)? = nil) {
        if let presented = controller.presentedViewController {
            presented.dismiss(animated: animated, completion: completion)
        } else {
            pop(animated: animated)
            completion?()
        }
    }

    public func pop(animated: Bool) {
        controller.popViewController(animated: animated)
    }

    public func popToRoot() {
        controller.popToRootViewController(animated: true)
    }

    public func getFlowItem() -> Screen {
        return self
    }

    private func addController() {
        controller.willMove(toParent: self)
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)

        Constraints.pinEdges(of: controller.view, to: view)
    }

    public override var childForStatusBarStyle: UIViewController? {
        return controller.topViewController
    }
}
