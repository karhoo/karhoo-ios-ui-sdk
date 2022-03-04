//
//  QuoteListBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 25/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

enum QuoteList {
    static func build(
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        onQuoteSelected: @escaping (Quote) -> Void
    ) -> QuoteListView {
        let viewController = KarhooQuoteListViewController()
        let router = KarhooQuoteListRouter(viewController: viewController)
        let presenter = KarhooQuoteListPresenter(
            router: router,
            journeyDetailsManager: KarhooJourneyDetailsManager.shared,
            quoteService: quoteService,
            quoteSorter: quoteSorter,
            analytics: analytics,
            onQuoteSelected: onQuoteSelected
        )

        viewController.setupBinding(presenter)

        return viewController
    }
}
