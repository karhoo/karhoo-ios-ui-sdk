//
//  FlightDetails.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct FlightDetails {
    public let flightNumber: String?
    public let comments: String?

    public init(flightNumber: String? = nil,
                comments: String? = nil) {
        self.flightNumber = flightNumber
        self.comments = comments
    }
}
