//
//  JourneyInfo+mock.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 18/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK
@testable import KarhooUISDK

extension JourneyInfo {

    /// Charles De Gaulle Airport in Paris => Stade De France
    static public func mock() -> JourneyInfo {
        .init(
            origin: CLLocation(
                latitude: 49.00815141502007,
                longitude: 2.5509512763154882
            ),
            destination: CLLocation(
                latitude: 48.92456127273165,
                longitude: 2.3597621692621753
            )
        )
    }
}

extension JourneyDetails {
    static public func mock() -> JourneyDetails {
        var details = JourneyDetails(originLocationDetails: .init())
        details.destinationLocationDetails = .init()
        let destination = JourneyInfo.mock().destination
        details.destinationLocationDetails = LocationInfo(
            position: Position(
                latitude: destination!.coordinate.latitude,
                longitude: destination!.coordinate.longitude
            ),
            address: .init(displayAddress: "Address to display")
        )

        return details
    }
    
    static public func mockWithScheduledDate(pickupPoiDetailsType: PoiDetailsType = .notSetDetailsType) -> JourneyDetails {
        var details = JourneyDetails(originLocationDetails: .init())
        details.destinationLocationDetails = .init()
        let destination = JourneyInfo.mock().destination
        details.destinationLocationDetails = LocationInfo(
            position: Position(
                latitude: destination!.coordinate.latitude,
                longitude: destination!.coordinate.longitude
            ),
            address: .init(displayAddress: "Destination address to display")
        )
        let origin = JourneyInfo.mock().origin
        details.originLocationDetails = LocationInfo(
            position: Position(
                latitude: origin.coordinate.latitude,
                longitude: origin.coordinate.longitude
            ),
            address: .init(displayAddress: "Origin address to display"),
            details: PoiDetails(type: pickupPoiDetailsType)
        )
        details.scheduledDate = Date.mock()

        return details
    }
}
