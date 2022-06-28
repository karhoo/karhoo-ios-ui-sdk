//  
//  QuoteListFiltersPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteListFiltersPresenter: QuoteListFiltersPresenter {

    // MARK: - Properties

    private let router: QuoteListFiltersRouter
    private let onResultsForFiltersChosen: ([QuoteListFilter]) -> Int
    private let onFiltersConfirmed: ([QuoteListFilter]) -> Void
    private(set) var filters: [QuoteListFilter]

    // MARK: - Lifecycle

    init(
        filters: [QuoteListFilter],
        router: QuoteListFiltersRouter,
        onResultsForFiltersChosen: @escaping ([QuoteListFilter]) -> Int,
        onFiltersConfirmed: @escaping ([QuoteListFilter]) -> Void
    ) {
        self.filters = filters
        self.router = router
        self.onResultsForFiltersChosen = onResultsForFiltersChosen
        self.onFiltersConfirmed = onFiltersConfirmed
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    // MARK: - Communication methods

    func filterSelected(_ filter: [QuoteListFilter], for category: QuoteListFilters.Category) {
        filters.removeAll { $0.filterCategory == category }
        filters.append(contentsOf: filter)
    }

    func close(save: Bool) {
        if save {
            onFiltersConfirmed(filters)
        }
        router.dismiss()
    }

    func resetFilter() {
        filters = []
    }

    func resultsCountForSelectedFilters() -> Int {
        onResultsForFiltersChosen(filters)
    }
}
