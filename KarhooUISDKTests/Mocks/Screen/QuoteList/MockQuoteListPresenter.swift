//
//  MockQuoteListPresenter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 19/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

class MockQuoteListPresenter: QuoteListPresenter {
    var onStateUpdatedCallback: () -> Void = {}
    lazy var onStateUpdated: ((KarhooUISDK.QuoteListState) -> Void)? = { _ in
        self.onStateUpdatedCallback()
    }

    var onFiltersCountUpdatedCallback: () -> Void = {}
    lazy var onFiltersCountUpdated: ((Int) -> Void)? = { _ in
        self.onFiltersCountUpdatedCallback()
    }

    var isSortingAvailableToReturn = false
    var isSortingAvailable: Bool { isSortingAvailableToReturn }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    func viewWillDisappear() {
    }

    var getNumberOfResultsForQuoteFiltersToReturn = 0
    func getNumberOfResultsForQuoteFilters(_ filters: [KarhooUISDK.QuoteListFilter]) -> Int {
        getNumberOfResultsForQuoteFiltersToReturn
    }

    var selectedQuoteFiltersCalled = false
    func selectedQuoteFilters(_ filters: [KarhooUISDK.QuoteListFilter]) {
        selectedQuoteFiltersCalled = true
    }

    var didSelectQuoteSortOrderCalled = false
    func didSelectQuoteSortOrder(_ order: KarhooUISDK.QuoteListSortOrder) {
        didSelectQuoteSortOrderCalled = true
    }

    var didSelectQuoteCalled = false
    func didSelectQuote(_ quote: KarhooSDK.Quote) {
        didSelectQuoteCalled = true
    }

    var didSelectQuoteDetails = false
    func didSelectQuoteDetails(_ quote: KarhooSDK.Quote) {
        didSelectQuoteDetails = true
    }

    var didSelectShowSortCalled = false
    func didSelectShowSort() {
        didSelectShowSortCalled = true
    }

    var didSelectShowFiltersCalled = false
    func didSelectShowFilters() {
        didSelectShowFiltersCalled = true
    }
}
