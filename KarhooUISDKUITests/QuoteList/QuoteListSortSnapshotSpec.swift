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
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class QuoteListSortSnapshotSpec: QuickSpec {

    override func spec() {

        describe("QuoteListSort") {
            var navigationController: NavigationController!
            var sut: KarhooQuoteListSortViewController!
            var presenterMock: QuoteListSortPresenter!

            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                    $0.view.backgroundColor = .white
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooQuoteListSortViewController()
                presenterMock = MockQuoteListSortPresenter()
                sut.setupBinding(presenterMock)
                mockVC.present(sut, animated: false)
            }

            context("when it's showned") {

                it("should have a valid design") {
//                    testSnapshot(navigationController)
                    assertSnapshot(
                        matching: navigationController.view,
                        as: .wait(
                            for: 3,
                            on: .image
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }
        }
    }
}
