//
//  QuoteListMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import UIKit

public protocol QuoteListView: UIViewController {

    func showQuotes(_ quotes: [Quote], animated: Bool)

    func set(quoteListActions: QuoteListActions)

    func showEmptyDataSetMessage(_ message: String)

    func hideEmptyDataSetMessage()

    func toggleCategoryFilteringControls(show: Bool)

    func showLoadingView()

    func hideLoadingView()

    func didSelectQuoteCategory(_ category: QuoteCategory)

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?)

    func showQuoteSorter()

    func hideQuoteSorter()

    func quotesAvailabilityDidUpdate(availability: Bool)
    
    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?)

    var tableView: UITableView! { get }
}

protocol QuoteListPresenter {

    func screenWillAppear()

    func selectedQuoteCategory(_ category: QuoteCategory)

    func didSelectQuoteOrder(_ order: QuoteSortOrder)
}

public protocol QuoteListActions: AnyObject {

    func didSelectQuote(_ quote: Quote)

    func quotesAvailabilityDidUpdate(availability: Bool)
}
