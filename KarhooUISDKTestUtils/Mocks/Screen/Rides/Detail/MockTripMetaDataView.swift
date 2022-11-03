//
//  MockTripMetaDataView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockTripMetaDataView: TripMetaDataView {

    var setViewModel: TripMetaDataViewModel?
    var setPresenter: TripMetaDataPresenter?
    func set(viewModel: TripMetaDataViewModel,
             presenter: TripMetaDataPresenter) {
        setViewModel = viewModel
        setPresenter = presenter
    }

    private(set) var hideRatingOptionsCalled = false
    func hideRatingOptions() {
        hideRatingOptionsCalled = true
    }
}
