//
//  RidePlanningScreenBuilder.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol RidePlanningScreenBuilder {
    func buildRidePlanningScreen(
        journeyInfo: JourneyInfo?,
        passengerDetails: PassengerDetails?,
        callback: ScreenResultCallback<KarhooRidePlanningResult>?
    ) -> Screen
}

public extension RidePlanningScreenBuilder {
    func buildRidePlanningScreen(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        callback: ScreenResultCallback<KarhooRidePlanningResult>?
    ) -> Screen {
        return buildRidePlanningScreen(
            journeyInfo: journeyInfo,
            passengerDetails: passengerDetails,
            callback: callback
        )
    }
}
