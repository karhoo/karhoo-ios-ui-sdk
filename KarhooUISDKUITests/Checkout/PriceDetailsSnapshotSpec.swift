//
//  PriceDetailsSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Bartlomiej Sopala on 08/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import KarhooUISDKTestUtils
import Nimble
import Quick
import SnapshotTesting
import SwiftUI
@testable import KarhooUISDK

class PriceDetailsSnapshotSpec: QuickSpec {
    override class func spec() {
        
        describe("PriceDetails") {
            var uikitWrapper: UIViewController!
            var bottomSheet: KarhooBottomSheet<KarhooCheckoutPriceDetailsView>?
            var sut: KarhooCheckoutPriceDetailsView!
            var viewModel: KarhooCheckoutPriceDetailsViewModel!
            
            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                viewModel = KarhooCheckoutPriceDetailsViewModel(quoteType: .fixed)
                sut = KarhooCheckoutPriceDetailsView(viewModel: viewModel)
                bottomSheet = KarhooBottomSheet(
                    viewModel: KarhooBottomSheetViewModel(
                        title: UITexts.Booking.priceDetailsTitle,
                        onDismissCallback: {}
                    ),
                    content: { sut! }
                )
                uikitWrapper = UIHostingController(rootView: bottomSheet)
            }
            
            context("when it's showed") {
                it("should have a valid design") {
                    testSnapshot(uikitWrapper)
                }
            }      
        }
    }
}
