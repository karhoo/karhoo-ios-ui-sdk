//  
//  NewQuoteList+MVPR .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol NewQuoteListViewController: BaseViewController {
    func updateQuoteListState(_ state: QuoteListState)
}

protocol NewQuoteListPresenter: AnyObject {
    var state: QuoteListState { get }
    var onQuoteListStateUpdated: ((QuoteListState) -> Void)? { get set }
    var onQuoteSelected: (Quote) -> Void { get }
    var onQuoteDetailsSelected: (Quote) -> Void { get }
    func viewDidLoad()
    func viewWillAppear()
    func updateQuoteListState(_ state: QuoteListState)
}

protocol NewQuoteListRouter {
}
