//
//  NavigationController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 30/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    private func setupDelegate() {
        delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        setNeedsStatusBarAppearanceUpdate()
    }
}
