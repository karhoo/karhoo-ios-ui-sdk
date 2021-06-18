//
//  MockSideMenuHandler.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK

final class MockSideMenuHandler: SideMenuHandler {
    var pressedOnBookings = false
    var pressedOnProfile = false
    var pressedOnAbout = false
    var pressedOnHelp = false
    
    func showBookingsList(onViewController viewController: UIViewController) {
        self.pressedOnBookings = true
    }
    func showProfile(onViewController: UIViewController) {
        self.pressedOnProfile = true
    }
    func showAbout(onViewController: UIViewController) {
        self.pressedOnAbout = true
    }
    func showHelp(onViewController: UIViewController) {
        self.pressedOnHelp = true
    }
}
