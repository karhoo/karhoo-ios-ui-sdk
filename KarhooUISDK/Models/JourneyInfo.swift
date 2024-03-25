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

public extension Optional where Wrapped == JourneyInfo {
    var validatedOrNilJourneyInfo: JourneyInfo? {
        guard let origin = self?.origin else {
            return nil
        }
        
        let isDateAllowed = isJourneyInfoDateAllowed(self?.date)
        
        return JourneyInfo(
            origin: origin,
            destination: self?.destination,
            date: isDateAllowed ? self?.date : nil
        )
    }
    
    private func isJourneyInfoDateAllowed(_ date: Date?) -> Bool {
        guard let injectedDate = date else {
            return false
        }
        return injectedDate >= Date().addingTimeInterval(60*60)
    }
}
