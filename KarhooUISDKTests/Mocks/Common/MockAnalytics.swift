//
//  TestAnalytics.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

class MockAnalytics: Analytics {
    
    var tripStateChangedCalled = false
    func tripStateChanged(tripState: TripInfo?) {
        tripStateChangedCalled = true
    }
    
    var fleetsShownCalled = false
    func fleetsShown(quoteListId: String?, amountShown: Int) {
        fleetsShownCalled = true
    }
    
    var prebookOpenedCalled = false
    func prebookOpened() {
        prebookOpenedCalled = true
    }
    
    var prebookSetCalled = false
    func prebookSet(date: Date, timezone: String) {
        prebookSetCalled = true
    }
    
    var userCalledDriverCalled = false
    func userCalledDriver(trip: TripInfo?) {
        userCalledDriverCalled = true
    }
    
    var pickupAddressSelectedCalled = false
    func pickupAddressSelected(locationDetails: LocationInfo) {
        pickupAddressSelectedCalled = true
    }
    
    var destinationAddressSelected = false
    func destinationAddressSelected(locationDetails: LocationInfo) {
        destinationAddressSelected = true
    }
    
    var bookingRequestedCalled = false
    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?) {
        bookingRequestedCalled = true
    }
}
