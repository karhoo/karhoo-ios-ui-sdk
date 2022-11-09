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
        guard let def = _defaultCountry
        else {
            let all = getCountries()
            guard all.count > 0
            else {
                return Country(name: "United Kingdom", phoneCode: "+44", code: "GB")
            }
            
            let networkInfo = CTTelephonyNetworkInfo().subscriberCellularProvider
    
            guard let regionCode = networkInfo?.isoCountryCode?.uppercased() ?? NSLocale.current.regionCode  else {
                return all.first(where: { $0.code == "GB" })!
            }
            
            _defaultCountry = all.first(where: { $0.code == regionCode }) ?? all.first(where: { $0.code == "GB" })!
            return _defaultCountry!
        }
        return def
    }
    
    static func getCountries() -> [Country] {
        let c = NSLocale.isoCountryCodes
        let availableLocales = Bundle.main.localizations
        let deviceLocale = Locale.current.languageCode ?? "en"
        let locale = availableLocales.contains(deviceLocale) ? deviceLocale : "en"
        
        var prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH": "973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263", "AC":"247", "AQ":"672", "AX":"358", "BQ":"599", "BV":"47", "CP":"1", "CW":"599", "DG":"246", "EA":"34", "EH":"212", "HM":"1", "IC":"828", "SS":"211", "SX":"599", "TA":"290",  "TF":"262", "UM":"246", "XK":"383" ]

        for (k, v) in prefixCodes {
            prefixCodes[k] = "+\(v)"
        }
        
        var countries = [Country]()
        
        for code in c {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: locale).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(Country(name: name, phoneCode: prefixCodes[code] ?? "", code: code))
        }
        
        countries = countries.sorted(by: { $0.name < $1.name })
        return countries
    }
    
    static func getCountry(countryCode: String) -> Country? {
        let all = getCountries()
        return all.first(where: { $0.code == countryCode })
    }
}
