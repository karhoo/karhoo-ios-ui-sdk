//
//  QuoteListSortSnapshotSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 26/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import KarhooUISDKTestUtils
import Nimble
import Quick
import SnapshotTesting
@testable import KarhooUISDK

class QuoteListSortSnapshotSpec: QuickSpec {

    override class func spec() {

        describe("QuoteListSort") {
            var quoteListSortCoordinator: KarhooQuoteListSortCoordinator!

            beforeEach {
                quoteListSortCoordinator = KarhooQuoteListSortCoordinator(
                    selectedOption: .price,
                    onSortOptionComfirmed: { _ in }
                )
                quoteListSortCoordinator.start()
            }

            context("when it's showned") {

                it("should have a valid design") {
                    testSnapshot(quoteListSortCoordinator.viewController)
                }
            }
        }
    }
}
