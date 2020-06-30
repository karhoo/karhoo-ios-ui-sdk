//
//  MockNavigationItem.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

@testable import KarhooUISDK

final class MockNavigationItem: NavigationItem {

    var lastCallWasAnimated: Bool?

    private(set) var presentModalItem: Screen?
    private(set) var presentedAsModelItemAnimated: Bool?
    func presentAsModal(item: Screen, animated: Bool) {
        presentModalItem = item
        flowItemsAdded.append(item)
        presentedAsModelItemAnimated = animated
    }

    var flowItemsAdded = [Screen]()
    func show(item: Screen, animated: Bool) {
        lastCallWasAnimated = animated
        flowItemsAdded.append(item)
    }

    var lastPushTypeModal = false
    func showAsModal(item: Screen, animated: Bool) {
        flowItemsAdded.append(item)
        lastPushTypeModal = true
    }

    var overlay: Screen?
    var lastPushTypeOverlay = false
    func showAsOverlay(item: Screen, animated: Bool) {
        lastCallWasAnimated = animated
        overlay = item
        flowItemsAdded.append(item)
        lastPushTypeOverlay = true
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        lastCallWasAnimated = animated
        overlay = nil
        flowItemLastRemoved = flowItemsAdded.removeLast()
    }

    var flowItemLastRemoved: Screen?
    var hideTopItemCalled = false
    func hideTopItem(animated: Bool, completion: (() -> Void)?) {
        hideTopItemCalled = true
        if flowItemsAdded.isEmpty {
            completion?()
            return
        }
        flowItemLastRemoved = flowItemsAdded.removeLast()
        completion?()
    }

    var popCalled = false
    func pop(animated: Bool, completion: (() -> Void)?) {
        popCalled = true
        if flowItemsAdded.isEmpty {
            completion?()
            return
        }
        flowItemLastRemoved = flowItemsAdded.removeLast()
        completion?()
    }

    var flowItem = MockViewController()
    func getFlowItem() -> Screen {
        return flowItem
    }

    var popToRootCalled = false
    func popToRoot() {
        popToRootCalled = true
    }
}
