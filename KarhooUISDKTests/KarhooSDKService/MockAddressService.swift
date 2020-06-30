//
//  MockAddressService.swift
//  Karhoo
//
//  Created by Yaser on 2017-04-11.
//  Copyright © 2017 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

@testable import Karhoo

final class MockAddressService: AddressService {

    private(set) var placeSearchCall = MockCall<Places>(executable: MockExecutable())
    private(set) var placeSearchSet: PlaceSearch?
    func placeSearch(placeSearch: PlaceSearch) -> Call<Places> {
        placeSearchSet = placeSearch
        return placeSearchCall
    }

    private(set) var locationInfoCall = MockCall<LocationInfo>(executable: MockExecutable())
    private(set) var locationInfoPlaceIdSet: String?
    func locationInfo(placeId: String) -> Call<LocationInfo> {
        locationInfoPlaceIdSet = placeId
        return locationInfoCall
    }

    private(set) var reverseGeocodeCall = MockCall<LocationInfo>(executable: MockExecutable())
    private(set) var reverseGeocodePositionSet: Position?
    func reverseGeocode(position: Position) -> Call<LocationInfo> {
        reverseGeocodePositionSet = position
        return reverseGeocodeCall
    }
}
