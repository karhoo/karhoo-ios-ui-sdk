//
//  ServiceAgreementsFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum ServiceAgreements: String, QuoteListFilter, CaseIterable {
        case freeCancelation = "free_cancellation"
        case freeWatingTime = "free_waiting_time"
        
        var filterCategory: QuoteListFilters.Category { .serviceAgreements }
        
        var localizedString: String {
            rawValue
        }

        func conditionMet(for quote: Quote) -> Bool {
            switch self {
            case .freeCancelation:
                return quote.serviceLevelAgreements?.serviceCancellation.type != .other(value: nil)
            case .freeWatingTime:
                return (quote.serviceLevelAgreements?.serviceWaiting.minutes ?? 0) > 0
            }
        }
    }
}
