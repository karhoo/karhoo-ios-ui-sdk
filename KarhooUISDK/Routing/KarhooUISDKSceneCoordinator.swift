//
//  KarhooUISDKCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol KarhooUISDKSceneCoordinator: AnyObject {

    var baseViewController: BaseViewController { get }

    var navigationController: UINavigationController? { get }

    var childCoordinators: [KarhooUISDKSceneCoordinator] { get set }

    func start()

    func startNested(partentViewController: BaseViewController, superview: UIView)

    func addChild(_ childCoordinator: KarhooUISDKSceneCoordinator)

    func removeChild(_ childCoordinator: KarhooUISDKSceneCoordinator)
}

extension KarhooUISDKSceneCoordinator {

    func startNested(partentViewController: BaseViewController, superview: UIView) {
        superview.addSubview(baseViewController.view)
        partentViewController.addChild(baseViewController)
    }

    func addChild(_ childCoordinator: KarhooUISDKSceneCoordinator) {
        childCoordinators.append(childCoordinator)
    }

    func removeChild(_ coordinatorToRemove: KarhooUISDKSceneCoordinator) {
        childCoordinators.removeAll {
            String(describing: $0) == String(describing: coordinatorToRemove)
        }
    }

}
