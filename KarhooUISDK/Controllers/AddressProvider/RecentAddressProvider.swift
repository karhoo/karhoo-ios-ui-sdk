//
//  RecentAddressProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol RecentAddressProvider {
    func getRecents() -> [LocationInfo]

    func add(recent: LocationInfo)
}
