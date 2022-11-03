//
//  MockRidesView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final public class MockRidesView: RidesView {

    public var indexToSwitchTo: Int?
    public func switchedToPageIndex(index: Int) {
        indexToSwitchTo = index
    }

    public var thePages: [RidesListView]?
    public func set(pageViews: [RidesListView]) {
        thePages = pageViews
    }

    public var theSelectedTrip: TripInfo?
    public func selected(_ trip: TripInfo) {
        theSelectedTrip = trip
    }

    public var selectedTrackedTrip: TripInfo?
    public func pressedTrackTrip(trip: TripInfo) {
        selectedTrackedTrip = trip
    }

    public var didPressedRequestTrip = false
    public func pressedRequestTrip() {
        didPressedRequestTrip = true
    }

    public var movedTabToPastBookings = false
    public func moveTabToPastBookings() {
        movedTabToPastBookings = true
    }

    public var movedTabToUpcomingBookings = false
    public func moveTabToUpcomingBookings() {
        movedTabToUpcomingBookings = true
    }

    public var theTitleSet: String?
    public func set(title: String) {
        theTitleSet = title
    }

    public var dismissViewCalled = false
    public func dismissView() {
        dismissViewCalled = true
    }
}
