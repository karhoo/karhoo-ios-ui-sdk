//  
//  KarhooQuoteListSortCorrdinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

class KarhooQuoteListSortCoordinator: QuoteListSortCoordinator {

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListSortViewController
    private(set) var presenter: QuoteListSortPresenter!
    
    // MARK: - Initializator
    
    init(
        navigationController: UINavigationController? = nil,
        selectedOption: QuoteListSortOrder,
        onSortOptionComfirmed: @escaping (QuoteListSortOrder) -> Void
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListSortViewController()
        self.presenter = KarhooQuoteListSortPresenter(
            router: self,
            selectedOption: selectedOption,
            onSortOptionComfirmed: onSortOptionComfirmed
        )
        self.viewController.setupBinding(presenter)
    }
}

extension KarhooQuoteListSortCoordinator: QuoteListSortRouter {
    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
