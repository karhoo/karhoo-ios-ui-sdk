//
//  MockPrebookConfirmationView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final public class MockPrebookConfirmationView: PrebookConfirmationView {
    public var viewModelSet: PrebookConfirmationViewModel?
    public func updateUI(withViewModel viewModel: PrebookConfirmationViewModel) {
        viewModelSet = viewModel
    }

    public var dismissViewCalled = false
    public func dimsissView() {
        dismissViewCalled = true
    }
}
