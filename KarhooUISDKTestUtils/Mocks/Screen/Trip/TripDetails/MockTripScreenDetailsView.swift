//
//  MockTripScreenDetailsView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final public class MockTripScreenDetailsView: UIView, TripScreenDetailsView {

    public func set(actions: TripScreenDetailsActions,
             detailsSuperview: UIView) {}

    public func start(tripId: String) {}

    public func stop() {}

    public var viewModelSet: TripScreenDetailsViewModel?
    public func updateViewModel(tripDetailsViewModel: TripScreenDetailsViewModel) {
        self.viewModelSet = tripDetailsViewModel
    }

}
