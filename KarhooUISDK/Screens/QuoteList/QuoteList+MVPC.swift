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
    case fetching(quotes: [Quote])
    case fetched(quotes: [Quote])
    case empty(reason: Error)

    // TODO: once all error handling tickets will be done, remove not needed error cases
    public enum Error {
        case destinationOrOriginEmpty
        case noResults
        case noAvailabilityInRequestedArea
        case originAndDestinationAreTheSame
        case KarhooErrorQ0001
        case noQuotesInSelectedCategory // error message: UITexts.Availability.noQuotesInSelectedCategory
        case noQuotesForSelectedParameters // error message: UITexts.Availability.noQuotesForSelectedParameters
    }
}

public protocol QuoteListCoordinator: KarhooUISDKSceneCoordinator {
}

protocol QuoteListViewController: BaseViewController {

    func setupBinding(_ presenter: QuoteListPresenter)
}

protocol QuoteListPresenter: AnyObject {
    
    var onCategoriesUpdated: (([QuoteCategory], String) -> Void)? { get set }

    var onStateUpdated: ((QuoteListState) -> Void)? { get set }

    func viewDidLoad()

    func viewWillAppear()

    func selectedQuoteCategory(_ category: QuoteCategory)

    func didSelectQuoteOrder(_ order: QuoteListSortOrder)

    func didSelectQuote(_ quote: Quote)

    func didSelectQuoteDetails(_ quote: Quote)

    func didSelectCategory(_ category: QuoteCategory)

    func didSelectShowSort()

    func didSelectShowFilters()
}

protocol QuoteListRouter: AnyObject {

    func routeToQuote(_ quote: Quote, journeyDetails: JourneyDetails)

    func routeToQuoteDetails(_ quote: Quote)

    func routeToSort(selectedSortOrder: QuoteListSortOrder)
}
