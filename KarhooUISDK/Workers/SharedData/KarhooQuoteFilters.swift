//
//  KarhooQuoteFilters.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 05.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol QuoteFilters {
    func getFilters() -> [QuoteListFilter]?
    func set(filters: [QuoteListFilter]?)
    func reset()
}

class KarhooQuoteFilters: QuoteFilters {
    
    static let shared = KarhooQuoteFilters()
    
    // TODO: add rest of filters (number of passengers and luggage)
    private var filters: [QuoteListFilter]?
    
    func getFilters() -> [QuoteListFilter]? {
        filters
    }
    
    func set(filters: [QuoteListFilter]?) {
        self.filters = filters
    }
    
    func reset() {
        filters = nil
    }
    
    // TODO: add filter management logic (add, remove, etc.)
}
