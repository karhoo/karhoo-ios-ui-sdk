//
//  SideMenuBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

internal protocol SideMenuBuilder {

    func buildSideMenu(hostViewController: UIViewController,
                       routing: SideMenuHandler) -> SideMenu
}
