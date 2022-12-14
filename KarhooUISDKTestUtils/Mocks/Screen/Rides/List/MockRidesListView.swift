//
//  MockRidesListVIew.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final public class MockRidesListView: MockBaseViewController, RidesListView {

    public var paginationEnabled: Bool = true

    public var tripsToSet = [TripInfo]()
    public func set(trips: [TripInfo]) {
        tripsToSet = trips
    }

    public var emptyStateCalled = false
    public var theEmptyStateTitle: String?
    public var theEmptyStateMessage: String?
    public func setEmptyState(title: String, message: String) {
        theEmptyStateTitle = title
        theEmptyStateMessage = message
        emptyStateCalled = true
    }

    public var ridesListActionsSet: RidesListActions?
    public func set(ridesListActions: RidesListActions) {
        ridesListActionsSet = ridesListActions
    }

    public var ridesListPresenterSet: RidesListPresenter?
    public func set(presenter: RidesListPresenter) {
        ridesListPresenterSet = presenter
    }

    public var trackTripSet: TripInfo?
    public func trackTrip(_ trip: TripInfo) {
        self.trackTripSet = trip
    }

    public var rebookTripSet: TripInfo?
    public func rebookTrip(_ trip: TripInfo) {
        self.rebookTripSet = trip
    }
}
