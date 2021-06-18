//
//  SideMenuHandler.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol SideMenuHandler {
    func showProfile(onViewController viewController: UIViewController)
    func showBookingsList(onViewController viewController: UIViewController)
    func showAbout(onViewController viewController: UIViewController)
    func showHelp(onViewController viewController: UIViewController)
}
