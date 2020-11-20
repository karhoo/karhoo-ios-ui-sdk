//
//  TripAddressBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol TripAddressBarPresenter {
    init(trip: TripInfo)
    func load(view: AddressBarView?)
}
