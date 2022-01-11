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

}
                                           
enum QuoteDatesHelper {
    private static var expirationDates: [String: Date] = [:]

    static func setExpirationDate(of quotes: Quotes) {
        quotes.all.forEach {
            setExpirationDate(
                of: $0,
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
