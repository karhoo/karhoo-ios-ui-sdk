//
//  SideMenuBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

protocol SideMenuBuilder {

    func buildSideMenu(hostViewController: UIViewController,
                       routing: SideMenuHandler) -> SideMenu
}
