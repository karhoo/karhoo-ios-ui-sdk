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

    private let bookingStatus: BookingStatus
    private let quoteService: QuoteService
    private weak var quoteListView: QuoteListView?
    private var fetchedQuotes: Quotes?
    private var quotesObserver: KarhooSDK.Observer<Quotes>?
    private var quoteSearchObservable: KarhooSDK.Observable<Quotes>?
    private var selectedQuoteCategory: QuoteCategory?
    private var selectedQuoteOrder: QuoteSortOrder = .price
    private let quoteSorter: QuoteSorter
    private let analytics: Analytics

    init(
        bookingStatus: BookingStatus = KarhooBookingStatus.shared,
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteListView: QuoteListView,
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.bookingStatus = bookingStatus
        self.quoteService = quoteService
        self.quoteListView = quoteListView
        self.quoteSorter = quoteSorter
        self.analytics = analytics
        bookingStatus.add(observer: self)
    }

    deinit {
        bookingStatus.remove(observer: self)
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)
    }

    func screenWillAppear() {
        guard let bookingDetails = bookingStatus.getBookingDetails() else {
            assertionFailure("Unable to get data to upload")
            return
        }
        analytics.quoteListOpened(bookingDetails)
    }

    func selectedQuoteCategory(_ category: QuoteCategory) {
        selectedQuoteCategory = category
        updateViewQuotes(animated: true)
    }

    func didSelectQuoteOrder(_ order: QuoteSortOrder) {
        self.didSelectQuoteOrder(order, animated: true)
    }

    func didSelectQuoteOrder(_ order: QuoteSortOrder, animated: Bool) {
        selectedQuoteOrder = order
        updateViewQuotes(animated: animated)
    }

    private func quoteSearchSuccessResult(_ quotes: Quotes, bookingDetails: BookingDetails?) {
        fetchedQuotes = quotes
        quoteListView?.categoriesChanged(categories: quotes.quoteCategories,
                                         quoteListId: quotes.quoteListId)
        if bookingDetails?.destinationLocationDetails != nil, bookingDetails?.isScheduled == true {
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
            quoteListView?.quotesAvailabilityDidUpdate(availability: false)
            quoteListView?.hideLoadingView()
            quoteListView?.toggleCategoryFilteringControls(show: true)
        case .originAndDestinationAreTheSame:
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            quoteListView?.showEmptyDataSetMessage(UITexts.KarhooError.Q0001)
            quoteListView?.hideLoadingView()
            quoteListView?.toggleCategoryFilteringControls(show: true)
        default: break
        }
    }
    
    private func handleQuotePolling() {
        let timer = fetchedQuotes!.validity
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(timer)
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.quoteSearchObservable?.subscribe(observer: self.quotesObserver)
        }
    }
    
    private func handleQuoteStatus() {
        guard let fetchedQuotes = self.fetchedQuotes else {
            return
        }
        
        if fetchedQuotes.status == .completed {
            quoteSearchObservable?.unsubscribe(observer: quotesObserver)
            handleQuotePolling()
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
            quoteListView?.showEmptyDataSetMessage(UITexts.Availability.noQuotesInSelectedCategory)
        } else if quotesToShow.isEmpty && fetchedQuotes.all.isEmpty == true && fetchedQuotes.status == .completed {
            quoteListView?.showEmptyDataSetMessage(UITexts.Availability.noQuotesForSelectedParameters)
        } else {
            let sortedQuotes = quoteSorter.sortQuotes(quotesToShow, by: selectedQuoteOrder)
            quoteListView?.showQuotes(sortedQuotes, animated: animated)
        }
        
        handleQuoteStatus()

    }
}

extension KarhooQuoteListPresenter: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        quoteSearchObservable?.unsubscribe(observer: quotesObserver)

        guard let details = details else {
            return
        }

        if details.destinationLocationDetails != nil, details.isScheduled {
            quoteListView?.hideQuoteSorter()
        } else {
            quoteListView?.showQuoteSorter()
        }

        guard let destination = details.destinationLocationDetails,
            let origin = details.originLocationDetails else {
            quoteListView?.hideLoadingView()
            quoteListView?.toggleCategoryFilteringControls(show: true)
            return
        }
        
        quoteListView?.showQuotes([], animated: true)
        quoteListView?.showLoadingView()
        quoteListView?.toggleCategoryFilteringControls(show: false)
        let quoteSearch = QuoteSearch(origin: origin,
                                      destination: destination,
                                      dateScheduled: details.scheduledDate)

        quotesObserver = KarhooSDK.Observer<Quotes> { [weak self] result in

            if result.successValue()?.all.isEmpty == false {
                self?.quoteListView?.hideLoadingView()
                self?.quoteListView?.toggleCategoryFilteringControls(show: true)
            }

            switch result {
            case .success(let quotes):
                self?.setExpirationDates(of: quotes)
                self?.quoteSearchSuccessResult(quotes, bookingDetails: details)
                if details.destinationLocationDetails != nil, details.scheduledDate != nil {
                    self?.quoteListView?.hideQuoteSorter()
                }

                if quotes.all.isEmpty && quotes.status != .completed {
                    self?.quoteListView?.showLoadingView()
                    self?.quoteListView?.toggleCategoryFilteringControls(show: false)
                } else if quotes.all.isEmpty && quotes.status == .completed {
                    self?.quoteListView?.hideLoadingView()
                    self?.quoteListView?.toggleCategoryFilteringControls(show: false)
                }

            case .failure(let error):
                self?.quoteSearchErrorResult(error)
            @unknown default:
                break
            }
        }
        quoteSearchObservable = quoteService.quotes(quoteSearch: quoteSearch).observable()
        quoteSearchObservable?.subscribe(observer: quotesObserver)
    }
}
