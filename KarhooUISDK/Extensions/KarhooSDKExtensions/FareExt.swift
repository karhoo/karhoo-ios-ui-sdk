//
//  FareExt.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension Fare {
    
    func displayPrice() -> String {
       return CurrencyCodeConverter.toPriceString(price: Int(self.breakdown.total),
                                                  currencyCode: self.breakdown.currency)
    }
}
