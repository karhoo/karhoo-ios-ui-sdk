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
    private let quoteValidityWorker: QuoteValidityWorker
    private let quoteService: QuoteService
    private var fetchedQuotes: Quotes?
    private var quotesObserver: KarhooSDK.Observer<Quotes>?
    private var quoteSearchObservable: KarhooSDK.Observable<Quotes>?
    private var quotesSearchForDetailsInProgress: JourneyDetails?
    private var currentlyUsedJourneyDetails: JourneyDetails?
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
    private let quoteListPollTime: TimeInterval = 1.2
    var isSortingAvailable: Bool = true
    private let currentLocale = UITexts.Generic.locale
    
    // MARK: - Lifecycle

    init(
        journeyDetails: JourneyDetails? = nil,
        router: QuoteListRouter,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        quoteValidityWorker: QuoteValidityWorker = KarhooQuoteValidityWorker(),
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        quoteFilter: QuoteFilterHandler = KarhooQuoteFilterHandler(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        onQuotesUpdated: @escaping () -> Void
    ) {
        self.router = router
        self.journeyDetailsManager = journeyDetailsManager
        self.quoteValidityWorker = quoteValidityWorker
        self.quoteService = quoteService
        self.quoteSorter = quoteSorter
        self.quoteFilter = quoteFilter
        self.analytics = analytics
        self.onQuotesUpdated = onQuotesUpdated
        
        if let journeyDetails = journeyDetails {
            journeyDetailsManager.silentReset(with: journeyDetails)
        }
    }

    deinit {
        cleanup()
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        journeyDetailsManager.add(observer: self)
        subscribeToBecomeAndResignActiveNotifications()
        isViewVisible = true
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else {
            return
        }
        analytics.quoteListOpened(journeyDetails)
        if shouldReloadExpiringQuotes() || journeyDetailsChanged() {
            quotesSearchForDetailsInProgress = nil
            journeyDetailsChanged(details: journeyDetailsManager.getJourneyDetails())
        }
    }

    func viewWillDisappear() {
        isViewVisible = false
        reportHowManyQuotesHasBeenShown()
        cleanup()
    }
    
    private func cleanup() {
        journeyDetailsManager.remove(observer: self)
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        unsubscribeFromBecomeAndResignActiveNotifications()
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

    private func shouldReloadExpiringQuotes() -> Bool {
        guard let fireDate = dateOfListReceiving else { return true }
        let intervalToFire = fireDate.timeIntervalSinceNow
        // NOTE: 'fireDate.timeIntervalSinceNow' is negative when list is reloading and new timer is not started yet
        return intervalToFire < minimumAcceptedValidityToQuoteRefresh
    }
    
    private func journeyDetailsChanged() -> Bool {
        currentlyUsedJourneyDetails != journeyDetailsManager.getJourneyDetails()
    }

    @objc func didChangeActivityState(_ notification: Notification) {
        if notification.name == UIApplication.didBecomeActiveNotification {
            isViewVisible = true
            if shouldReloadExpiringQuotes() {
                quotesSearchForDetailsInProgress = nil
                journeyDetailsChanged(details: journeyDetailsManager.getJourneyDetails())
            }
        } else if notification.name == UIApplication.willResignActiveNotification {
            isViewVisible = false
        }
    }

    private func quoteSearchSuccessResult(_ quotes: Quotes, journeyDetails: JourneyDetails) {
        guard quotesSearchForDetailsInProgress == journeyDetails else { return }

        setExpirationDates(of: quotes)

        if journeyDetails.isScheduled {
            selectedQuoteOrder = .price
        }
        updateViewQuotes(quotes)
    }

    private func quoteSearchErrorResult(_ error: KarhooError?) {
        guard let error = error else {
            return
        }
        quotesSearchForDetailsInProgress = nil
        switch error.type {
        case .noAvailabilityInRequestedArea:
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            onStateUpdated?(.empty(
                reason:
                    .noAvailabilityInRequestedArea(
                        isPrebook: journeyDetailsManager.getJourneyDetails()?.isScheduledInMoreThanOneHour ?? false
                    )
            ))
        case .originAndDestinationAreTheSame:
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            onStateUpdated?(.empty(reason: .originAndDestinationAreTheSame))
        default: break
        }
    }

    private func scheduleQuotesRefresh() {
        quoteValidityWorker.invalidate()
        guard let sampleQuote = fetchedQuotes?.all.first else {
            return
        }
        dateOfListReceiving = sampleQuote.quoteExpirationDate
        quoteValidityWorker.setQuoteValidityDeadline(
            sampleQuote,
            deadlineCompletion: { [weak self] in
                if self?.isViewVisible == true {
                    self?.getQuotes()
                } else {
                    self?.dateOfListReceiving = nil
                }
            }
        )
    }
    
    private func getQuotes() {
        getQuotes(using: journeyDetailsManager.getJourneyDetails())
    }

    private func getQuotes(using details: JourneyDetails?) {
        guard let details = details else {
            return
        }
        guard
            let destination = details.destinationLocationDetails,
            let origin = details.originLocationDetails
        else {
            onStateUpdated?(.empty(reason: .destinationOrOriginEmpty))
            return
        }
        if dateOfListReceiving == nil {
            dateOfListReceiving = Date()
        }
        isSortingAvailable = !details.isScheduled

        let quoteSearch = QuoteSearch(
            origin: origin,
            destination: destination,
            dateScheduled: details.scheduledDate
        )
        guard quotesSearchForDetailsInProgress != details else {
            // quotes for selected journey details already been requested
            return
        }

        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        quotesObserver = nil
        quoteSearchObservable = nil

        quotesObserver = KarhooSDK.Observer<Quotes> { [weak self] result in
            guard details == self?.journeyDetailsManager.getJourneyDetails() else { return }
            self?.handleResult(result: result, journeyDetails: details)
        }
        onStateUpdated?(.loading)
        fetchedQuotes = nil
        quotesSearchForDetailsInProgress = details
        currentlyUsedJourneyDetails = details
        quoteSearchObservable = quoteService
            .quotes(quoteSearch: quoteSearch, locale: currentLocale.replacingOccurrences(of: "_", with: "-"))
            .observable(pollTime: quoteListPollTime)
        quoteSearchObservable?.subscribe(observer: quotesObserver)
    }

    private func handleQuoteStatus() {
        guard
            let status = fetchedQuotes?.status,
            status == .completed || status == .progressing
        else {
            return
        }
        if fetchedQuotes?.status == .completed {
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
        }
        scheduleQuotesRefresh()
    }

    private func setExpirationDates(of quotes: Quotes) {
        quotes.all.forEach { $0.setExpirationDate(using: quotes.validity) }
    }

    private func updateViewQuotes() {
        guard let fetchedQuotes else { return }
        updateViewQuotes(fetchedQuotes)
    }

    private func updateViewQuotes(_ newQuotes: Quotes) {
        defer {
            fetchedQuotes = newQuotes
        }

        let quotesToShow: [Quote] = quoteFilter.filter(newQuotes.all)

        let noQuotesForSelectedFilters = quotesToShow.isEmpty && newQuotes.all.isEmpty == false
        let noQuotesForTimeAndArea = newQuotes.all.isEmpty && newQuotes.status == .completed

        let sortedQuotes = quoteSorter.sortQuotes(quotesToShow, by: selectedQuoteOrder)

        switch (noQuotesForTimeAndArea, noQuotesForSelectedFilters, newQuotes.status) {
        case (true, _, _):
            quotesSearchForDetailsInProgress = nil
            let journeyDetails = journeyDetailsManager.getJourneyDetails()
            
            switch journeyDetails?.isScheduledInMoreThanOneHour {
            case false:
                onStateUpdated?(.empty(
                    reason: .noAvailabilityInRequestedArea(
                        isPrebook: journeyDetailsManager.getJourneyDetails()?.isScheduledInMoreThanOneHour ?? false
                    )
                ))
            default:
                onStateUpdated?(.empty(reason: .noResults))
            }
        case (_, true, _):
            quotesSearchForDetailsInProgress = nil
            onStateUpdated?(.empty(reason: .noQuotesAfterFiltering))
        case (_, _, .completed):
            quotesSearchForDetailsInProgress = nil
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            onStateUpdated?(.fetched(quotes: sortedQuotes))
        case (_, _, .progressing) where newQuotes.all.isEmpty:
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
extension KarhooQuoteListViewModel: JourneyDetailsObserver {

    func journeyDetailsChanged(details: JourneyDetails?) {
        getQuotes(using: details)
    }
}
