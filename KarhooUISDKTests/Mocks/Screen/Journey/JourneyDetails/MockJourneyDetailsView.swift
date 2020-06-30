//
//  MockJourneyDetailsView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final class MockJourneyDetailsView: UIView, JourneyDetailsView {

    func set(actions: JourneyDetailsActions,
             detailsSuperview: UIView) {}

    func start(tripId: String) {}

    func stop() {}

    private(set) var viewModelSet: JourneyDetailsViewModel?
    func updateViewModel(journeyDetailsViewModel: JourneyDetailsViewModel) {
        self.viewModelSet = journeyDetailsViewModel
    }

}
