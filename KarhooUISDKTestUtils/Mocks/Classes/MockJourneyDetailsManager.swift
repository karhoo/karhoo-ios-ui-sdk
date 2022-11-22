//
//  MockBookingStatus.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final public class MockJourneyDetailsManager: JourneyDetailsManager {

    public init() {}

    public var silentResetCalled = false
    public func silentReset(with journeyDetails: JourneyDetails) {
        silentResetCalled = true
    }

    public var journeyInfoSet: JourneyInfo?
    public func setJourneyInfo(journeyInfo: JourneyInfo?) {
        journeyInfoSet = journeyInfo
    }

    weak public var observer: JourneyDetailsObserver?

    public func add(observer: JourneyDetailsObserver) {
        self.observer = observer
    }

    public var removeCalled = false
    public func remove(observer: JourneyDetailsObserver) {
        removeCalled = true
    }

    public var pickupSet: LocationInfo?
    public var pickupSetCalled = false
    public func set(pickup: LocationInfo?) {
        pickupSet = pickup
        pickupSetCalled = true
    }

    public var destinationSet: LocationInfo?
    public var destinationSetCalled = false
    public func set(destination: LocationInfo?) {
        destinationSet = destination
        destinationSetCalled = true
    }

    public var dateSet: Date?
    public var dateSetCalled = false
    public func set(prebookDate: Date?) {
        dateSet = prebookDate
        dateSetCalled = true
    }

    public var journeyDetailsToReturn: JourneyDetails?
    public func getJourneyDetails() -> JourneyDetails? {
        return journeyDetailsToReturn
    }
    
    public var resetCalled = false
    public func reset() {
        resetCalled = true
    }

    public var resetJourneyDetailsSet: JourneyDetails?
    public func reset(with journeyDetails: JourneyDetails) {
        resetJourneyDetailsSet = journeyDetails
    }

    public func triggerCallback(journeyDetails: JourneyDetails?) {
        observer?.journeyDetailsChanged(details: journeyDetails)
    }
}
