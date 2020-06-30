//
//  MockRideDetailsView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final class MockRideDetailsView: MockBaseViewController, RideDetailsView {

    var setTripCalled: TripInfo!
    func setUpWith(trip: TripInfo, mailComposer: FeedbackMailComposer) {
        setTripCalled = trip
    }

    var theNavigationTitleSet: String?
    func set(navigationTitle: String) {
        theNavigationTitleSet = navigationTitle
    }

    private(set) var didShowLoading = false
    func showLoading() {
        didShowLoading = true
    }

    private(set) var didHideLoading = false
    func hideLoading() {
        didHideLoading = true
    }

    private(set) var hideFeedbackOptionsCalled = false
    func hideFeedbackOptions() {
        hideFeedbackOptionsCalled = true
    }
}
