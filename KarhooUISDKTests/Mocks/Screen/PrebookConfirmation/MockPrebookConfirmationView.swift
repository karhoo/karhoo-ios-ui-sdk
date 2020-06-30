//
//  MockPrebookConfirmationView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final class MockPrebookConfirmationView: PrebookConfirmationView {
    private(set) var viewModelSet: PrebookConfirmationViewModel?
    func updateUI(withViewModel viewModel: PrebookConfirmationViewModel) {
        viewModelSet = viewModel
    }

    private(set) var dismissViewCalled = false
    func dimsissView() {
        dismissViewCalled = true
    }
}
