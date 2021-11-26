//
//  NavigationBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol NavigationBarView: AnyObject {

    func set(leftIcon: NavigationBarItemIcon)

    func set(rightItemHidden: Bool)
}

protocol NavigationBarPresenter {

    func leftButtonPressed()

    func rightButtonPressed()

    func load(view: NavigationBarView?)
}

protocol NavigationBarActions: AnyObject {

    func leftButtonPressed()

    func rightButtonPressed()
}
