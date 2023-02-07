//
//  KarhooUISDKCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol KarhooUISDKSceneCoordinator: AnyObject {

    var baseViewController: BaseViewController { get }

    var navigationController: UINavigationController? { get }

    var childCoordinators: [KarhooUISDKSceneCoordinator] { get set }

    /// Use this method to push new view onto navigation stack. It is possible only if during Coordinator's initialization you have assiged navigation controller instance. This instance will be used to push the view controller on nav stack. If you'd like to present the scene as modal, please use `navigationController` property and present it directly.
    func start()

    func startNested(parentViewController: BaseViewController, superview: UIView)

    func startPresented(on parentCoordinator: KarhooUISDKSceneCoordinator)

    func addChild(_ childCoordinator: KarhooUISDKSceneCoordinator)

    func removeChild(_ childCoordinator: KarhooUISDKSceneCoordinator)
}

extension KarhooUISDKSceneCoordinator {

    func start() {
        navigationController?.show(baseViewController, sender: nil)
    }

    func startNested(parentViewController: BaseViewController, superview: UIView) {
        superview.addSubview(baseViewController.view)
        parentViewController.addChild(baseViewController)
    }

    func startPresented(on parentCoordinator: KarhooUISDKSceneCoordinator) {
        parentCoordinator.baseViewController.present(baseViewController, animated: false)
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
