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
    private let filterModelHandler: QuoteFilterHandler
    private let onResultsForFiltersChosen: ([QuoteListFilter]) -> Int
    private let onFiltersConfirmed: ([QuoteListFilter]) -> Void
    private var filters: [QuoteListFilter] = []

    // MARK: - Lifecycle

    init(
        router: QuoteListFiltersRouter,
        filterModelHandler: QuoteFilterHandler = KarhooQuoteFilterHandler(),
        onResultsForFiltersChosen: @escaping ([QuoteListFilter]) -> Int,
        onFiltersConfirmed: @escaping ([QuoteListFilter]) -> Void
    ) {
        self.router = router
        self.filterModelHandler = filterModelHandler
        self.onResultsForFiltersChosen = onResultsForFiltersChosen
        self.onFiltersConfirmed = onFiltersConfirmed
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    // MARK: - Communication methods

    func filterSelected(_ filter: QuoteListFilter) {
        filters.append(filter)
    }
    
    func filterDeselected(_ filter: QuoteListFilter) {
        filters.removeAll { $0.localizedString == filter.localizedString && $0.filterCategory == filter.filterCategory }
    }

    func close(save: Bool) {
        if save {
            onFiltersConfirmed(filters)
        }
        router.dismiss()
    }

}
