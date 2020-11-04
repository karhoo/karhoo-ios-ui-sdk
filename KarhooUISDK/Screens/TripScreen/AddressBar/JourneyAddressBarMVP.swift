//
//  JourneyAddressBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol JourneyAddressBarPresenter {
    init(trip: TripInfo)
    func load(view: AddressBarView?)
}
