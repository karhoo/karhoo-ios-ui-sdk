//
//  MockQuoteListView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK
@testable import KarhooUISDK

final public class MockQuoteListView: UIViewController, QuoteListViewController {
    
    public var setupBindingCalled = false
    public func setupBinding(_ presenter: QuoteListViewModel) {
        setupBindingCalled = true
    }

    public var quotesSet: [Quote]?
    public var showQuotesAnimated: Bool?
    public func showQuotes(_ quotes: [Quote], animated: Bool) {
        self.quotesSet = quotes
        showQuotesAnimated = animated
    }

//    public var quoteListActionsSet: QuoteListActions?
//    public func set(quoteListActions: QuoteListActions) {
//        quoteListActionsSet = quoteListActions
//    }

    public var emptyDataSetMessageSet: String?
    public func showEmptyDataSetMessage(_ message: String) {
        emptyDataSetMessageSet = message
    }

    public var hideEmptyDataSetMessageCalled = false
    public func hideEmptyDataSetMessage() {
        hideEmptyDataSetMessageCalled = true
    }

    public var didSelectQuoteCategoryCalled: QuoteCategory?
    public func didSelectQuoteCategory(_ category: QuoteCategory) {
        didSelectQuoteCategoryCalled = category
    }

    public var categoriesChangedCalled: [QuoteCategory]?
    public func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        categoriesChangedCalled = categories
    }

    public var toggleSortingFilteringControlsShow: Bool?
    public func toggleCategoryFilteringControls(show: Bool) {
        toggleSortingFilteringControlsShow = show
    }

    public var showLoadingViewCalled = false
    public func showLoadingView() {
        showLoadingViewCalled = true
    }

    public var hideLoadingViewCalled = false
    public func hideLoadingView() {
        hideLoadingViewCalled = true
    }

    public var showQuoteSorterCalled = false
    public func showQuoteSorter() {
        showQuoteSorterCalled = true
    }

    public var hideQuoteSorterCalled = false
    public func hideQuoteSorter() {
        hideQuoteSorterCalled = true
    }

    public var showQuotesTitleSet: String?
    public func showQuotesTitle(_ title: String) {
        showQuotesTitleSet = title
    }

    public var hideQuotesTitleCalled = false
    public func hideQuotesTitle() {
        hideQuotesTitleCalled = true
    }

    public var availabilityCalled = false
    public var availabilityValue: Bool!
    public func quotesAvailabilityDidUpdate(availability: Bool) {
        availabilityCalled = true
        availabilityValue = availability
    }
    
    public var categoriesDidChangeCalled = false
    public func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?) {
        categoriesDidChangeCalled = true
    }

    public var tableView: UITableView! {
        return UITableView()
    }
}
