//
//  QuoteListSortSnapshotSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 26/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import KarhooSDK

@testable import KarhooUISDK

class QuoteListSortSnapshotSpec: QuickSpec {

    override func spec() {

        describe("QuoteListSort") {
            var navigationController: NavigationController!
            var sut: KarhooQuoteListSortViewController!
            var presenterMock: QuoteListSortPresenter!

            beforeEach {
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooQuoteListSortViewController()
                presenterMock = MockQuoteListSortPresenter()
                sut.setupBinding(presenterMock)
                navigationController.present(sut, animated: false)
            }

            context("when it's showned") {

                it("should have a valid design") {
                    testSnapshot(navigationController)
                }
            }
        }
    }
}
