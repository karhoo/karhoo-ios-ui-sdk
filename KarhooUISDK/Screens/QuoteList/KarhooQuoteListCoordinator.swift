//
//  KarhooQuoteListCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

final class KarhooQuoteListCoordinator: QuoteListCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListViewController!
    private(set) var presenter: QuoteListViewModel!

    private let onQuoteSelected: (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void

    private var filtersCoordinator: QuoteListFiltersCoordinator?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        journeyDetails: JourneyDetails? = nil,
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    ) {
        self.onQuoteSelected = onQuoteSelected
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListViewController()
        self.presenter = KarhooQuoteListViewModel(
            journeyDetails: journeyDetails,
            router: self,
            journeyDetailsManager: KarhooJourneyDetailsManager.shared,
            quoteService: quoteService,
            quoteSorter: quoteSorter,
            analytics: analytics,
            onQuotesUpdated: { [weak self] in
                self?.filtersCoordinator?.updateResults()
            }
        )
        self.viewController.setupBinding(presenter)
    }

    // MARK: - Start & routing

    func start() {
        navigationController?.show(viewController, sender: nil)
    }
}

extension KarhooQuoteListCoordinator: QuoteListRouter {

    func routeToQuote(
        _ quote: Quote,
        journeyDetails: JourneyDetails
    ) {
        onQuoteSelected(quote, journeyDetails)
    }

    func routeToQuoteDetails(_ quote: Quote) {
    }

    func routeToSort(selectedSortOrder: QuoteListSortOrder) {
        let sortCoordinator = KarhooQuoteListSortCoordinator(
            selectedOption: selectedSortOrder,
            onSortOptionComfirmed: { [weak self] selectedSortOption in
                self?.presenter.didSelectQuoteSortOrder(selectedSortOption)
            }
        )
        addChild(sortCoordinator)
        sortCoordinator.startPresented(on: self)
    }

    func routeToFilters(_ filters: [QuoteListFilter]) {
        let filtersCoordinator = KarhooQuoteListFiltersCoordinator(
            filters: filters,
            onResultsForFiltersChosen: { [weak self] filters in
                self?.presenter.getNumberOfResultsForQuoteFilters(filters) ?? 0
            },
            onFiltersConfirmed: { [weak self] filters in
                self?.presenter.selectedQuoteFilters(filters)
            },
            onFinish: { [weak self] in
                guard let filtersCoordinator = self?.filtersCoordinator else { return }
                self?.removeChild(filtersCoordinator)
                self?.filtersCoordinator = nil
            }
        )
        addChild(filtersCoordinator)
        filtersCoordinator.startPresented(on: self)
        self.filtersCoordinator = filtersCoordinator
    }
}
