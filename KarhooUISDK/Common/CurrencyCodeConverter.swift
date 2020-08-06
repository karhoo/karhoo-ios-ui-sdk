//
//  CurrencyCodeConverter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

class CurrencyCodeConverter {

    class func toPriceString(quote: Quote) -> String {
        return toPriceString(price: quote.price.highPrice, currencyCode: quote.price.currencyCode)
    }

    class func toPriceString(price: Double, currencyCode: String) -> String {
        let symbol = findCurrencySymbolByCode(currencyCode: currencyCode)

        if symbol.isEmpty {
            return UITexts.Bookings.priceCancelled
        }

        return String(format: "%@%.2f", symbol, price)
    }

    class func quoteRangePrice(quote: Quote) -> String {
        let highPrice = toPriceString(price: quote.price.highPrice, currencyCode: quote.price.currencyCode)
        let lowPrice = toPriceString(price: quote.price.lowPrice, currencyCode: quote.price.currencyCode)

        return "\(lowPrice) - \(highPrice)"
    }

    private static func findCurrencySymbolByCode(currencyCode: String) -> String {

        guard let locale = findLocaleByCurrencyCode(currencyCode: currencyCode) else {
            return currencyCode
        }

        return locale.object(forKey: NSLocale.Key.currencySymbol) as? String ?? ""
    }

    private static func findLocaleByCurrencyCode(currencyCode: String) -> NSLocale? {
        let locales = NSLocale.availableLocaleIdentifiers
        var locale: NSLocale?
        for localeId in locales {
            locale = NSLocale(localeIdentifier: localeId)
            if let code = locale?.object(forKey: NSLocale.Key.currencyCode) as? String {
                if code == currencyCode {
                    return locale
                }
            }
        }
        return nil
    }
}
