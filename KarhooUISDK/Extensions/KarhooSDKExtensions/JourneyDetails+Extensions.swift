//
//  JourneyDetails+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 10/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

extension JourneyDetails {
    var printedPickUpAddressLine1: String {
        originLocationDetails?.address.displayAddress ?? ""
    }

    var printedPickUpAddressLine2: String {
        var result = ""

        if let city = originLocationDetails?.address.city {
            result += "\(city) "
        }

        if let postalCode = originLocationDetails?.address.postalCode {
            result += postalCode
        }

        if let country = originLocationDetails?.address.countryCode {
            result += ", \(country)"
        }

        return result
    }

    var printedDropOffAddressLine1: String {
        destinationLocationDetails?.address.displayAddress ?? ""
    }

    var printedDropOffAddressLine2: String {
        var result = ""

        if let city = destinationLocationDetails?.address.city {
            result += "\(city) "
        }

        if let postalCode = destinationLocationDetails?.address.postalCode {
            result += postalCode
        }

        if let country = destinationLocationDetails?.address.countryCode {
            result += ", \(country)"
        }

        return result
    }
}
