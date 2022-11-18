//
//  MockSideMenuHandler.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation
@testable import KarhooUISDK

final public class MockSideMenuHandler: SideMenuHandler {
    public init() {}

    public var pressedOnBookings = false
    public var pressedOnProfile = false
    public var pressedOnAbout = false
    public var pressedOnHelp = false
    
    public func showBookingsList(onViewController viewController: UIViewController) {
        self.pressedOnBookings = true
    }
    public func showProfile(onViewController: UIViewController) {
        self.pressedOnProfile = true
    }
    public func showAbout(onViewController: UIViewController) {
        self.pressedOnAbout = true
    }
    public func showHelp(onViewController: UIViewController) {
        self.pressedOnHelp = true
    }
}
