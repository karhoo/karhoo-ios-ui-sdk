//
//  NewCheckoutCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

final class KarhooNewCheckoutCoordinator: NewCheckoutCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: NewCheckoutViewController!
    private(set) var presenter: KarhooNewCheckoutViewModel?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) {
        self.navigationController = navigationController
        self.presenter = KarhooNewCheckoutViewModel(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: callback
        )
        self.viewController = KarhooNewCheckoutViewController().then {
            $0.setupBinding(presenter!)
        }
    }

}

extension KarhooNewCheckoutCoordinator: NewCheckoutRouter {

}
