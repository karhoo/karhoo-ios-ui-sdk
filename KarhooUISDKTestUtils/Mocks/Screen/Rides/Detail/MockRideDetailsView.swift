//
//  MockRideDetailsView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final public class MockRideDetailsView: MockBaseViewController, RideDetailsView {

    public var setTripCalled: TripInfo!
    public func setUpWith(trip: TripInfo, mailComposer: FeedbackEmailComposer) {
        setTripCalled = trip
    }

    public var theNavigationTitleSet: String?
    public func set(navigationTitle: String) {
        theNavigationTitleSet = navigationTitle
    }

    public var didShowLoading = false
    public func showLoading() {
        didShowLoading = true
    }

    public var didHideLoading = false
    public func hideLoading() {
        didHideLoading = true
    }

    public var hideFeedbackOptionsCalled = false
    public func hideFeedbackOptions() {
        hideFeedbackOptionsCalled = true
    }

    public var setTrackButtonVisibleCalled = false
    public func setTrackButtonVisible(_ isVisible: Bool) {
        setTrackButtonVisibleCalled = true
    }
}
