//
//  KarhooCountryParser.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

final class KarhooCountryParser {
    
    static func getCountries() -> [Country] {
        guard let countries: [Country] = KarhooFileManager.getFromFile("Countries")
        else {
            return []
        }
        
        return countries
    }
}
