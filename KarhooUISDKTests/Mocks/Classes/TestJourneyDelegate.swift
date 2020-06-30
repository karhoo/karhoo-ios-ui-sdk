//
//  TestJourneyDelegate.swift
//  KarhooTests
//
//  Created by vic on 28/02/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

class TestJourneyDelegate: JourneyFlowDelegate {
    
    var journeyCancelledByKarhooCalled = false
    func journeyCancelledByKarhoo() {
        journeyCancelledByKarhooCalled = true
    }
    
    var journeyCancelledByUserCalled = false
    func journeyCancelledByUser() {
        journeyCancelledByUserCalled = true
    }
    var journeyCancelledByDispatchCalled = false
    func journeyCancelledByDispatch() {
        journeyCancelledByDispatchCalled = true
    }
    var journeyCancelledNoDriversCalled = false
    func journeyCancelledNoDrivers(message: String) {
        journeyCancelledNoDriversCalled = true
    }
    var journeyCompletedCalled = false
    func journeyCompleted(completedTrip: TripInfo) {
        journeyCompletedCalled = true
    }
    var tripSummaryClosedCalled = false
    var rebookDetails: BookingDetails?
    func tripSummaryClosed(rebookDetails: BookingDetails?) {
        tripSummaryClosedCalled = true
        self.rebookDetails = rebookDetails
    }
    
    var closeJourneyCalled = false
    func closeJourney() {
        closeJourneyCalled = true
    }
}
