//
//  NewCheckoutViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

final class KarhooNewCheckoutViewController: UIViewController, NewCheckoutViewController {

    // MARK: - Properties

    private weak var presenter: NewCheckoutPresenter!

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Views

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
        assert(presenter != nil, "Presented needs to be assigned using `setupBinding` method")
        presenter?.viewDidLoad()
    }
}
