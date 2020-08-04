//
//  QuoteListMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

public protocol QuoteListView: UIViewController {

    func showQuotes(_ quotes: [Quote], animated: Bool)

    func set(quoteListActions: QuoteListActions)

    func showEmptyDataSetMessage(_ message: String)

    func hideEmptyDataSetMessage()

    func showLoadingView()

    func hideLoadingView()

    func didSelectQuoteCategory(_ category: QuoteCategory)

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?)

    func showQuoteSorter()

    func hideQuoteSorter()

    func showQuotesTitle(_ title: String)

    func hideQuotesTitle()

    func quotesAvailabilityDidUpdate(availability: Bool)
    
    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?)

    var tableView: UITableView! { get }
}

protocol QuoteListPresenter {

    func selectedQuoteCategory(_ category: QuoteCategory)

    func didSelectQuoteOrder(_ order: QuoteSortOrder)
}

public protocol QuoteListActions: AnyObject {

    func didSelectQuote(_ quote: Quote)

    func quotesAvailabilityDidUpdate(availability: Bool)
}
