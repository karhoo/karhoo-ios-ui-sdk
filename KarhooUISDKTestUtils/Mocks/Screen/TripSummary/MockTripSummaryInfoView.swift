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

final public class MockTripSummaryInfoView: TripSummaryInfoView {

    public var viewModelSet: TripSummaryInfoViewModel?
    public func set(viewModel: TripSummaryInfoViewModel) {
        viewModelSet = viewModel
    }
}
