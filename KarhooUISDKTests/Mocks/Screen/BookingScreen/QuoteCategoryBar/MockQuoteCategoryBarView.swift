//
//  MockQuoteCategoryBarView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockQuoteCategoryBarView: QuoteCategoryBarView {

    func set(actions: QuoteCategoryBarActions) {}

    private(set) var didSelectCategoryCalled: QuoteCategory?
    func didSelectCategory(_ category: QuoteCategory) {
        didSelectCategoryCalled = category
    }

    private(set) var categoriesChanged: [QuoteCategory]?
    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        categoriesChanged = categories
    }

    private(set) var categoriesSet: [QuoteCategory]?
    func set(categories: [QuoteCategory]) {
        categoriesSet = categories
    }

    private(set) var indexSelected: Int?
    private(set) var indexSelectedAnimated: Bool?
    func set(selectedIndex: Int, animated: Bool) {
        indexSelected = selectedIndex
        indexSelectedAnimated = animated
    }
}
