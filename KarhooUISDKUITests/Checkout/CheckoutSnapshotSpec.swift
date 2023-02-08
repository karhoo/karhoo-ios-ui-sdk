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
import Combine
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
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooCheckoutViewController()
            }
            /*
            context("when Checkout is oponed without poi and with scheduled ride") {
                beforeEach{
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name",
                        categoryName: "Category name",
                        type: "type"
                    )
                    let journeyDetails = JourneyDetails.mockWithScheduledDate()
                    viewModel = KarhooCheckoutViewModel(
                        quote: quote,
                        journeyDetails: journeyDetails,
                        bookingMetadata: nil,
                        router: MockCheckoutRouter()
                    )
                    sut.setupBinding(viewModel)
                    navigationController.pushViewController(sut, animated: false)
                }
                it("no Flight or Train number should be visible and time should be visible") {
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
                    let journeyDetails = JourneyDetails.mockWithScheduledDate(pickupPoiDetailsType: .airport)
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
            
            context("when pickup is from train station") {
                beforeEach {
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name with flight tracking",
                        fleetCapability: [FleetCapabilities.CodingKeys.trainTracking.rawValue],
                        categoryName: "Category name",
                        type: "type"
                    )
                    let journeyDetails = JourneyDetails.mockWithScheduledDate(pickupPoiDetailsType: .trainStation)
                    viewModel = KarhooCheckoutViewModel(
                        quote: quote,
                        journeyDetails: journeyDetails,
                        bookingMetadata: nil,
                        router: MockCheckoutRouter()
                    )
                    sut.setupBinding(viewModel)
                    navigationController.pushViewController(sut, animated: false)
                }
                
                it("Train number cell should be visible") {
                    testSnapshot(navigationController)
                }
            }
            
            context("when Checkout is oponed with earn + burn loyalty") {
                beforeEach{
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name",
                        categoryName: "Category name",
                        type: "type"
                    )
                    let journeyDetails = JourneyDetails.mockWithScheduledDate()
                    let loyaltyWorker = MockLoyaltyWorker()
                    viewModel = KarhooCheckoutViewModel(
                        quote: quote,
                        journeyDetails: journeyDetails,
                        bookingMetadata: nil,
                        router: MockCheckoutRouter(),
                        loyaltyWorker: loyaltyWorker
                    )
                    sut.setupBinding(viewModel)
                    
                    let loyaltyUiModel = LoyaltyUIModel(
                        loyaltyId: "loyaltyId",
                        currency: "USD",
                        tripAmount: 12.52,
                        canEarn: true,
                        canBurn: true,
                        burnAmount: 150,
                        earnAmount: 15, balance: 12345
                    )
                    navigationController.pushViewController(sut, animated: false)
                    loyaltyWorker.modelSubject.send(.success(result: loyaltyUiModel))
                    
                }
                it("Loyalty View should be visible") {
                    testSnapshot(navigationController)
                }
            }*/
            
            context("when Checkout is oponed with T&C checkbox required") {
                beforeEach{
                    KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                    quote = TestUtil.getRandomQuote(
                        fleetName: "Fleet name",
                        categoryName: "Category name",
                        type: "type"
                    )
                    let journeyDetails = JourneyDetails.mockWithScheduledDate()
                    viewModel = KarhooCheckoutViewModel(
                        quote: quote,
                        journeyDetails: journeyDetails,
                        bookingMetadata: nil,
                        router: MockCheckoutRouter()
                    )
                    sut.setupBinding(viewModel)
                    navigationController.pushViewController(sut, animated: false)
                }
                it("checkbox should be visible") {
                    testSnapshot(navigationController)
                }
            }
        }
    }
}

class MockCheckoutRouter: CheckoutRouter {
    func routeToPriceDetails(title: String, quoteType: KarhooSDK.QuoteType) {
        
    }
    
    func routeToFlightNumber(title: String, flightNumber: String) {
        
    }
    
    func routeToTrainNumber(title: String, trainNumber: String) {
        
    }
    
    func routeToComment(title: String, comments: String) {
        
    }
    
    func routeToPassengerDetails(_ currentDetails: KarhooSDK.PassengerDetails?, delegate: KarhooUISDK.PassengerDetailsDelegate?) {

    }
    
    func routeSuccessScene(with tripInfo: KarhooSDK.TripInfo, journeyDetails: KarhooUISDK.JourneyDetails?, quote: KarhooSDK.Quote, loyaltyInfo: KarhooUISDK.KarhooBasicLoyaltyInfo) {
        
    }
}

class MockLoyaltyWorker: LoyaltyWorker {
    
    var isLoyaltyEnabled: Bool = true
    var modelSubject = CurrentValueSubject<Result<LoyaltyUIModel?>, Never>(.success(result: nil))
    var modeSubject = CurrentValueSubject<LoyaltyMode, Never>(.none)
    
    func setup(using quote: Quote) { }
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) { }
}
