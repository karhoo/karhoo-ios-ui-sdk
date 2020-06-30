//
//  RecentAddressProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol RecentAddressProvider {
    func getRecents() -> [Address]

    func add(recent: Address)
}
