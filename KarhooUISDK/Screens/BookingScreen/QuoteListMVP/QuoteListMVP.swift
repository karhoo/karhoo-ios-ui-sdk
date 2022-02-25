//
//  QuoteListMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

public enum QuoteListState {
    case loading
    case fetched(quotes: [Quote])
    case empty(reason: Error)

    public enum Error {
        case destinationOrOriginEmpty
        case noResults
        case noAvailabilityInRequestedArea
        case originAndDestinationAreTheSame
        case example
    }
}

public protocol QuoteListView: UIViewController {

    func showQuotes(_ quotes: [Quote], animated: Bool) // list state

    func set(quoteListActions: QuoteListActions)

    func showEmptyDataSetMessage(_ message: String) // list state

    func hideEmptyDataSetMessage() // list state

    func toggleCategoryFilteringControls(show: Bool)

//    func showLoadingView() // list state
//
//    func hideLoadingView() // list state

    func didSelectQuoteCategory(_ category: QuoteCategory)

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?)

    func showQuoteSorter()

    func hideQuoteSorter()

    func quotesAvailabilityDidUpdate(availability: Bool)
    
    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?)

    var tableView: UITableView! { get }

    // New

    func updateState(_ state: QuoteListState)
}

protocol QuoteListPresenter: AnyObject {
    
    var onStateUpdated: ((QuoteListState) -> Void)? { get set }

    func screenWillAppear()

    func selectedQuoteCategory(_ category: QuoteCategory)

    func didSelectQuoteOrder(_ order: QuoteSortOrder)
}

public protocol QuoteListActions: AnyObject {

    func didSelectQuote(_ quote: Quote)

    func quotesAvailabilityDidUpdate(availability: Bool)
}
