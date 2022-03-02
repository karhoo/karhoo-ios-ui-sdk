//  
//  NewQuoteListPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooNewQuoteListPresenter: NewQuoteListPresenter {

    private let router: NewQuoteListRouter
    let onQuoteSelected: (Quote) -> Void
    let onQuoteDetailsSelected: (Quote) -> Void
    var onQuoteListStateUpdated: ((QuoteListState) -> Void)?
    var state: QuoteListState

    init(
        router: NewQuoteListRouter,
        quotes: [Quote],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) {
        self.router = router
        self.state = quotes.isEmpty ? .empty(reason: .noResults) : .fetched(quotes: quotes)
        self.onQuoteSelected = onQuoteSelected
        self.onQuoteDetailsSelected = onQuoteDetailsSelected
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        onQuoteListStateUpdated?(state)
    }

    func updateQuoteListState(_ state: QuoteListState) {
        self.state = state
        onQuoteListStateUpdated?(state)
    }
}
