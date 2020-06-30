//
//  QuoteCategoryBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol QuoteCategoryBarView: AnyObject {

    func set(categories: [QuoteCategory])

    func set(selectedIndex: Int, animated: Bool)

    func set(actions: QuoteCategoryBarActions)

    func didSelectCategory(_ category: QuoteCategory)

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?)
}

protocol QuoteCategoryBarPresenter {

    func selected(index: Int, animated: Bool)

    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?)
}

protocol QuoteCategoryBarActions: AnyObject {

    func didSelectCategory(_ category: QuoteCategory)
}
