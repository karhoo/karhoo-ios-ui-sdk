//
//  TestBookingScreen.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
@testable import KarhooUISDK

final public class MockBookingView: MockBaseViewController, BookingView {

    public var leftNavigationButtonSet: NavigationBarItemIcon?
    public func set(leftNavigationButton: NavigationBarItemIcon) {
        leftNavigationButtonSet = leftNavigationButton
    }

    private var sideMenuSet: SideMenu?
    public func set(sideMenu: SideMenu) {
        sideMenuSet = sideMenu
    }

    public var focusMapCalled = false
    public func locatePressed() {
        focusMapCalled = true
    }

    public var resetCalled = false
    public func reset() {
        resetCalled = true
    }

    public var resetAndLocateCalled = false
    public func resetAndLocate() {
        resetAndLocateCalled = true
    }

    public var theSetJourneyDetails: JourneyDetails?
    public func set(journeyDetails: JourneyDetails) {
        theSetJourneyDetails = journeyDetails
    }

    public var showAllocationScreenCalled = false
    public var showAllocationScreenTripSet: TripInfo?
    public func showAllocationScreen(trip: TripInfo) {
        showAllocationScreenCalled = true
        showAllocationScreenTripSet = trip
    }

    public var hideAllocationScreenCalled = false
    public func hideAllocationScreen() {
        hideAllocationScreenCalled = true
    }

    public var tripToOpen: TripInfo?
    public var openRidesListCalled = false
    public var openRidesDetailsCalled = false
}

extension MockBookingView: BookingScreen {

    public func openTrip(_ trip: TripInfo) {
        tripToOpen = trip
    }
    
    public func openRidesList(presentationStyle: UIModalPresentationStyle?) {
        openRidesListCalled = true
    }
    
    public func openRideDetailsFor(_ trip: TripInfo) {
        openRidesDetailsCalled = true
    }
}
