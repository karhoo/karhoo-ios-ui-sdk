//
//  KarhooQuoteCategoryBarPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooQuoteCategoryBarPresenter: QuoteCategoryBarPresenter {

    private let analytics: Analytics
    private let journeyDetailsManager: JourneyDetailsManager
    private weak var quoteCategoryBarView: QuoteCategoryBarView?
    private var selectedIndex: Int?
    private var lastQuotesListId: String?
    private var categories: [QuoteCategory] = []

    init(analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
         view: QuoteCategoryBarView) {
        self.analytics = analytics
        self.journeyDetailsManager = journeyDetailsManager
        self.quoteCategoryBarView = view
        self.journeyDetailsManager.add(observer: self)
    }

    func selected(index: Int, animated: Bool) {
        guard index < categories.count else {
            return
        }
        quoteCategoryBarView?.set(selectedIndex: index, animated: animated)

        guard index != selectedIndex else {
            return
        }

        selectedIndex = index

        let category = categories[index]
        quoteCategoryBarView?.didSelectCategory(category)
    }

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        let categories = categoriesWithAllCategory(categories)
        guard self.categories != categories else {
            return
        }
        
        // Reset the selected index if the old category count doesn't match the new one
        // This fixes the scenario where the user has the "All" category selected on ASAP, then chooses to pre-book,
        // in which case more or less categories may appear, offsetting the initial selection
        if self.categories.count != categories.count {
            self.selectedIndex = nil
        }
        
        self.categories = categories
        self.lastQuotesListId = quoteListId
        updateCategories()
    }

    private func categoriesWithAllCategory(_ categories: [QuoteCategory]) -> [QuoteCategory] {
        var categories = categories
        let allQuotes = categories.flatMap { $0.quotes }

        if categories.count > 0 {
            categories.append(QuoteCategory(name: UITexts.Availability.allCategory,
                                            quotes: allQuotes))
        }
        return categories
    }

    private func resetCategories() {
        self.categories = []
        updateCategories()
    }

    private func updateCategories() {
        quoteCategoryBarView?.set(categories: categories)

        guard categories.count > 0 else {
            return
        }
        
        selected(index: selectedIndex != nil ? min(selectedIndex!, categories.count - 1) : categories.count - 1,
                 animated: false)
    }
}

extension KarhooQuoteCategoryBarPresenter: JourneyDetailsObserver {

    func journeyDetailsChanged(details: JourneyDetails?) {
        resetCategories()
    }
}
