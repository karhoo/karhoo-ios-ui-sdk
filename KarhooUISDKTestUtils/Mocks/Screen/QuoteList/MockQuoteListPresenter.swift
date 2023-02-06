//
//  MockQuoteListPresenter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 19/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

public class MockQuoteListPresenter: QuoteListViewModel {
    public init() { }

    public var onStateUpdatedCallback: () -> Void = {}
    lazy public var onStateUpdated: ((KarhooUISDK.QuoteListState) -> Void)? = { _ in
        self.onStateUpdatedCallback()
    }

    public var onFiltersCountUpdatedCallback: () -> Void = {}
    lazy public var onFiltersCountUpdated: ((Int) -> Void)? = { _ in
        self.onFiltersCountUpdatedCallback()
    }

    public var isSortingAvailableToReturn = true
    public var isSortingAvailable: Bool { isSortingAvailableToReturn }

    public func viewDidLoad() {
    }

    public func viewWillAppear() {
    }

    public func viewWillDisappear() {
    }

    public var getNumberOfResultsForQuoteFiltersToReturn = 0
    public func getNumberOfResultsForQuoteFilters(_ filters: [KarhooUISDK.QuoteListFilter]) -> Int {
        getNumberOfResultsForQuoteFiltersToReturn
    }

    public var selectedQuoteFiltersCalled = false
    public func selectedQuoteFilters(_ filters: [KarhooUISDK.QuoteListFilter]) {
        selectedQuoteFiltersCalled = true
    }

    public var didSelectQuoteSortOrderCalled = false
    public func didSelectQuoteSortOrder(_ order: KarhooUISDK.QuoteListSortOrder) {
        didSelectQuoteSortOrderCalled = true
    }

    public var didSelectQuoteCalled = false
    public func didSelectQuote(_ quote: KarhooSDK.Quote) {
        didSelectQuoteCalled = true
    }

    public var didSelectQuoteDetails = false
    public func didSelectQuoteDetails(_ quote: KarhooSDK.Quote) {
        didSelectQuoteDetails = true
    }

    public var didSelectShowSortCalled = false
    public func didSelectShowSort() {
        didSelectShowSortCalled = true
    }

    public var didSelectShowFiltersCalled = false
    public func didSelectShowFilters() {
        didSelectShowFiltersCalled = true
    }
}
