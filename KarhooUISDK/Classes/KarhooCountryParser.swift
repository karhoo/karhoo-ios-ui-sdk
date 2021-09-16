//
//  KarhooCountryParser.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import CoreTelephony

final class KarhooCountryParser {
    
    private static var _defaultCountry: Country?
    static var defaultCountry: Country {
        get {
            guard let def = _defaultCountry
            else {
                let all = getCountries()
                let networkInfo = CTTelephonyNetworkInfo().subscriberCellularProvider
        
                guard let regionCode = networkInfo?.isoCountryCode?.uppercased() ?? NSLocale.current.regionCode  else {
                    return all.first(where: { $0.code == "GB" })!
                }
                
                _defaultCountry = all.first(where: { $0.code == regionCode }) ?? all.first(where: { $0.code == "GB" })!
                return _defaultCountry!
            }
            
            return def
        }
    }
    
    static func getCountries() -> [Country] {
        guard var countries: [Country] = KarhooFileManager.getFromFile("Countries")
        else {
            return []
        }
        
        countries = countries.sorted(by: { $0.name < $1.name })
        return countries
    }
}
