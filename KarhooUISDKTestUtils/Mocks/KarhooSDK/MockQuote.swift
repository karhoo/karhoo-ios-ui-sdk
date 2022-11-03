//
//  MockQuote.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 25/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension Quote {
    static func mock(quoteType: QuoteType = .estimated, vehicleType: String = "standard") -> Quote {
        Quote(
            id: PrimitiveUtil.getRandomString(),
            quoteType: quoteType,
            source: .fleet,
            pickUpType: .default,
            fleet: .init(id: PrimitiveUtil.getRandomString(), name: "Mocked Fleet"),
            vehicle: QuoteVehicle(
                vehicleClass: vehicleType,
                type: vehicleType,
                tags: ["wheelchair", "child-seat"],
                qta: QuoteQta(highMinutes: 10, lowMinutes: 5),
                passengerCapacity: 4,
                luggageCapacity: 4
            ),
            price: QuotePrice(highPrice: 10.0, lowPrice: 8.0, currencyCode: "EUR"),
            validity: 30,
            serviceLevelAgreements: ServiceAgreements(
                serviceCancellation: .init(type: .timeBeforePickup, minutes: 5),
                serviceWaiting: .init(minutes: 5)
            )
        )
    }

    static func mock2(quoteType: QuoteType = .fixed, vehicleType: String = "mpv") -> Quote {
        Quote(
            id: PrimitiveUtil.getRandomString(),
            quoteType: quoteType,
            source: .fleet,
            pickUpType: .default,
            fleet: .init(id: PrimitiveUtil.getRandomString(), name: "Mocked Fleet"),
            vehicle: QuoteVehicle(
                vehicleClass: vehicleType,
                type: vehicleType,
                tags: ["wheelchair", "child-seat"],
                qta: QuoteQta(highMinutes: 10, lowMinutes: 5),
                passengerCapacity: 4,
                luggageCapacity: 4
            ),
            price: QuotePrice(highPrice: 10.0, lowPrice: 8.0, currencyCode: "EUR"),
            validity: 30,
            serviceLevelAgreements: ServiceAgreements(
                serviceCancellation: .init(type: .timeBeforePickup, minutes: 5),
                serviceWaiting: .init(minutes: 5)
            )
        )
    }
}
