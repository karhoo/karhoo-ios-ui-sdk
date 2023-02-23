//
//  MockCoordinator.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 16/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

public class MockCoordinator: KarhooUISDKSceneCoordinator {

    public var baseViewController: BaseViewController
    public var navigationController: UINavigationController?
    public var childCoordinators: [KarhooUISDKSceneCoordinator]

    public init(
        baseViewController: BaseViewController = MockBaseViewController(),
        navigationController: UINavigationController? = nil,
        childCoordinators: [KarhooUISDKSceneCoordinator] = []
    ) {
        self.baseViewController = baseViewController
        self.navigationController = navigationController
        self.childCoordinators = childCoordinators
    }
}
