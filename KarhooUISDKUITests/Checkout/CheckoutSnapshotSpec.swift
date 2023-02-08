//
//  CheckoutSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Bartlomiej Sopala on 02/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class CheckoutSnapshotSpec: QuickSpec {
    
    override func spec() {
        describe("Checkout") {
            var navigationController: NavigationController!
            var sut: KarhooCheckoutViewController!
            var viewModel: KarhooCheckoutViewModel!
            var quote: Quote!
            
            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                quote = TestUtil.getRandomQuote(
                    fleetName: "Fleet name",
                    categoryName: "Category name",
                    type: "type"
                )
                let journeyDetails = JourneyDetails.mockWithTwoAddressesAndScheduledDate()
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooCheckoutViewController()
                viewModel = KarhooCheckoutViewModel(
                    quote: quote,
                    journeyDetails: journeyDetails,
                    bookingMetadata: nil,
                    router: MockCheckoutRouter()
                )
                sut.setupBinding(viewModel)
                navigationController.pushViewController(sut, animated: false)
            }
            
            context("when Checkout is oponed without poi") {
                it("no Flight or Train number should be visible") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when pickup is from airport") {
                beforeEach {
                    let journeyDetails = JourneyDetails.mockWithTwoAddressesAndScheduledDate()
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name 2",
                        fleetCapability: [FleetCapabilities.flightTracking.rawValue],
                        categoryName: "Category name",
                        type: "type"
                    )
                    viewModel = KarhooCheckoutViewModel(
                        quote: quote,
                        journeyDetails: journeyDetails,
                        bookingMetadata: nil,
                        router: MockCheckoutRouter()
                    )
                    sut.setupBinding(viewModel)
                    navigationController.pushViewController(sut, animated: false)
                }

                it("Flight number cell should be visible") {
                    testSnapshot(navigationController)
                }
            }
        }
    }
}
