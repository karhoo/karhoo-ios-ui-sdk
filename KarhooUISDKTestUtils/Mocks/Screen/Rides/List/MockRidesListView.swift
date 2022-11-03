//
//  MockRidesListVIew.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final class MockRidesListView: MockBaseViewController, RidesListView {

    var paginationEnabled: Bool = true

    var tripsToSet = [TripInfo]()
    func set(trips: [TripInfo]) {
        tripsToSet = trips
    }

    var emptyStateCalled = false
    var theEmptyStateTitle: String?
    var theEmptyStateMessage: String?
    func setEmptyState(title: String, message: String) {
        theEmptyStateTitle = title
        theEmptyStateMessage = message
        emptyStateCalled = true
    }

    private(set) var ridesListActionsSet: RidesListActions?
    func set(ridesListActions: RidesListActions) {
        ridesListActionsSet = ridesListActions
    }

    private(set) var ridesListPresenterSet: RidesListPresenter?
    func set(presenter: RidesListPresenter) {
        ridesListPresenterSet = presenter
    }

    private(set) var trackTripSet: TripInfo?
    func trackTrip(_ trip: TripInfo) {
        self.trackTripSet = trip
    }

    private(set) var rebookTripSet: TripInfo?
    func rebookTrip(_ trip: TripInfo) {
        self.rebookTripSet = trip
    }
}
