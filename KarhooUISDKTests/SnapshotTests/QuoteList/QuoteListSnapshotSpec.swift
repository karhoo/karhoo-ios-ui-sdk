//
//  QuoteListSnapshotSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 17/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import KarhooSDK

@testable import KarhooUISDK

class QuoteListSnapshotSpec: QuickSpec {

    override func spec() {
        describe("QuoteList") {
            var sut: KarhooQuoteListViewController!
            var presenterMock: MockQuoteListPresenter!

            beforeEach {
                sut = KarhooQuoteListViewController()
                presenterMock = MockQuoteListPresenter()
                sut.setupBinding(presenterMock)
            }

            context("when the view is opened") {

                it("should have valid design") {
                    testSnapshot(sut)
                }
            }
        }
    }
}

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
