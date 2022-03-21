//
//  QuoteListTableCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

final class KarhooQuoteListTableCoordinator: QuoteListTableCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListTableViewController
    private(set) var presenter: QuoteListTablePresenter!

    // MARK: - Initializator

    init(
        navigationController: UINavigationController? = nil,
        quotes: [Quote] = [],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListTableViewController()
        self.presenter = KarhooQuoteListTablePresenter(
            router: self,
            initialState: .fetched(quotes: quotes),
            onQuoteSelected: onQuoteSelected,
            onQuoteDetailsSelected: onQuoteDetailsSelected
        )
        self.viewController.setupBinding(presenter)
    }

    func start() {
        navigationController?.show(viewController, sender: nil)
    }

    func updateQuoteListState(_ state: QuoteListState) {
        presenter.updateQuoteListState(state)
    }

    func assignHeaderView(_ view: UIView) {
        viewController.assignHeaderView(view)
    }
}

extension KarhooQuoteListTableCoordinator: QuoteListTableRouter {
}
