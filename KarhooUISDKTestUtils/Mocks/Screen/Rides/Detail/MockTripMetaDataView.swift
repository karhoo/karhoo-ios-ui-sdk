//
//  MockTripMetaDataView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final public class MockTripMetaDataView: TripMetaDataView {
    public init() {}

    public var setViewModel: TripMetaDataViewModel?
    public var setPresenter: TripMetaDataPresenter?
    public func set(viewModel: TripMetaDataViewModel,
             presenter: TripMetaDataPresenter) {
        setViewModel = viewModel
        setPresenter = presenter
    }

    public var hideRatingOptionsCalled = false
    public func hideRatingOptions() {
        hideRatingOptionsCalled = true
    }
}
