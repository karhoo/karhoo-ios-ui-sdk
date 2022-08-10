//
//  KarhooAddressSearchProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

final class KarhooAddressSearchProvider: AddressSearchProvider {

    private let addressService: AddressService
    private let recentAddressProvider: RecentAddressProvider
    private weak var delegate: AddressSearchProviderDelegate?
    private var preferredLocation: CLLocation?
    private var lastSearch: String = ""
    public var sessionToken: String = ""

    init(addressService: AddressService = Karhoo.getAddressService(),
         recentAddressProvider: RecentAddressProvider = KarhooRecentAddressProvider()) {
        self.addressService = addressService
        self.recentAddressProvider = recentAddressProvider
    }

    func set(delegate: AddressSearchProviderDelegate?) {
        self.delegate = delegate
    }

    func set(preferredLocation: CLLocation?) {
        self.preferredLocation = preferredLocation
    }

    func search(for string: String) {
        lastSearch = string

        if string.count >= 3 {
            performSearch(string: string)
        } else {
            returnDefaults()
        }
    }

    func fetchDefaultValues() {
        returnDefaults()
    }

    private func performSearch(string: String) {
        delegate?.searchInProgress()
        let searchCallback = { [weak self] (result: Result<Places>) in
            switch result {
            case .success(let places, _):
                self?.searchCompleted(search: string, places: places.places)
            case .failure(let error, _):
                self?.searchFailed(search: string, error: error)
            }
        }

        let placeSearch = PlaceSearch(position: preferredLocation?.toPosition() ?? Position(),
                                      query: string,
                                      sessionToken: sessionToken)
            addressService.placeSearch(placeSearch: placeSearch)
                .execute(callback: searchCallback)
    }

    private func searchCompleted(search: String, places: [Place]) {
        guard lastSearch.hasPrefix(search) == true else {
            return
        }
        delegate?.searchCompleted(places: places)
    }

    private func searchFailed(search: String, error: KarhooError?) {
        guard lastSearch == search else {
            return
        }
        delegate?.searchFailed(error: error)
    }

    private func returnDefaults() {
        let recents = recentAddressProvider.getRecents()
        delegate?.useDefaultAddresses(recents: recents)
    }
}
