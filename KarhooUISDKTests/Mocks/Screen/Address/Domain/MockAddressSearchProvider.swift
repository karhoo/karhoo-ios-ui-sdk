//
//  MockAddressSearchProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

@testable import KarhooUISDK

final class MockAddressSearchProvider: AddressSearchProvider {
    var delegate: AddressSearchProviderDelegate? //swiftlint:disable:this weak_delegate
    var preferredLocation: CLLocation?
    var searchString: String?

    var sessionToken: String = ""

    var fetchDefaultValuesCalled = false

    func set(delegate: AddressSearchProviderDelegate?) {
        self.delegate = delegate
    }

    func set(preferredLocation: CLLocation?) {
        self.preferredLocation = preferredLocation
    }

    func search(for string: String) {
        searchString = string
    }

    func triggerSuccessResponse(places: [Place]) {
        delegate?.searchCompleted(places: places)
    }

    func fetchDefaultValues() {
        fetchDefaultValuesCalled = true
    }

    func triggerDefaultResponse(recents: [Address]) {
        delegate?.useDefaultAddresses(recents: recents)
    }

    func triggerSearchInProgress() {
        delegate?.searchInProgress()
    }

    func triggerFailedSearch(error: KarhooError?) {
        delegate?.searchFailed(error: error)
    }
}
