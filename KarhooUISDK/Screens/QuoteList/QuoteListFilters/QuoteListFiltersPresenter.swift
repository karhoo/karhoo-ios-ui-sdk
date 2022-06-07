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

    private let router: QuoteListFiltersRouter
    private let onFiltersConfirmed: ([String]) -> Void

    init(
        router: QuoteListFiltersRouter,
        onFiltersConfirmed: @escaping ([String]) -> Void
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
            onFiltersConfirmed([])
        }
        router.dismiss()
    }
}
