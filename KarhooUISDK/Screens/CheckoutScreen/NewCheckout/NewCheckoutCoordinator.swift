//
//  NewCheckoutCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class KarhooNewCheckoutCoordinator: NewCheckoutCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: NewCheckoutViewController!
    private(set) var presenter: NewCheckoutPresenter!

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooNewCheckoutViewController()
        self.presenter = KarhooNewCheckoutPresenter()
        self.viewController.setupBinding(presenter)
    }

}

extension KarhooNewCheckoutCoordinator: NewCheckoutRouter {

}
