//  
//  QuoteListTable+MVPR .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol QuoteListTableCoordinator: KarhooUISDKSceneCoordinator {
    var viewController: QuoteListTableViewController { get }

    func updateQuoteListState(_ state: QuoteListState)

    func assignHeaderView(_ view: UIView)
}

protocol QuoteListTableViewController: BaseViewController {

    func setupBinding(_ presenter: QuoteListTablePresenter)

    /// Assign table view header view. It's size needs to be nonzero.
    func assignHeaderView(_ view: UIView)

}

protocol QuoteListTablePresenter: AnyObject {

    var state: QuoteListState { get }

    var onQuoteListStateUpdated: ((QuoteListState) -> Void)? { get set }

    var onQuoteSelected: (Quote) -> Void { get }

    var onQuoteDetailsSelected: (Quote) -> Void { get }

    func viewDidLoad()

    func viewWillAppear()

    func updateQuoteListState(_ state: QuoteListState)

}

protocol QuoteListTableRouter {
}
