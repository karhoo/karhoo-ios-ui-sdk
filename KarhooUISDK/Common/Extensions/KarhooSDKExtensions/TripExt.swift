//
//  TripExt.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension TripInfo {

    func quotePrice() -> String {
        return CurrencyCodeConverter.toPriceString(price: self.tripQuote.denominateTotal,
                                                   currencyCode: self.tripQuote.currency)
    }

    func farePrice() -> String {
        if self.fare.total == 0 {
            return UITexts.Bookings.priceCancelled
        }
        return CurrencyCodeConverter.toPriceString(price: fare.denominateTotal,
                                                   currencyCode: fare.currency)
    }
}
