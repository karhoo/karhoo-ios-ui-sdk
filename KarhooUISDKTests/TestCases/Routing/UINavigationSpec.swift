//
//  UINavigationSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

import KarhooUISDKTestUtils
@testable import KarhooUISDK

class UINavigationSpec: KarhooTestCase {

    private var testNavController: TestNavigationController!
    private var testNavDelegate: NavigationItemDelegate! // swiftlint:disable:this weak_delegate
    private var testObject: UINavigation!

    override func setUp() {
        super.setUp()

        testNavController = TestNavigationController()
        testNavDelegate = NavigationItemDelegate()
        testObject = UINavigation(controller: testNavController,
                                  controllerDelegate: testNavDelegate)
    }

    /**
     *  When:   Initialised
     *  Then:   The controller should have a delegate
     *   And:   The controller should be the child of the object
     */
    func testInitialized() {
        XCTAssert(testNavController.delegate === testNavDelegate)

        XCTAssert(testNavController.parent === testObject)
    }

    /**
     *  When:   A view controller is shown
     *  Then:   The view controller should be pushed to the navigation stack
     */
    func testShow() {
        let test = UIViewController()
        let animated = false
        testObject.show(item: test, animated: animated)

        XCTAssert(testNavController.pushedItem === test)
        XCTAssert(testNavController.pushAnimated == animated)
        XCTAssert(testNavDelegate.nextPushType == .none)
    }

    /**
     *  When:   A view controller is shown modally
     *  Then:   It should be pushed to the navigation stack
     *   And:   The push type should be modal
     */
    func testShowModal() {
        let test = UIViewController()
        let animated = false
        testObject.showAsModal(item: test, animated: animated)

        XCTAssert(testNavController.pushedItem === test)
        XCTAssert(testNavController.pushAnimated == animated)
        XCTAssert(testNavDelegate.nextPushType == .modal)
    }

    /**
     *  When:   A view controller is shown as overlay
     *  Then:   It should be presented on the stack
     */
    func testShowOverlay() {
        let test = UIViewController()
        let animated = true
        testObject.showAsOverlay(item: test, animated: animated)

        XCTAssertNil(testNavController.pushedItem)
        XCTAssert(testNavController.presentedItem === test)
        XCTAssert(testNavController.presentAnimated == animated)
        XCTAssert(test.modalPresentationStyle == .overCurrentContext)
        XCTAssert(testNavDelegate.nextPushType == .none)
    }

    /**
     *  Given:  The top item was pushed
     *  When:   Hiding the top item
     *  Then:   The top item should be poped from the stack
     */
    func testHidePushed() {
        let test = UIViewController()
        let animated = true
        testObject.show(item: test, animated: animated)

        testObject.hideTopItem(animated: animated)

        XCTAssert(testNavController.popWasCalledWithAnimated == animated)
    }

    /**
     *  Given:  The top item was presented
     *  When:   Hiding the top item
     *  Then:   The top item should be dismissed
     */
    func testHideWhenPresented() {
        let test = MockViewController()
        let animated = true
        testObject.showAsOverlay(item: test, animated: animated)

        testObject.hideTopItem(animated: animated)

        XCTAssert(test.dismissCalled)
    }
}

private class TestNavigationController: UINavigationController {

    var pushedItem: UIViewController?
    var pushAnimated: Bool?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedItem = viewController
        pushAnimated = animated
    }

    var presentedItem: UIViewController?
    var presentAnimated: Bool?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentedItem = viewControllerToPresent
        presentAnimated = flag
    }

    override var presentedViewController: UIViewController? {
        return presentedItem
    }

    var popWasCalledWithAnimated: Bool?
    override func popViewController(animated: Bool) -> UIViewController? {
        popWasCalledWithAnimated = animated
        return nil
    }
}
