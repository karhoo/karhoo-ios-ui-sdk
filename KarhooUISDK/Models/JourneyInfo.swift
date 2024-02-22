//
//  JourneyInfo.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public struct JourneyInfo: Equatable {
    
    public let origin: CLLocation
    public let destination: CLLocation?
    public let date: Date?
    
    public init(origin: CLLocation,
                destination: CLLocation? = nil,
                date: Date? = nil) {
        self.origin = origin
        self.destination = destination
        self.date = date
    }
}
