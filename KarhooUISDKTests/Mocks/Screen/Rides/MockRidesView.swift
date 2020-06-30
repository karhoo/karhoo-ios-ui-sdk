//
//  MockRidesView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final class MockRidesView: RidesView {

    var indexToSwitchTo: Int?
    func switchedToPageIndex(index: Int) {
        indexToSwitchTo = index
    }

    var thePages: [RidesListView]?
    func set(pageViews: [RidesListView]) {
        thePages = pageViews
    }

    var theSelectedTrip: TripInfo?
    func selected(_ trip: TripInfo) {
        theSelectedTrip = trip
    }

    var selectedTrackedTrip: TripInfo?
    func pressedTrackTrip(trip: TripInfo) {
        selectedTrackedTrip = trip
    }

    var didPressedRequestTrip = false
    func pressedRequestTrip() {
        didPressedRequestTrip = true
    }

    var movedTabToPastBookings = false
    func moveTabToPastBookings() {
        movedTabToPastBookings = true
    }

    var movedTabToUpcomingBookings = false
    func moveTabToUpcomingBookings() {
        movedTabToUpcomingBookings = true
    }

    var theTitleSet: String?
    func set(title: String) {
        theTitleSet = title
    }

    private(set) var dismissViewCalled = false
    func dismissView() {
        dismissViewCalled = true
    }
}
