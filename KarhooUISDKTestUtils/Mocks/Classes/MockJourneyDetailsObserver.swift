//
//  MockBookingDetailsObserver.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockJourneyDetailsObserver: JourneyDetailsObserver {
    public init() { }

    public var lastJourneyDetails: JourneyDetails?
    public var journeyDetailsChangedCalled = false

    public func journeyDetailsChanged(details: JourneyDetails?) {
        lastJourneyDetails = details
        journeyDetailsChangedCalled = true
    }
}
