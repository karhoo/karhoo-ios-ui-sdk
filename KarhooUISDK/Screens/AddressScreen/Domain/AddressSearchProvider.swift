//
//  AddressSearchProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

protocol AddressSearchProviderDelegate: class {
    func searchCompleted(places: [Place])
    func useDefaultAddresses(recents: [Address])
    func searchInProgress()
    func searchFailed(error: KarhooError?)
}

protocol AddressSearchProvider {
    func set(delegate: AddressSearchProviderDelegate?)
    func set(preferredLocation: CLLocation?)
    func search(for string: String)
    func fetchDefaultValues()
    var sessionToken: String { get set }
}
