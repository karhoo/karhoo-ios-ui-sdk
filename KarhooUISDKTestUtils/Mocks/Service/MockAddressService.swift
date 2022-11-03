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

final public class MockAddressService: AddressService {

    public var placeSearchCall = MockCall<Places>(executable: MockExecutable())
    public var placeSearchSet: PlaceSearch?
    public func placeSearch(placeSearch: PlaceSearch) -> Call<Places> {
        placeSearchSet = placeSearch
        return placeSearchCall
    }

    public var locationInfoCall = MockCall<LocationInfo>(executable: MockExecutable())
    public var locationInfoSearchSet: LocationInfoSearch?
    public func locationInfo(locationInfoSearch: LocationInfoSearch) -> Call<LocationInfo> {
        locationInfoSearchSet = locationInfoSearch
        return locationInfoCall
    }

    public var reverseGeocodeCall = MockCall<LocationInfo>(executable: MockExecutable())
    public var reverseGeocodePositionSet: Position?
    public func reverseGeocode(position: Position) -> Call<LocationInfo> {
        reverseGeocodePositionSet = position
        return reverseGeocodeCall
    }
}
