//  
//  NewQuoteListPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

enum QuoteListStete {
    case loading
    case fetched(quotes: [Quote])
    case empty
}

class KarhooNewQuoteListPresenter: NewQuoteListPresenter {

    private let router: NewQuoteListRouter
    let onQuoteSelected: (Quote) -> Void
    let onQuoteDetailsSelected: (Quote) -> Void
    var onQuoteListStateUpdated: ((QuoteListStete) -> Void)?
    var state: QuoteListStete = .empty

    init(
        router: NewQuoteListRouter,
        quotes: [Quote],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) {
        self.router = router
        self.state = quotes.isEmpty ? .empty : .fetched(quotes: quotes)
        self.onQuoteSelected = onQuoteSelected
        self.onQuoteDetailsSelected = onQuoteDetailsSelected
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        onQuoteListStateUpdated?(state)
    }

    func updateQuoteListState(_ state: QuoteListStete) {
        self.state = state
        onQuoteListStateUpdated?(state)
    }
}
