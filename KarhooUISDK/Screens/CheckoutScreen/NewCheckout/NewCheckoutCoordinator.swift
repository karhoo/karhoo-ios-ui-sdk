//
//  NewCheckoutCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK
import SwiftUI

final class KarhooNewCheckoutCoordinator: NewCheckoutCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: NewCheckoutViewController!
    private(set) var presenter: KarhooNewCheckoutViewModel?

    private var callback: ((ScreenResult<KarhooCheckoutResult>) -> Void)?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping (ScreenResult<KarhooCheckoutResult>) -> Void
    ) {
        self.navigationController = navigationController
        self.presenter = KarhooNewCheckoutViewModel(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            router: self
        )
        self.viewController = KarhooNewCheckoutViewController().then {
            $0.setupBinding(presenter!)
        }
        self.callback = callback
    }

}

extension KarhooNewCheckoutCoordinator: NewCheckoutRouter {
    func routeToPriceDetails(title: String, quoteType: QuoteType) {
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: title) { [weak self] in
                self?.baseViewController.dismiss(animated: true, completion: nil)
            }
        
        let contentViewModel = KarhooCheckoutPriceDetailsViewModel(quoteType: quoteType)
        let bottomSheet = KarhooBottomSheet(viewModel: bottomSheetViewModel) {
            KarhooCheckoutPriceDetailsView(viewModel: contentViewModel)
        }
        
        let viewController = UIHostingController(rootView: bottomSheet)
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overFullScreen
        baseViewController.present(viewController, animated: true, completion: nil)
    }

    func routeToPassengerDetails(
        _ currentDetails: PassengerDetails?,
        delegate: PassengerDetailsDelegate?
    ) {
        let detailsViewController = KarhooComponents.shared.passengerDetails(details: currentDetails, delegate: delegate)
        baseViewController.showAsOverlay(item: detailsViewController, animated: true)
    }

    func routeSuccessScene(
        with tripInfo: TripInfo,
        journeyDetails: JourneyDetails?,
        quote: Quote,
        loyaltyInfo: KarhooBasicLoyaltyInfo
    ) {
        if let journeyDetails, journeyDetails.isScheduled {
            routeToBookingConfirmation(
                trip: tripInfo,
                quote: quote,
                journeyDetails: journeyDetails,
                loyaltyInfo: loyaltyInfo,
                onDismiss: { [weak self] in
                    self?.callback?(ScreenResult.completed(result: KarhooCheckoutResult(tripInfo: tripInfo)))
                    self?.routeToShowBooking()
                }
            )
        } else {
            callback?(ScreenResult.completed(result: KarhooCheckoutResult(tripInfo: tripInfo)))
            routeToShowBooking()
        }
    }

    /// Dismiss current flow and take user back to booking map
    private func routeToShowBooking(completion: @escaping () -> Void = {}) {
        navigationController?.popToRootViewController(animated: true, completion: completion)
    }

    private func routeToBookingConfirmation(
        trip: TripInfo?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        loyaltyInfo: KarhooBasicLoyaltyInfo?,
        onDismiss: @escaping () -> Void
    ) {
        guard let viewController = viewController else {
            assertionFailure()
            return
        }
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: UITexts.Booking.prebookConfirmed,
            onDismissCallback: {
                viewController.dismiss(animated: true, completion: onDismiss)
            }
        )

        let confirmationViewModel = KarhooBookingConfirmationViewModel(
            journeyDetails: journeyDetails,
            quote: quote,
            trip: trip,
            loyaltyInfo: loyaltyInfo ?? .loyaltyDisabled(),
            onDismissCallback: {
                viewController.dismiss(animated: true, completion: onDismiss)
            }
        )

        let screenBuilder = UISDKScreenRouting.default.bottomSheetScreen()
        let sheet = screenBuilder.buildBottomSheetScreenBuilderForUIKit(viewModel: bottomSheetViewModel) {
            KarhooBookingConfirmationView(viewModel: confirmationViewModel)
        }
        viewController.present(sheet, animated: true)
    }
}
