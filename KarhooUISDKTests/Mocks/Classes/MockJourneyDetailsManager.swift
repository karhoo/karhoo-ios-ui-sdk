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

final class MockJourneyDetailsManager: JourneyDetailsManager {
    var silentResetCalled = false
    func silentReset(with journeyDetails: JourneyDetails) {
        silentResetCalled = true
    }

    var journeyInfoSet: JourneyInfo?
    func setJourneyInfo(journeyInfo: JourneyInfo?) {
        journeyInfoSet = journeyInfo
    }

    weak var observer: JourneyDetailsObserver?

    func add(observer: JourneyDetailsObserver) {
        self.observer = observer
    }

    var removeCalled = false
    func remove(observer: JourneyDetailsObserver) {
        removeCalled = true
    }

    var pickupSet: LocationInfo?
    var pickupSetCalled = false
    func set(pickup: LocationInfo?) {
        pickupSet = pickup
        pickupSetCalled = true
    }

    var destinationSet: LocationInfo?
    var destinationSetCalled = false
    func set(destination: LocationInfo?) {
        destinationSet = destination
        destinationSetCalled = true
    }

    var dateSet: Date?
    var dateSetCalled = false
    func set(prebookDate: Date?) {
        dateSet = prebookDate
        dateSetCalled = true
    }

    var journeyDetailsToReturn: JourneyDetails?
    func getJourneyDetails() -> JourneyDetails? {
        return journeyDetailsToReturn
    }
    
    var resetCalled = false
    func reset() {
        resetCalled = true
    }

    var resetJourneyDetailsSet: JourneyDetails?
    func reset(with journeyDetails: JourneyDetails) {
        resetJourneyDetailsSet = journeyDetails
    }

    func triggerCallback(journeyDetails: JourneyDetails?) {
        observer?.journeyDetailsChanged(details: journeyDetails)
    }
}
