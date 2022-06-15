//  
//  QuoteListFiltersCorrdinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteListFiltersCoordinator: QuoteListFiltersCoordinator {
    
    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListFiltersViewController
    private(set) var presenter: QuoteListFiltersPresenter!
    
    // MARK: - Initializator
    
    init(
        navigationController: UINavigationController? = nil,
        onResultsForFiltersChosen: @escaping ([QuoteListFilter]) -> Int,
        onFiltersConfirmed: @escaping ([QuoteListFilter]) -> Void
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListFiltersViewController()
        self.presenter = KarhooQuoteListFiltersPresenter(
            router: self,
            onResultsForFiltersChosen: { filters in
                onResultsForFiltersChosen(filters)
            },
            onFiltersConfirmed: { filters in
                onFiltersConfirmed(filters)
            }
        )
        self.viewController.setupBinding(presenter)
    }
    
    func start() {
        navigationController?.show(viewController, sender: nil)
    }

    func startPresented(on parentCoordinator: KarhooUISDKSceneCoordinator) {
        navigationController = UINavigationController()
        navigationController?.setViewControllers([viewController], animated: false)
        parentCoordinator.baseViewController.present(navigationController!, animated: true)
    }
}

extension KarhooQuoteListFiltersCoordinator: QuoteListFiltersRouter {
    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
