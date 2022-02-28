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
    private var selectedQuoteOrder: QuoteSortOrder = .qta
    private let quoteSorter: QuoteSorter
    private let analytics: Analytics
    private let router: QuoteListRouter
    private var isSubscribed: Bool = false
    var onStateUpdated: ((QuoteListState) -> Void)?

    // MARK: - Lifecycle

    init(
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
    }

    deinit {
        journeyDetailsManager.remove(observer: self)
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
    }

    func screenWillAppear() {
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else {
            assertionFailure("Unable to get data to upload")
            return
        }
        analytics.quoteListOpened(journeyDetails)
    }

    // MARK: - Endpoints

    func selectedQuoteCategory(_ category: QuoteCategory) {
        self.selectedQuoteCategory = category
        updateViewQuotes(animated: true)
    }

    func didSelectQuoteOrder(_ order: QuoteSortOrder) {
        self.didSelectQuoteOrder(order, animated: true)
    }

    func didSelectQuoteOrder(_ order: QuoteSortOrder, animated: Bool) {
        self.selectedQuoteOrder = order
        updateViewQuotes(animated: animated)
    }

    func didSelectQuote(_ quote: Quote) {
        router.routeToQuote(quote)
    }

    func didSelectQuoteDetails(_ quote: Quote) {
        // TODO: finish implementation
    }

    func didSelectCategory(_ category: QuoteCategory) {
        // TODO: finish implementation
    }

    // MARK: - Private

    private func quoteSearchSuccessResult(_ quotes: Quotes, journeyDetails: JourneyDetails?) {
        self.fetchedQuotes = quotes
        if journeyDetails?.destinationLocationDetails != nil, journeyDetails?.isScheduled == true {
            didSelectQuoteOrder(.price, animated: false)
        } else {
            updateViewQuotes(animated: false)
        }
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
            // TODO: Decide which error should be presented
            onStateUpdated?(.empty(reason: .KarhooErrorQ0001))
            onStateUpdated?(.empty(reason: .originAndDestinationAreTheSame))
        default: break
        }
    }
    
    private func handleQuotePolling() {
        // Magic
//        let timer = fetchedQuotes!.validity
//        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(timer)
//
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
////            self.quoteSearchObservable?.subscribe(observer: self.quotesObserver)
//        }
    }
    
    private func handleQuoteStatus() {
        guard let fetchedQuotes = self.fetchedQuotes else {
            return
        }
        
        if fetchedQuotes.status == .completed {
//            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
//            handleQuotePolling()
        }
    }

    private func setExpirationDates(of quotes: Quotes) {
        quotes.all.forEach { $0.setExpirationDate(using: quotes.validity) }
    }

    private func updateViewQuotes(animated: Bool) {
        guard let fetchedQuotes = self.fetchedQuotes,
              let selectedCategory = self.selectedQuoteCategory else {
            return
        }

        let quotesToShow: [Quote]

        if selectedQuoteCategory?.categoryName == UITexts.Availability.allCategory {
            quotesToShow = fetchedQuotes.all
        } else {
            quotesToShow = fetchedQuotes.quoteCategories
                .filter { $0.categoryName == selectedCategory.categoryName }.first?.quotes ?? []
        }

        if quotesToShow.isEmpty && fetchedQuotes.all.isEmpty == false {
            onStateUpdated?(.empty(reason: .noQuotesInSelectedCategory))
        } else if quotesToShow.isEmpty && fetchedQuotes.all.isEmpty == true && fetchedQuotes.status == .completed {
            onStateUpdated?(.empty(reason: .noQuotesForSelectedParameters))
        } else {
            let sortedQuotes = quoteSorter.sortQuotes(quotesToShow, by: selectedQuoteOrder)
            onStateUpdated?(.fetched(quotes: sortedQuotes))
        }
        
        handleQuoteStatus()

    }

    private func handleResult(result: Result<Quotes>, jurneyDetails: JourneyDetails) {
        print("KarhooQuoteListPresenter – result updated \(Date())")
        if result.successValue()?.all.isEmpty == false {
            self.onStateUpdated?(.empty(reason: .noResults))
        }

        switch result {
        case .success(let quotes):
            self.setExpirationDates(of: quotes)
            self.quoteSearchSuccessResult(quotes, journeyDetails: jurneyDetails)
//                if details.destinationLocationDetails != nil, details.scheduledDate != nil {
//                    self?.quoteListView?.hideQuoteSorter()
//                }

            if quotes.all.isEmpty && quotes.status != .completed {
                self.onStateUpdated?(.loading)
//                    self?.quoteListView?.toggleCategoryFilteringControls(show: false)
            } else if quotes.all.isEmpty && quotes.status == .completed {
                self.onStateUpdated?(.empty(reason: .noResults))
//                    self?.quoteListView?.toggleCategoryFilteringControls(show: false)
            }

        case .failure(let error):
            self.quoteSearchErrorResult(error)
        @unknown default:
            break
        }
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
            self?.handleResult(result: result, jurneyDetails: details)
        }
        quoteSearchObservable = quoteService.quotes(quoteSearch: quoteSearch).observable()
        
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        quoteSearchObservable?.subscribe(observer: quotesObserver)
    }
}
