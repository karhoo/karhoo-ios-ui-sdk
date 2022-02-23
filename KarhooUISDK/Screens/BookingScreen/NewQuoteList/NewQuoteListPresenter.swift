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
    var quotes: [Quote]
    var onQuoteListStateUpdated: ((QuoteListStete) -> Void)?

    init(
        router: NewQuoteListRouter,
        quotes: [Quote],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) {
        self.router = router
        self.quotes = quotes
        self.onQuoteSelected = onQuoteSelected
        self.onQuoteDetailsSelected = onQuoteDetailsSelected
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        if quotes.isNotEmpty {
            onQuoteListStateUpdated?(.fetched(quotes: quotes))
        }
    }
}
