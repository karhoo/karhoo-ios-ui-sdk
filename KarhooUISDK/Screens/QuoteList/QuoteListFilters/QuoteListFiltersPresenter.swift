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
    private let filterModelHandler: QuoteListFilterModelHandler
    private let onResultsForFiltersChosen: (QuoteListSelectedFiltersModel) -> Int
    private let onFiltersConfirmed: (QuoteListSelectedFiltersModel) -> Void

    // MARK: - Lifecycle

    init(
        router: QuoteListFiltersRouter,
        filterModelHandler: QuoteListFilterModelHandler,
        onResultsForFiltersChosen: @escaping (QuoteListSelectedFiltersModel) -> Int,
        onFiltersConfirmed: @escaping (QuoteListSelectedFiltersModel) -> Void
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
        filterModelHandler.filterSelected(filter)
    }
    
    func filterDeselected(_ filter: QuoteListFilter) {
        filterModelHandler.filterDeselected(filter)
    }

    func close(save: Bool) {
        if save {
            onFiltersConfirmed(filterModelHandler.filterModel)
        }
        router.dismiss()
    }

}
