//
//  Quote+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 11/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension Quote {

    func setExpirationDate(using validity: Int) {
        QuoteDatesHelper.setExpirationDate(
            of: self,
            date: Date().addingTimeInterval(TimeInterval(validity))
        )
    }

    var quoteExpirationDate: Date? {
        QuoteDatesHelper.getExpirationDate(of: self)
    }
    
    func toTripQuote() -> TripQuote {
        TripQuote(
            total: self.price.intHighPrice,
            currency: self.price.currencyCode,
            gratuityPercent: 0,
            breakdown: [],
            qtaHighMinutes: self.vehicle.qta.highMinutes,
            qtaLowMinutes: self.vehicle.qta.lowMinutes,
            highPrice: self.price.intHighPrice,
            lowPrice: self.price.intLowPrice,
            type: self.quoteType,
            vehicleClass: self.vehicle.vehicleClass
        )
    }
}
                                           
struct QuoteDatesHelper {
    private static var expirationDates: [String: Date] = [:]

    static func setExpirationDate(of quotes: Quotes) {
        for item in quotes.all {
            setExpirationDate(
                of: item,
                date: Date().addingTimeInterval(TimeInterval(quotes.validity))
            )
        }
    }

    static func setExpirationDate(of quote: Quote, date: Date) {
        expirationDates[quote.id] = date
    }

    static func getExpirationDate(of quote: Quote) -> Date? {
        expirationDates[quote.id]
    }
}
