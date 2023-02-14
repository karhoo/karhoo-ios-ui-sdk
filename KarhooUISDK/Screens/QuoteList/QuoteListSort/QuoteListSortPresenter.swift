//  
//  QuoteListSortPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteListSortPresenter: QuoteListSortPresenter {

    var sortOptions: [QuoteListSortOrder] {
        QuoteListSortOrder.allCases
    }
    private(set) var selectedSortOption: QuoteListSortOrder
    private let onSortOptionComfirmed: (QuoteListSortOrder) -> Void
    
    private let router: QuoteListSortRouter

    init(
        router: QuoteListSortRouter,
        selectedOption: QuoteListSortOrder,
        onSortOptionComfirmed: @escaping (QuoteListSortOrder) -> Void
    ) {
        self.selectedSortOption = selectedOption
        self.onSortOptionComfirmed = onSortOptionComfirmed
        self.router = router
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    func close(save: Bool) {
        if save {
            onSortOptionComfirmed(selectedSortOption)
        }
        router.dismiss()
    }

    func set(sortOption: QuoteListSortOrder) {
        selectedSortOption = sortOption
    }
}
