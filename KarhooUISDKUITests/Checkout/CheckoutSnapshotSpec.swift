//
//  CheckoutSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Bartlomiej Sopala on 02/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK
import KarhooUISDKTestUtils
import Nimble
import Quick
import SnapshotTesting
@testable import KarhooUISDK

class CheckoutSnapshotSpec: QuickSpec {
    
    override class func spec() {
        describe("Checkout") {
            var navigationController: NavigationController!
            var sut: KarhooCheckoutViewController!
            var viewModel: KarhooCheckoutViewModel!
            var quote: Quote!
            var journeyDetails: JourneyDetails!
            
            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooCheckoutViewController()
                navigationController.pushViewController(sut, animated: false)
                quote = TestUtil.getRandomQuote(
                    fleetName: "Fleet name",
                    categoryName: "Category name",
                    type: "type"
                )
                journeyDetails = JourneyDetails.mockWithScheduledDate()
            }
            
            context("when Checkout is opened without poi and with scheduled ride") {
                beforeEach {
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                    viewModel.legalNoticeViewModel.shouldShowView = false
                    
                }
                it("should have visible time and not visible train and flight cells") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when pickup is from airport") {
                beforeEach {
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name with flight tracking",
                        fleetCapability: [FleetCapabilities.CodingKeys.flightTracking.rawValue],
                        categoryName: "Category name",
                        type: "type"
                    )
                    journeyDetails = JourneyDetails.mockWithScheduledDate(pickupPoiDetailsType: .airport)
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                }
                
                it("should have flight number cell") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when pickup is from train station") {
                beforeEach {
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name with train tracking",
                        fleetCapability: [FleetCapabilities.CodingKeys.trainTracking.rawValue],
                        categoryName: "Category name",
                        type: "type"
                    )
                    journeyDetails = JourneyDetails.mockWithScheduledDate(pickupPoiDetailsType: .trainStation)
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                }
                
                it("should have train number cell visible") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when Checkout is opened with earn + burn loyalty") {
                beforeEach {
                    let loyaltyWorker = MockLoyaltyWorker()
                    setupSutWith(quote: quote, journeyDetails: journeyDetails, loyaltyWorker: loyaltyWorker)
                    
                    let loyaltyUiModel = LoyaltyUIModel(
                        loyaltyId: "loyaltyId",
                        currency: "USD",
                        tripAmount: 12.52,
                        canEarn: true,
                        canBurn: true,
                        burnAmount: 150,
                        earnAmount: 15, balance: 12345
                    )
                    loyaltyWorker.modelSubject.send(.success(result: loyaltyUiModel))
                    
                }
                it("should have valid design") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when Checkout is opened with T&C checkbox required") {
                beforeEach {
                    KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                }
                it("should have checkbox") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when Checkout is opened with T&C checkbox required and user tap checkbox") {
                beforeEach {
                    KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                    viewModel.termsConditionsViewModel.didTapCheckbox()
                }
                it("should have selected checkbox") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 1,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }
            
            context("when status is readyToBook") {
                beforeEach {
                    KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = false
                    setupSutWith(quote: quote, journeyDetails: journeyDetails)
                    viewModel.state = .readyToBook
                }
                it("should have PAY button") {
                    testSnapshot(navigationController)
                }
            }
            
            func setupSutWith(
                quote: Quote,
                journeyDetails: JourneyDetails,
                loyaltyWorker: LoyaltyWorker = KarhooLoyaltyWorker.shared
            ) {
                viewModel = KarhooCheckoutViewModel(
                    quote: quote,
                    journeyDetails: journeyDetails,
                    bookingMetadata: nil,
                    loyaltyWorker: loyaltyWorker,
                    router: MockCheckoutRouter()
                )
                sut.setupBinding(viewModel)
            }
        }
    }
}
