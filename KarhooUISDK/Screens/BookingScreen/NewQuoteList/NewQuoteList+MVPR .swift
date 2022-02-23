//  
//  NewQuoteList+MVPR .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol NewQuoteListViewController: BaseViewController {
    func updateQuoteListState(_ state: QuoteListStete)
}

protocol NewQuoteListPresenter: AnyObject {
    var state: QuoteListStete { get }
    var onQuoteListStateUpdated: ((QuoteListStete) -> Void)? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func updateQuoteListState(_ state: QuoteListStete)
}

protocol NewQuoteListRouter {
}
