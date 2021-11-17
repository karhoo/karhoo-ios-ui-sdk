//
//  KarhooRecentAddressProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooRecentAddressProvider: RecentAddressProvider {

    static let maxNoOfRecents = 5

    enum Key: String {
        case recents
    }

    private let persistantStore: UserDefaults

    init(persistantStore: UserDefaults = UserDefaults.standard) {
        self.persistantStore = persistantStore
    }

    func getRecents() -> [LocationInfo] {
        return  getExistingAddresses().recents
    }

    func add(recent: LocationInfo) {
        var recentAddresses = getExistingAddresses()
        
        if recentAddresses.recents.contains(where: { $0.position == recent.position }) {
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

        guard var decodedAddresses = try? JSONDecoder().decode(RecentAddressList.self, from: addressData) else {
            return RecentAddressList(recents: [])
        }
        
        // Note: When switching from storing [Address] to [LocationInfo], the place ids were decoded as empty strings
        // This is a one time purge of any invalid data. Next time the user adds a new recent the list will be overwritten with a valid [LocationInfo]
        if decodedAddresses.recents.first(where: { $0.placeId.isEmpty }) != nil {
            decodedAddresses.recents = decodedAddresses.recents.filter({ !$0.placeId.isEmpty })
        }
        
        return decodedAddresses
    }
}
