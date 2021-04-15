//
//  Navigation.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

/**
 * A navigation controller is responsible for presenting flow items.
 * It does not handle the flow themselves but rather allows the flow to 
 * modify what is being shown on the screen
 */
public protocol NavigationItem: AnyObject, FlowItemable {
    func show(item: Screen, animated: Bool)
    func showAsModal(item: Screen, animated: Bool)
    func showAsOverlay(item: Screen, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func presentAsModal(item: Screen, animated: Bool)
    func hideTopItem(animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool, completion: (() -> Void)?)
    func popToRoot()
}

public extension NavigationItem {
    func hideTopItem(animated: Bool) {
        hideTopItem(animated: animated, completion: nil)
    }

    func pop(animated: Bool, completion: (() -> Void)?) {
        hideTopItem(animated: true, completion: completion)
    }
}

@objc public protocol FlowItemable {
    @objc func getFlowItem() -> Screen
}
