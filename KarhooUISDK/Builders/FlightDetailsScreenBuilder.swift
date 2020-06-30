//
//  FlightDetailsScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol FlightDetailsScreenBuilder {
    func buildFlightDetailsScreen(completion: @escaping ScreenResultCallback<FlightDetails>) -> Screen
}
