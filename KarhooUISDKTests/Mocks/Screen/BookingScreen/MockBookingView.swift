//
//  TestBookingScreen.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockBookingView: MockBaseViewController, BookingView {

    private(set) var leftNavigationButtonSet: NavigationBarItemIcon?
    func set(leftNavigationButton: NavigationBarItemIcon) {
        leftNavigationButtonSet = leftNavigationButton
    }

    private var sideMenuSet: SideMenu?
    func set(sideMenu: SideMenu) {
        sideMenuSet = sideMenu
    }

    private(set) var focusMapCalled = false
    func locatePressed() {
        focusMapCalled = true
    }

    private(set) var resetCalled = false
    func reset() {
        resetCalled = true
    }

    private(set) var resetAndLocateCalled = false
    func resetAndLocate() {
        resetAndLocateCalled = true
    }

    private(set) var theSetBookingDetails: JourneyDetails?
    func set(bookingDetails: JourneyDetails) {
        theSetBookingDetails = bookingDetails
    }

    private(set) var showAllocationScreenCalled = false
    private(set) var showAllocationScreenTripSet: TripInfo?
    func showAllocationScreen(trip: TripInfo) {
        showAllocationScreenCalled = true
        showAllocationScreenTripSet = trip
    }

    private(set) var hideAllocationScreenCalled = false
    func hideAllocationScreen() {
        hideAllocationScreenCalled = true
    }

    private(set) var showQuoteListCalled = false
    func showQuoteList() {
        showQuoteListCalled = true
    }

    private(set) var hideQuoteListCalled = false
    func hideQuoteList() {
        hideQuoteListCalled = true
    }

    private(set) var setMapPaddingCalled = false
    private(set) var mapPaddingBottomPaddingEnabled: Bool?
    func setMapPadding(bottomPaddingEnabled: Bool) {
        setMapPaddingCalled = true
        mapPaddingBottomPaddingEnabled = bottomPaddingEnabled
    }

    private(set) var tripToOpen: TripInfo?
    private(set) var openRidesListCalled = false
    private(set) var availabilityValueSet: Bool!
    private(set) var openRidesDetailsCalled = false
}

extension MockBookingView: BookingScreen {

    func openTrip(_ trip: TripInfo) {
        tripToOpen = trip
    }
    
    func openRidesList(presentationStyle: UIModalPresentationStyle?) {
        openRidesListCalled = true
    }
    
    func openRideDetailsFor(_ trip: TripInfo) {
        openRidesDetailsCalled = true
    }
}

extension MockBookingView: QuoteListActions {

    func didSelectQuote(_ quote: Quote) {}

    func quotesAvailabilityDidUpdate(availability: Bool) {
        availabilityValueSet = availability
    }

}
