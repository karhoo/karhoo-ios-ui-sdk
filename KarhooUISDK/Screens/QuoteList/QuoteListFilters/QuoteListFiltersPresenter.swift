//  
//  QuoteListFiltersPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol QuoteListFilter {
}

class KarhooQuoteListFiltersPresenter: QuoteListFiltersPresenter {

    private let router: QuoteListFiltersRouter
    private let onFiltersConfirmed: ([QuoteListFilter]) -> Void
    private var selectedFilters: [QuoteListFilter] = []
    init(
        router: QuoteListFiltersRouter,
        onFiltersConfirmed: @escaping ([QuoteListFilter]) -> Void
    ) {
        self.router = router
        self.onFiltersConfirmed = onFiltersConfirmed
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    func close(save: Bool) {
        if save {
            onFiltersConfirmed(selectedFilters)
        }
        router.dismiss()
    }
}
