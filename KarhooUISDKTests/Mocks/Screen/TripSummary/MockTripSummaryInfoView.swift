//
//  MockTripSummaryView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockTripSummaryInfoView: TripSummaryInfoView {

    private(set) var viewModelSet: TripSummaryInfoViewModel?
    func set(viewModel: TripSummaryInfoViewModel) {
        viewModelSet = viewModel
    }
}
