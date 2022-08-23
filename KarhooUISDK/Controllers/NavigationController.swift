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

    enum Style {
        /// Style uses primary color as bar tint color
        case primary
        /// Style uses background color as bar tint color
        case secondary

        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return KarhooUI.colors.primary
            case .secondary:
                return KarhooUI.colors.white
            }
        }

        var tintColor: UIColor {
            switch self {
            case .primary:
                return KarhooUI.colors.white
            case .secondary:
                return KarhooUI.colors.text
            }
        }
    }

    let style: Style

    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }

    init(rootViewController: UIViewController, style: Style) {
        self.style = style
        super.init(rootViewController: rootViewController)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        setupDesign()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    private func setupDelegate() {
        delegate = self
    }

    private func setupDesign() {
        if #available(iOS 13.0, *) {
            let backArrow = UIImage.uisdkImage("back_arrow")
                    .withRenderingMode(.alwaysTemplate)
                    .withTintColor(style.tintColor)
            navigationController?.navigationBar.barTintColor = style.backgroundColor
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = style.backgroundColor
            appearance.shadowColor = .clear
            appearance.setBackIndicatorImage(backArrow, transitionMaskImage: backArrow)
            appearance.titleTextAttributes = [
                .foregroundColor: style.tintColor
            ]
            // set navigation bar items colors to style.tintColor
            navigationBar.tintColor = style.tintColor
            navigationBar.shadowImage = UIImage()
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)

            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            if #available(iOS 15.0, *) {
                navigationBar.compactScrollEdgeAppearance = appearance
            }
        }
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
