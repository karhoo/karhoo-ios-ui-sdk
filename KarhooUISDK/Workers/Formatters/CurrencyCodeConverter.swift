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

    /// Format money amounts to String
    ///
    /// - Parameters:
    ///   - quote: The quote that has the price
    class func toPriceString(quote: Quote) -> String {
        return toPriceString(price: quote.price.intHighPrice, currencyCode: quote.price.currencyCode)
    }

    /// Format money amounts to String
    ///
    /// - Parameters:
    ///   - price: The price in cents or similar (Ex: for 1$ input 100)
    ///   - currencyCode: The currency code (Ex: GBP)
    class func toPriceString(price: Int, currencyCode: String) -> String {
        if let price = CurrencyCodeConverter.formatted(amount: price, currencyCode: currencyCode) {
            return price
        } else {
            return UITexts.Bookings.priceCancelled
        }
    }

    
    class func quoteRangePrice(quote: Quote) -> String {
        let highPrice = CurrencyCodeConverter.formatted(amount: quote.price.intHighPrice, currencyCode: quote.price.currencyCode)
        let lowPrice = CurrencyCodeConverter.formatted(amount: quote.price.intLowPrice, currencyCode: quote.price.currencyCode)

        return "\(lowPrice ?? "") - \(highPrice ?? "")"
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
    
    /// Format money amounts.
    ///
    /// - Parameters:
    ///   - amount: The amount in minor units.
    ///   - currencyCode: The code of the currency.
    private static func formatted(amount: Int, currencyCode: String) -> String? {
        let decimalAmount = CurrencyCodeConverter.decimalAmount(amount, currencyCode: currencyCode)
        return defaultFormatter(currencyCode: currencyCode).string(from: decimalAmount)
    }
    
    /// Converts an amount in major currency unit to an amount in minor currency units.
    ///
    /// - Parameters:
    ///   - majorUnitAmount: The amount in major currency units.
    ///   - currencyCode: The code of the currency.
    static func minorUnitAmount(from majorUnitAmount: Double, currencyCode: String) -> Int {
        let maximumFractionDigits = CurrencyCodeConverter.maximumFractionDigits(for: currencyCode)
        return Int(majorUnitAmount * pow(Double(10), Double(maximumFractionDigits)))
    }
    
    private static func decimalAmount(_ amount: Int, currencyCode: String) -> NSDecimalNumber {
        let defaultFormatter = CurrencyCodeConverter.defaultFormatter(currencyCode: currencyCode)
        let maximumFractionDigits = CurrencyCodeConverter.maximumFractionDigits(for: currencyCode)
        defaultFormatter.maximumFractionDigits = maximumFractionDigits
        
        let decimalMinorAmount = NSDecimalNumber(value: amount)
        let convertedAmount = decimalMinorAmount.multiplying(byPowerOf10: Int16(-maximumFractionDigits)).doubleValue
        return NSDecimalNumber(value: convertedAmount)
    }
    
    private static func defaultFormatter(currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter
    }
    
    private static func maximumFractionDigits(for currencyCode: String) -> Int {
        // For some currency codes iOS returns the wrong number of minor units.
        // The below overrides are obtained from https://en.wikipedia.org/wiki/ISO_4217
        
        switch currencyCode {
        case "ISK", "CLP", "COP":
            // iOS returns 0, which is in accordance with ISO-4217, but conflicts with the Adyen backend.
            return 2
        case "MRO":
            // iOS returns 0 instead.
            return 1
        case "RSD":
            // iOS returns 0 instead.
            return 2
        case "CVE":
            // iOS returns 2 instead.
            return 0
        case "GHC":
            // iOS returns 2 instead.
            return 0
        default:
            let formatter = defaultFormatter(currencyCode: currencyCode)
            return formatter.maximumFractionDigits
        }
    }
}
