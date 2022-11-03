//
//  MockQuoteListSortPresenter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 26/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

class MockQuoteListSortPresenter: QuoteListSortPresenter {

    var sortOptionsToReturn: [KarhooUISDK.QuoteListSortOrder] = KarhooUISDK.QuoteListSortOrder.allCases
    var sortOptions: [KarhooUISDK.QuoteListSortOrder] {
        sortOptionsToReturn
    }

    var selectedSortOptionToReturn = KarhooUISDK.QuoteListSortOrder.price
    var selectedSortOption: KarhooUISDK.QuoteListSortOrder {
        selectedSortOptionToReturn
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    var setSortOptionCalled = false
    func set(sortOption: KarhooUISDK.QuoteListSortOrder) {
        setSortOptionCalled = true
    }

    var closeWithSaveCalled = false
    var closeCalled = false
    func close(save: Bool) {
        closeWithSaveCalled = save
        closeCalled = true
    }
}
