//
//  KarhooCheckoutViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

final class KarhooCheckoutViewController: UIViewController, CheckoutViewController {

    // MARK: - Properties

    private var viewModel: KarhooCheckoutViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }

    // MARK: - Views

    private lazy var hostingController = UIHostingController(rootView: CheckoutView(viewModel: self.viewModel!)).then {
        $0.loadViewIfNeeded()
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.view.backgroundColor = .clear
    }

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil, "View model needs to be assigned using `setupBinding` method")
    }

    // MARK: - Setup binding

    func setupBinding(_ viewModel: KarhooCheckoutViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Setup view

    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        view = UIView()
        view.backgroundColor = KarhooUI.colors.background1
        forceLightMode()
        addChild(hostingController)
        setupNavigationBar()
    }

    private func setupHierarchy() {
        view.addSubview(hostingController.view)
    }

    private func setupLayout() {
        hostingController.view.anchorToSuperview()
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
        navigationItem.title = UITexts.Generic.checkout
        navigationController?.set(style: .primary)
    }
}
