//
//  KarhooQuoteListPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import Foundation
import UIKit

final class KarhooQuoteListViewModel: QuoteListViewModel {

    // MARK: - Properties

    private let journeyDetailsManager: JourneyDetailsManager
    private let quoteService: QuoteService
    private var fetchedQuotes: Quotes?
    private var quotesObserver: KarhooSDK.Observer<Quotes>?
    private var quoteSearchObservable: KarhooSDK.Observable<Quotes>?
    private var selectedQuoteOrder: QuoteListSortOrder = .price
    private let quoteSorter: QuoteSorter
    private let quoteFilter: QuoteFilterHandler
    private let analytics: Analytics
    private let router: QuoteListRouter
    var onStateUpdated: ((QuoteListState) -> Void)?
    var onFiltersCountUpdated: ((Int) -> Void)?
    var onQuotesUpdated: () -> Void
    private var dateOfListReceiving: Date?
    private var isViewVisible = false
    private let minimumAcceptedValidityToQuoteRefresh: TimeInterval = 120
    var isSortingAvailable: Bool = true

    // MARK: - Lifecycle

    init(
        journeyDetails: JourneyDetails? = nil,
        router: QuoteListRouter,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        quoteFilter: QuoteFilterHandler = KarhooQuoteFilterHandler(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        onQuotesUpdated: @escaping () -> Void
    ) {
        self.router = router
        self.journeyDetailsManager = journeyDetailsManager
        self.quoteService = quoteService
        self.quoteSorter = quoteSorter
        self.quoteFilter = quoteFilter
        self.analytics = analytics
        self.onQuotesUpdated = onQuotesUpdated
        journeyDetailsManager.add(observer: self)
        
        if let journeyDetails = journeyDetails {
            journeyDetailsManager.silentReset(with: journeyDetails)
        }
    }

    deinit {
        journeyDetailsManager.remove(observer: self)
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        unsubscribeFromBecomeAndResignActiveNotifications()
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        subscribeToBecomeAndResignActiveNotifications()
        isViewVisible = true
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else {
            return
        }
        analytics.quoteListOpened(journeyDetails)
        if shouldReloadQuotes() {
            journeyDetailsChanged(details: journeyDetailsManager.getJourneyDetails())
        }
    }

    func viewWillDisappear() {
        isViewVisible = false
        unsubscribeFromBecomeAndResignActiveNotifications()
        reportHowManyQuotesHasBeenShown()
    }

    // MARK: - Endpoints

    func didSelectQuoteSortOrder(_ order: QuoteListSortOrder) {
        selectedQuoteOrder = order
        updateViewQuotes()
    }

    func didSelectQuote(_ quote: Quote) {
        guard var journeyDetails = journeyDetailsManager.getJourneyDetails() else { return }
        let passengersCountFilter = quoteFilter.filters.first(where: { $0.filterCategory == .passengers }) as? QuoteListNumericFilter
        let luggagesCountFilter = quoteFilter.filters.first(where: { $0.filterCategory == .luggage }) as? QuoteListNumericFilter
        
        journeyDetails.passangersCount = passengersCountFilter?.value ?? QuoteListFilters.defaultPassengersCount
        journeyDetails.luggagesCount = luggagesCountFilter?.value ?? QuoteListFilters.defaultLuggagesCount

        router.routeToQuote(quote, journeyDetails: journeyDetails)
    }

    func didSelectQuoteDetails(_ quote: Quote) {
    }

    func getNumberOfResultsForQuoteFilters(_ filters: [QuoteListFilter]) -> Int {
        guard let quotes = fetchedQuotes else { return 0 }
        return quoteFilter.filter(quotes.all, using: filters).count
    }

    func selectedQuoteFilters(_ filters: [QuoteListFilter]) {
        quoteFilter.filters = filters
        onFiltersCountUpdated?(filters.count)
        updateViewQuotes()
    }

    func didSelectShowSort() {
        router.routeToSort(selectedSortOrder: selectedQuoteOrder)
    }

    func didSelectShowFilters() {
        router.routeToFilters(quoteFilter.filters)
    }

    // MARK: - Private

    private func subscribeToBecomeAndResignActiveNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeActivityState), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeActivityState), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    private func unsubscribeFromBecomeAndResignActiveNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    private func shouldReloadQuotes() -> Bool {
        guard let fireDate = dateOfListReceiving else { return true }
        let intervalToFire = fireDate.timeIntervalSinceNow
        // NOTE: 'fireDate.timeIntervalSinceNow' is negative when list is reloading and new timer is not started yet
        return  intervalToFire > 0 && intervalToFire < minimumAcceptedValidityToQuoteRefresh
    }

    @objc func didChangeActivityState(_ notification: Notification) {
        if notification.name == UIApplication.didBecomeActiveNotification {
            isViewVisible = true
            if shouldReloadQuotes() {
                journeyDetailsChanged(details: journeyDetailsManager.getJourneyDetails())
            }
        } else if notification.name == UIApplication.willResignActiveNotification {
            isViewVisible = false
        }
    }

    private func quoteSearchSuccessResult(_ quotes: Quotes, journeyDetails: JourneyDetails) {
        // Checkout component requires this data
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
        dateOfListReceiving = Date().addingTimeInterval(Double(quotesValidity))
        DispatchQueue.main.asyncAfter(deadline: deadline) {[weak self] in
            if self?.isViewVisible == true {
                self?.refreshSubscription()
            } else {
                self?.dateOfListReceiving = nil
            }
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
        guard let fetchedQuotes = fetchedQuotes else { return }

        let quotesToShow: [Quote] = quoteFilter.filter(fetchedQuotes.all)

        let noQuotesForSelectedFilters = quotesToShow.isEmpty && fetchedQuotes.all.isEmpty == false
        let noQuotesForTimeAndArea = fetchedQuotes.all.isEmpty && fetchedQuotes.status == .completed

        let sortedQuotes = quoteSorter.sortQuotes(quotesToShow, by: selectedQuoteOrder)

        switch (noQuotesForTimeAndArea, noQuotesForSelectedFilters, fetchedQuotes.status) {
        case (true, _, _):
            let journeyDetails = journeyDetailsManager.getJourneyDetails()
            switch journeyDetails?.isScheduled {
            case false:
                onStateUpdated?(.empty(reason: .noAvailabilityInRequestedArea))
            default:
                onStateUpdated?(.empty(reason: .noResults))
            }
        case (_, true, _):
            onStateUpdated?(.empty(reason: .noQuotesAfterFiltering))
        case (_, _, .completed):
            onStateUpdated?(.fetched(quotes: sortedQuotes))
        case (_, _, .progressing) where fetchedQuotes.all.isEmpty:
            onStateUpdated?(.loading)
        case (_, _, _):
            onStateUpdated?(.fetching(quotes: sortedQuotes))
        }
        onQuotesUpdated()
        handleQuoteStatus()
    }

    private func handleResult(result: Result<Quotes>, journeyDetails: JourneyDetails) {
        switch result {
        case .success(let quotes, _):
            quoteSearchSuccessResult(quotes, journeyDetails: journeyDetails)
        case .failure(let error, _):
            quoteSearchErrorResult(error)
        @unknown default:
            break
        }
    }
    
    private func refreshSubscription() {
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        quoteSearchObservable?.subscribe(observer: quotesObserver)
    }

    private func reportHowManyQuotesHasBeenShown() {
        guard
            let quoteListId = fetchedQuotes?.quoteListId,
            let quotesCount = fetchedQuotes?.all.count
        else {
            return
        }
        analytics.fleetsShown(
            quoteListId: quoteListId,
            amountShown: quotesCount
        )
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
        if dateOfListReceiving == nil {
            dateOfListReceiving = Date()
        }
        isSortingAvailable = !details.isScheduled
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
