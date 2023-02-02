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
            var sut: KarhooNewCheckoutViewController!
            var viewModel: KarhooNewCheckoutViewModel!
            
            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooNewCheckoutViewController()
                viewModel = KarhooNewCheckoutViewModel(
                    quote: TestUtil.getRandomQuote(),
                    journeyDetails: JourneyDetails.mock(),
                    bookingMetadata: nil,
                    router: NewCheckoutRouterMock()
                )
                sut.setupBinding(viewModel)
                navigationController.pushViewController(sut, animated: false)
            }
            
            context("when Checkout is oponed without poi") {
                it("no Flight or Train number should be visible") {
                    testSnapshot(navigationController)
                }
            }
        }
    }
}

class NewCheckoutRouterMock: NewCheckoutRouter {
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
