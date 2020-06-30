//
//  MockQuoteSortView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockQuoteSortView: QuoteSortView {

    private(set) var showQuoteSortViewCalled = false
    func showQuoteSorter() {
        showQuoteSortViewCalled = true
    }

    private(set) var hideQuoteSortViewCalled = false
    func hideQuoteSorter() {
        hideQuoteSortViewCalled = true
    }
}
