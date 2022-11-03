//
//  MockAddressService.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

final class MockAddressService: AddressService {

    private(set) var placeSearchCall = MockCall<Places>(executable: MockExecutable())
    private(set) var placeSearchSet: PlaceSearch?
    func placeSearch(placeSearch: PlaceSearch) -> Call<Places> {
        placeSearchSet = placeSearch
        return placeSearchCall
    }

    private(set) var locationInfoCall = MockCall<LocationInfo>(executable: MockExecutable())
    private(set) var locationInfoSearchSet: LocationInfoSearch?
    func locationInfo(locationInfoSearch: LocationInfoSearch) -> Call<LocationInfo> {
        locationInfoSearchSet = locationInfoSearch
        return locationInfoCall
    }

    private(set) var reverseGeocodeCall = MockCall<LocationInfo>(executable: MockExecutable())
    private(set) var reverseGeocodePositionSet: Position?
    func reverseGeocode(position: Position) -> Call<LocationInfo> {
        reverseGeocodePositionSet = position
        return reverseGeocodeCall
    }
}
