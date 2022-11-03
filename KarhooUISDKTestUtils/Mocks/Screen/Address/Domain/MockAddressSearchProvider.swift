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

final public class MockAddressSearchProvider: AddressSearchProvider {
    public var delegate: AddressSearchProviderDelegate? // swiftlint:disable:this weak_delegate
    public var preferredLocation: CLLocation?
    public var searchString: String?

    public var sessionToken: String = ""

    public var fetchDefaultValuesCalled = false

    public func set(delegate: AddressSearchProviderDelegate?) {
        self.delegate = delegate
    }

    public func set(preferredLocation: CLLocation?) {
        self.preferredLocation = preferredLocation
    }

    public func search(for string: String) {
        searchString = string
    }

    public func triggerSuccessResponse(places: [Place]) {
        delegate?.searchCompleted(places: places)
    }

    public func fetchDefaultValues() {
        fetchDefaultValuesCalled = true
    }

    public func triggerDefaultResponse(recents: [LocationInfo]) {
        delegate?.useDefaultAddresses(recents: recents)
    }

    public func triggerSearchInProgress() {
        delegate?.searchInProgress()
    }

    public func triggerFailedSearch(error: KarhooError?) {
        delegate?.searchFailed(error: error)
    }
}
