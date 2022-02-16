//
//  RideCellStackButtonActions.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol RideCellStackButtonActions {

    func track(_ trip: TripInfo)
    func contactFleet(_ trip: TripInfo, number: String)
    func contactDriver(_ trip: TripInfo, number: String)
}
