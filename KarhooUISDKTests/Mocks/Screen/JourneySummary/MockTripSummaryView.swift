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

final class MockJourneySummaryInfoView: JourneySummaryInfoView {

    private(set) var viewModelSet: JourneySummaryInfoViewModel?
    func set(viewModel: JourneySummaryInfoViewModel) {
        viewModelSet = viewModel
    }
}
