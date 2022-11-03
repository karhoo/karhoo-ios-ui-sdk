//
//  MockNavigationItem.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

@testable import KarhooUISDK

final public class MockNavigationItem: NavigationItem {

    public var lastCallWasAnimated: Bool?

    public var presentModalItem: Screen?
    public var presentedAsModelItemAnimated: Bool?
    public func presentAsModal(item: Screen, animated: Bool) {
        presentModalItem = item
        flowItemsAdded.append(item)
        presentedAsModelItemAnimated = animated
    }

    public var flowItemsAdded = [Screen]()
    public func show(item: Screen, animated: Bool) {
        lastCallWasAnimated = animated
        flowItemsAdded.append(item)
    }

    public var lastPushTypeModal = false
    public func showAsModal(item: Screen, animated: Bool) {
        flowItemsAdded.append(item)
        lastPushTypeModal = true
    }

    public var overlay: Screen?
    public var lastPushTypeOverlay = false
    public func showAsOverlay(item: Screen, animated: Bool) {
        lastCallWasAnimated = animated
        overlay = item
        flowItemsAdded.append(item)
        lastPushTypeOverlay = true
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        lastCallWasAnimated = animated
        overlay = nil
        flowItemLastRemoved = flowItemsAdded.removeLast()
    }

    public var flowItemLastRemoved: Screen?
    public var hideTopItemCalled = false
    public func hideTopItem(animated: Bool, completion: (() -> Void)?) {
        hideTopItemCalled = true
        if flowItemsAdded.isEmpty {
            completion?()
            return
        }
        flowItemLastRemoved = flowItemsAdded.removeLast()
        completion?()
    }

    public var popCalled = false
    public func pop(animated: Bool, completion: (() -> Void)?) {
        popCalled = true
        if flowItemsAdded.isEmpty {
            completion?()
            return
        }
        flowItemLastRemoved = flowItemsAdded.removeLast()
        completion?()
    }

    public var flowItem = MockViewController()
    public func getFlowItem() -> Screen {
        return flowItem
    }

    public var popToRootCalled = false
    public func popToRoot() {
        popToRootCalled = true
    }
}
