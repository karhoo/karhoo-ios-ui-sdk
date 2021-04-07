//
//  MockQuoteListView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockQuoteListView: UIViewController, QuoteListView {

    private(set) var quotesSet: [Quote]?
    private(set) var showQuotesAnimated: Bool?
    func showQuotes(_ quotes: [Quote], animated: Bool) {
        self.quotesSet = quotes
        showQuotesAnimated = animated
    }

    private(set) var quoteListActionsSet: QuoteListActions?
    func set(quoteListActions: QuoteListActions) {
        quoteListActionsSet = quoteListActions
    }

    private(set) var emptyDataSetMessageSet: String?
    func showEmptyDataSetMessage(_ message: String) {
        emptyDataSetMessageSet = message
    }

    private(set) var hideEmptyDataSetMessageCalled = false
    func hideEmptyDataSetMessage() {
        hideEmptyDataSetMessageCalled = true
    }

    private(set) var didSelectQuoteCategoryCalled: QuoteCategory?
    func didSelectQuoteCategory(_ category: QuoteCategory) {
        didSelectQuoteCategoryCalled = category
    }

    private(set) var categoriesChangedCalled: [QuoteCategory]?
    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        categoriesChangedCalled = categories
    }

    var toggleSortingFilteringControlsShow: Bool?
    func toggleCategoryFilteringControls(show: Bool) {
        toggleSortingFilteringControlsShow = show
    }

    var showLoadingViewCalled = false
    func showLoadingView() {
        showLoadingViewCalled = true
    }

    var hideLoadingViewCalled = false
    func hideLoadingView() {
        hideLoadingViewCalled = true
    }

    private(set) var showQuoteSorterCalled = false
    func showQuoteSorter() {
        showQuoteSorterCalled = true
    }

    private(set) var hideQuoteSorterCalled = false
    func hideQuoteSorter() {
        hideQuoteSorterCalled = true
    }

    private(set) var showQuotesTitleSet: String?
    func showQuotesTitle(_ title: String) {
        showQuotesTitleSet = title
    }

    private(set) var hideQuotesTitleCalled = false
    func hideQuotesTitle() {
        hideQuotesTitleCalled = true
    }

    private(set) var availabilityCalled = false
    private(set) var availabilityValue: Bool!
    func quotesAvailabilityDidUpdate(availability: Bool) {
        availabilityCalled = true
        availabilityValue = availability
    }
    
    private(set) var categoriesDidChangeCalled = false
    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?) {
        categoriesDidChangeCalled = true
    }

    var tableView: UITableView! {
        return UITableView()
    }
}
