//  
//  QuoteListSortCorrdinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

struct KarhooQuoteListSortCoordinator: QuoteListSortCoordinator {
    
    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListSortViewController
    private(set) var presenter: QuoteListSortPresenter!
    
    // MARK: - Initializator
    
    init(
        navigationController: UINavigationController? = nil
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListSortViewController()
        self.presenter = KarhooQuoteListSortPresenter(
            router: self
        )
        self.viewController.setupBinding(presenter)
    }
    
    func start() {
        navigationController?.show(viewController, sender: nil)
    }
}

extension KarhooQuoteListSortCoordinator: QuoteListSortRouter {
}
