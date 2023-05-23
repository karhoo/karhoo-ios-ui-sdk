//
//  JourneyDetails+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 10/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

extension JourneyDetails {
    private static var countryRegexPattern = ",{1} *[A-Za-z]*$"
    
    var printedPickUpAddressLine1: String {
        // Removing every piece of info separately because the display address doesn't always return them in the same order
        // But there is always a comma before the country
        var result = originLocationDetails?.address.displayAddress
            .remove(substring: originLocationDetails?.address.city)
            .remove(substring: originLocationDetails?.address.postalCode) ?? ""
        
        // Remove either the country code or full country name, depending on what is returned in the display address
        if let countryCode = originLocationDetails?.address.countryCode,
           result.hasSuffix(countryCode) {
            result = result.remove(substring: ", \(originLocationDetails?.address.countryCode ?? "")")
        } else {
            result = result.removeSubstringWithRegexUsing(pattern: JourneyDetails.countryRegexPattern)
        }
        
        return result
    }

    var printedPickUpAddressLine2: String {
        var result = ""

        if let city = originLocationDetails?.address.city {
            result += "\(city) "
        }

        if let postalCode = originLocationDetails?.address.postalCode {
            result += postalCode
        }

        if let pickUpCountry = originLocationDetails?.address.countryCode,
           let dropOffCountry = destinationLocationDetails?.address.countryCode,
           pickUpCountry != dropOffCountry {
            result += ", \(pickUpCountry)"
        }

        return result
    }

    var printedDropOffAddressLine1: String {
        // Removing every piece of info separately because the display address doesn't always return them in the same order
        // But there is always a comma before the country
        var result = destinationLocationDetails?.address.displayAddress
            .remove(substring: destinationLocationDetails?.address.city)
            .remove(substring: destinationLocationDetails?.address.postalCode) ?? ""
        
        // Remove either the country code or full country name, depending on what is returned in the display address
        if let countryCode = destinationLocationDetails?.address.countryCode,
           result.hasSuffix(countryCode) {
            result = result.remove(substring: ", \(destinationLocationDetails?.address.countryCode ?? "")")
        } else {
            result = result.removeSubstringWithRegexUsing(pattern: JourneyDetails.countryRegexPattern)
        }
        
        return result
    }

    var printedDropOffAddressLine2: String {
        var result = ""

        if let city = destinationLocationDetails?.address.city {
            result += "\(city) "
        }

        if let postalCode = destinationLocationDetails?.address.postalCode {
            result += postalCode
        }

        if let pickUpCountry = originLocationDetails?.address.countryCode,
           let dropOffCountry = destinationLocationDetails?.address.countryCode,
           pickUpCountry != dropOffCountry {
            result += ", \(dropOffCountry)"
        }

        return result
    }
}
