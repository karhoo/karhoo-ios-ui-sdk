//
//  Address.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK

struct Address: KarhooCodableModel {
   
    let placeId: String
    let displayAddress: String
    let lineOne: String
    let timeZoneIdentifier: String?
    let poiDetailsType: PoiDetailsType

    init(placeId: String = "",
         displayAddress: String = "",
         lineOne: String = "",
         timeZoneIdentifier: String? = nil,
         poiDetailsType: PoiDetailsType = .notSetDetailsType) {
        self.placeId = placeId
        self.displayAddress = displayAddress
        self.lineOne = lineOne
        self.timeZoneIdentifier = timeZoneIdentifier
        self.poiDetailsType = poiDetailsType
    }

    func timezone() -> TimeZone? {
        guard let timezoneIdentifier = self.timeZoneIdentifier else {
            return nil
        }

        guard let defaultTimeZone = TimeZone(identifier: timezoneIdentifier) else {
            return nil
        }

        return defaultTimeZone
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.placeId = try container.decode(String.self, forKey: .placeId)
        self.displayAddress = try container.decode(String.self, forKey: .displayAddress)
        self.lineOne = try container.decode(String.self, forKey: .lineOne)
        self.timeZoneIdentifier = try? container.decode(String.self, forKey: .timeZoneIdentifier)
        self.poiDetailsType = try container.decode(PoiDetailsType.self, forKey: .poiDetailsType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(placeId, forKey: .placeId)
        try container.encode(displayAddress, forKey: .displayAddress)
        try container.encode(lineOne, forKey: .lineOne)
        try container.encode(timeZoneIdentifier, forKey: .timeZoneIdentifier)
        try container.encode(poiDetailsType, forKey: .poiDetailsType)
    }
    
    enum CodingKeys: String, CodingKey {
        case placeId
        case displayAddress
        case lineOne
        case location
        case timeZoneIdentifier
        case poiDetailsType
    }
}

struct RecentAddressList: KarhooCodableModel {
    var recents: [Address]
}
