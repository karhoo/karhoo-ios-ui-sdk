//
//  KarhooQuoteListPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import Adyen

final class KarhooQuoteListPresenter: QuoteListPresenter {

    // MARK: - Properties

    private let journeyDetailsManager: JourneyDetailsManager
    private let quoteService: QuoteService
    private var fetchedQuotes: Quotes?
    private var quotesObserver: KarhooSDK.Observer<Quotes>?
    private var quoteSearchObservable: KarhooSDK.Observable<Quotes>?
    private var selectedQuoteCategory: QuoteCategory?
    private var selectedQuoteOrder: QuoteListSortOrder = .qta
    private let quoteSorter: QuoteSorter
    private let analytics: Analytics
    private let router: QuoteListRouter
    var onCategoriesUpdated: (([QuoteCategory], String) -> Void)?
    var onStateUpdated: ((QuoteListState) -> Void)?

    // MARK: - Lifecycle

    init(
        journeyDetails: JourneyDetails? = nil,
        router: QuoteListRouter,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.router = router
        self.journeyDetailsManager = journeyDetailsManager
        self.quoteService = quoteService
        self.quoteSorter = quoteSorter
        self.analytics = analytics
        journeyDetailsManager.add(observer: self)
        
        if let journeyDetails = journeyDetails {
            journeyDetailsManager.silentReset(with: journeyDetails)
        }
    }

    deinit {
        journeyDetailsManager.remove(observer: self)
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else {
            assertionFailure("Unable to get data to upload")
            return
        }
        analytics.quoteListOpened(journeyDetails)
        journeyDetailsChanged(details: journeyDetailsManager.getJourneyDetails())
    }

    // MARK: - Endpoints

    func selectedQuoteCategory(_ category: QuoteCategory) {
        selectedQuoteCategory = category
        updateViewQuotes()
    }
    
    func didSelectQuoteOrder(_ order: QuoteListSortOrder) {
        selectedQuoteOrder = order
        updateViewQuotes()
    }

    func didSelectQuote(_ quote: Quote) {
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else { return }
        router.routeToQuote(quote, journeyDetails: journeyDetails)
    }

    func didSelectQuoteDetails(_ quote: Quote) {
    }

    func didSelectCategory(_ category: QuoteCategory) {
        selectedQuoteCategory = category
        updateViewQuotes()
    }

    func didSelectShowSort() {
        router.routeToSort(selectedSortOrder: selectedQuoteOrder)
    }

    func didSelectShowFilters() {
        // TODO: Implement routing
    }

    // MARK: - Private

    private func quoteSearchSuccessResult(_ quotes: Quotes, journeyDetails: JourneyDetails) {
        // Checkout component required this data
        setExpirationDates(of: quotes)
        fetchedQuotes = quotes
        // Why order is set based on location details?
        if journeyDetails.destinationLocationDetails != nil, journeyDetails.isScheduled {
            selectedQuoteOrder = .price
        }
        updateViewQuotes()
    }

    private func quoteSearchErrorResult(_ error: KarhooError?) {
        guard let error = error else {
            return
        }
        switch error.type {
        case .noAvailabilityInRequestedArea:
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            onStateUpdated?(.empty(reason: .noAvailabilityInRequestedArea))
        case .originAndDestinationAreTheSame:
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            onStateUpdated?(.empty(reason: .originAndDestinationAreTheSame))
        default: break
        }
    }
    
    private func handleQuotePolling() {
        guard let quotesValidity = fetchedQuotes?.validity else {
            assertionFailure()
            return
        }
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(quotesValidity)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            self?.refreshSubscription()
        }
    }
    
    private func handleQuoteStatus() {
        guard fetchedQuotes?.status == .completed else { return }
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        handleQuotePolling()
    }

    private func setExpirationDates(of quotes: Quotes) {
        quotes.all.forEach { $0.setExpirationDate(using: quotes.validity) }
    }

    private func updateViewQuotes() {
        guard let fetchedQuotes = self.fetchedQuotes else { return }

        let quotesToShow: [Quote]
        
        // TODO: Change filtering logic, not use names as a comparator
        if selectedQuoteCategory?.categoryName == UITexts.Availability.allCategory || selectedQuoteCategory == nil {
            quotesToShow = fetchedQuotes.all
        } else {
            quotesToShow = fetchedQuotes.quoteCategories
                .filter {
                    $0.categoryName == selectedQuoteCategory?.categoryName }
                .first?.quotes ?? []
        }
        
        let noQuotesInSelectedCategory = quotesToShow.isEmpty && fetchedQuotes.all.isEmpty == false
        let noQuotesForTimeAndArea = fetchedQuotes.all.isEmpty && fetchedQuotes.status == .completed
        let sortedQuotes = quoteSorter.sortQuotes(quotesToShow, by: selectedQuoteOrder)

        onCategoriesUpdated?(fetchedQuotes.quoteCategories, fetchedQuotes.quoteListId)

        switch (noQuotesForTimeAndArea, noQuotesInSelectedCategory, fetchedQuotes.status) {
        case (true, _, _):
            onStateUpdated?(.empty(reason: .noResults))
        case (_, true, _):
            onStateUpdated?(.empty(reason: .noQuotesInSelectedCategory))
        case (_, _, .completed):
            onStateUpdated?(.fetched(quotes: sortedQuotes))
        case (_, _, .progressing) where fetchedQuotes.all.isEmpty:
            onStateUpdated?(.loading)
        case (_, _, _):
            onStateUpdated?(.fetching(quotes: sortedQuotes))
        }

        handleQuoteStatus()
    }

    private func handleResult(result: Result<Quotes>, journeyDetails: JourneyDetails) {
        switch result {
        case .success(let quotes):
            quoteSearchSuccessResult(quotes, journeyDetails: journeyDetails)
        case .failure(let error):
            quoteSearchErrorResult(error)
        @unknown default:
            break
        }
    }
    
    private func refreshSubscription() {
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        quoteSearchObservable?.subscribe(observer: quotesObserver)
    }
}

// MARK: - JourneyDetailsObserver
extension KarhooQuoteListPresenter: JourneyDetailsObserver {

    func journeyDetailsChanged(details: JourneyDetails?) {
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        guard let details = details else {
            return
        }
        guard let destination = details.destinationLocationDetails,
            let origin = details.originLocationDetails else {
            onStateUpdated?(.empty(reason: .destinationOrOriginEmpty))
            return
        }
        onStateUpdated?(.loading)
        let quoteSearch = QuoteSearch(origin: origin,
                                      destination: destination,
                                      dateScheduled: details.scheduledDate)
        quotesObserver = KarhooSDK.Observer<Quotes> { [weak self] result in
            guard details == self?.journeyDetailsManager.getJourneyDetails() else { return }
            self?.handleResult(result: result, journeyDetails: details)
        }
        quoteSearchObservable = quoteService.quotes(quoteSearch: quoteSearch).observable()
        refreshSubscription()
    }
}
