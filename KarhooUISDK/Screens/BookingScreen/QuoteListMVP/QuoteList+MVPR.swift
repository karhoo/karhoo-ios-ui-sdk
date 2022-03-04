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
        case KarhooErrorQ0001
        case noQuotesInSelectedCategory // error message: UITexts.Availability.noQuotesInSelectedCategory
        case noQuotesForSelectedParameters // error message: UITexts.Availability.noQuotesForSelectedParameters
        case example
    }
}

public protocol QuoteListView: UIViewController {

    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?)

}

protocol QuoteListPresenter: AnyObject {
    
    var onStateUpdated: ((QuoteListState) -> Void)? { get set }

    func screenWillAppear()

    func selectedQuoteCategory(_ category: QuoteCategory)

    func didSelectQuoteOrder(_ order: QuoteSortOrder)

    func didSelectQuote(_ quote: Quote)

    func didSelectQuoteDetails(_ quote: Quote)

    func didSelectCategory(_ category: QuoteCategory)
}

protocol QuoteListRouter {

    func routeToQuote(_ quote: Quote)

    func routeToQuoteDetails(_ quote: Quote)
}
