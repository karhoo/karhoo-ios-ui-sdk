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
    private let bookingStatus: BookingStatus
    private weak var quoteCategoryBarView: QuoteCategoryBarView?
    private var selectedIndex: Int?
    private var lastQuotesListId: String?
    private var categories: [QuoteCategory] = []

    init(analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         bookingStatus: BookingStatus = KarhooBookingStatus.shared,
         view: QuoteCategoryBarView) {
        self.analytics = analytics
        self.bookingStatus = bookingStatus
        self.quoteCategoryBarView = view
        self.bookingStatus.add(observer: self)
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

        analytics.vehicleTypeSelected(selectedCategory: category.categoryName,
                                      quoteListId: lastQuotesListId)
    }

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        let categories = categoriesWithAllCategory(categories)
        guard self.categories != categories else {
            return
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

extension KarhooQuoteCategoryBarPresenter: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        resetCategories()
    }
}
