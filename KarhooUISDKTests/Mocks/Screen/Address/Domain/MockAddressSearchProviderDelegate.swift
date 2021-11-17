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

final class MockAddressSearchProviderDelegate: AddressSearchProviderDelegate {

    private(set) var searchCompletedWithPlaces: [Place]?
    func searchCompleted(places: [Place]) {
        searchCompletedWithPlaces = places
    }

    private(set) var recentsSet: [LocationInfo]?
    func useDefaultAddresses(recents: [LocationInfo]) {
        recentsSet = recents
    }

    private(set) var searchInProgressCalled = false
    func searchInProgress() {
        searchInProgressCalled = true
    }

    private(set) var searchFailedCalled = false
    private(set) var error: KarhooError?
    func searchFailed(error: KarhooError?) {
        searchFailedCalled = true
        self.error = error
    }
}
