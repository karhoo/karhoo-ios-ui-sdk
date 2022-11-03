//
//  MockAddressSearchProviderDelegate.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final public class MockAddressSearchProviderDelegate: AddressSearchProviderDelegate {
    public init() {}

    public var searchCompletedWithPlaces: [Place]?
    public func searchCompleted(places: [Place]) {
        searchCompletedWithPlaces = places
    }

    public var recentsSet: [LocationInfo]?
    public func useDefaultAddresses(recents: [LocationInfo]) {
        recentsSet = recents
    }

    public var searchInProgressCalled = false
    public func searchInProgress() {
        searchInProgressCalled = true
    }

    public var searchFailedCalled = false
    public var error: KarhooError?
    public func searchFailed(error: KarhooError?) {
        searchFailedCalled = true
        self.error = error
    }
}
