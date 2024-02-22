//
//  MockRecentAddressProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK
@testable import KarhooUISDK

final public class MockRecentAddressProvider: RecentAddressProvider {
    public init() {}

     public let addressToReturn = LocationInfo(placeId: "place123",
                                       timeZoneIdentifier: "GMT",
                                       position: Position(latitude: TestUtil.getRandomCoordinateComponent(), longitude: TestUtil.getRandomCoordinateComponent()),
                                       poiType: .nearest,
                                       address: LocationInfoAddress(displayAddress: "Piccadilly Circus, London, UK",
                                                                    lineOne: "line1",
                                                                    lineTwo: "",
                                                                    buildingNumber: "",
                                                                    streetName: "Piccadilly Circus",
                                                                    city: "London",
                                                                    postalCode: "123456",
                                                                    countryCode: "GB",
                                                                    region: "GB"),
                                       details: PoiDetails(iata: TestUtil.getRandomString(), terminal: TestUtil.getRandomString(), type: .notSetDetailsType),
                                       meetingPoint: MeetingPoint(position: Position(latitude: TestUtil.getRandomCoordinateComponent(), longitude: TestUtil.getRandomCoordinateComponent()),
                                                                  instructions: TestUtil.getRandomString(),
                                                                  type: .default,
                                                                  note: TestUtil.getRandomString()),
                                       instructions: TestUtil.getRandomString())
    
    public var addedRecent: LocationInfo?

    public func getRecents() -> [LocationInfo] {
        return [addressToReturn]
    }
    public func add(recent: LocationInfo) {
        addedRecent = recent
    }
}
