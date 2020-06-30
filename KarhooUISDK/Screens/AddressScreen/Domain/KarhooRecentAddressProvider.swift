//
//  KarhooRecentAddressProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRecentAddressProvider: RecentAddressProvider {

    static let maxNoOfRecents = 5

    enum Key: String {
        case recents
    }

    private let persistantStore: UserDefaults

    init(persistantStore: UserDefaults = UserDefaults.standard) {
        self.persistantStore = persistantStore
    }

    func getRecents() -> [Address] {
        return  getExistingAddresses().recents
    }

    func add(recent: Address) {
        var recentAddresses = getExistingAddresses()
        
        if recentAddresses.recents.contains(where: { $0.placeId == recent.placeId }) {
            return
        }
        
        recentAddresses.recents.insert(recent, at: 0)

        if recentAddresses.recents.count > KarhooRecentAddressProvider.maxNoOfRecents {
            recentAddresses.recents.removeLast()
        }
        
        guard let encodedRecents = RecentAddressList(recents: recentAddresses.recents).encode() else {
            return
        }
        
        persistantStore.set(encodedRecents, forKey: Key.recents.rawValue)
        persistantStore.synchronize()
    }

    private func getExistingAddresses() -> RecentAddressList {
        guard let addressData = persistantStore.value(forKey: Key.recents.rawValue) as? Data else {
            return RecentAddressList(recents: [])
        }

        guard let decodedAddresses = try? JSONDecoder().decode(RecentAddressList.self, from: addressData) else {
            return RecentAddressList(recents: [])
        }
        
        return decodedAddresses
    }
}
