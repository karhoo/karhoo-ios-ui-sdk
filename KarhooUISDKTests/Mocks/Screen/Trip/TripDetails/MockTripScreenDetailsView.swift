//
//  MockTripScreenDetailsView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final class MockTripScreenDetailsView: UIView, TripScreenDetailsView {

    func set(actions: TripDetailsActions,
             detailsSuperview: UIView) {}

    func start(tripId: String) {}

    func stop() {}

    private(set) var viewModelSet: TripScreenDetailsViewModel?
    func updateViewModel(tripScreenDetailsViewModel: TripScreenDetailsViewModel) {
        self.viewModelSet = tripScreenDetailsViewModel
    }

}
