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
    case empty(reason: EmptyReason)

    // TODO: once all error handling tickets will be done, remove not needed error cases
    public enum EmptyReason {
        case destinationOrOriginEmpty
        case noResults
        case noAvailabilityInRequestedArea
        case originAndDestinationAreTheSame
        case KarhooErrorQ0001
        case noQuotesAfterFiltering // error message: UITexts.Availability.noQuotesInSelectedCategory
        case noQuotesForSelectedParameters // error message: UITexts.Availability.noQuotesForSelectedParameters
    }
}

public protocol QuoteListCoordinator: KarhooUISDKSceneCoordinator {
}

protocol QuoteListViewController: BaseViewController {

    func setupBinding(_ presenter: QuoteListPresenter)
}

protocol QuoteListPresenter: AnyObject {

    var onStateUpdated: ((QuoteListState) -> Void)? { get set }

    var onFiltersCountUpdated: ((Int) -> Void)? { get set }

    var isSortingAvailable: Bool { get }

    func viewDidLoad()

    func viewWillAppear()

    func viewWillDisappear()

    func getNumberOfResultsForQuoteFilters(_ filters: [QuoteListFilter]) -> Int

    func selectedQuoteFilters(_ filters: [QuoteListFilter])

    func didSelectQuoteSortOrder(_ order: QuoteListSortOrder)

    func didSelectQuote(_ quote: Quote)

    func didSelectQuoteDetails(_ quote: Quote)

    func didSelectShowSort()

    func didSelectShowFilters()
}

protocol QuoteListRouter: AnyObject {

    func routeToQuote(_ quote: Quote, journeyDetails: JourneyDetails, passengerCount: Int, luggageCount: Int)

    func routeToQuoteDetails(_ quote: Quote)

    func routeToSort(selectedSortOrder: QuoteListSortOrder)

    func routeToFilters(_ filters: [QuoteListFilter])
}
