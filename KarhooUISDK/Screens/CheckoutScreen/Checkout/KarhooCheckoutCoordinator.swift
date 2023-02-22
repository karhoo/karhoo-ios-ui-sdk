//
//  CheckoutCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK
import SwiftUI

final class KarhooCheckoutCoordinator: CheckoutCoordinator {

    // MARK: - Nested types

    class Builder: CheckoutScreenBuilder {
        func buildCheckoutCoordinator(
            navigationController: UINavigationController?,
            quote: Quote,
            journeyDetails: JourneyDetails,
            bookingMetadata: [String: Any]?,
            callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
        ) -> KarhooUISDKSceneCoordinator {
            KarhooCheckoutCoordinator(
                navigationController: navigationController,
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: bookingMetadata,
                callback: callback
            )
        }
    }

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: CheckoutViewController!
    private(set) var presenter: KarhooCheckoutViewModel?

    private var callback: ((ScreenResult<KarhooCheckoutResult>) -> Void)?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping (ScreenResult<KarhooCheckoutResult>) -> Void
    ) {
        self.presenter = KarhooCheckoutViewModel(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            router: self
        )
        self.viewController = KarhooCheckoutViewController().then {
            $0.setupBinding(presenter!)
        }
        self.navigationController = navigationController ?? NavigationController(
            rootViewController: self.viewController,
            style: .primary
        )
        self.callback = callback
    }
}

extension KarhooCheckoutCoordinator: CheckoutRouter {
    func routeToPriceDetails(title: String, quoteType: QuoteType) {
        let contentViewModel = KarhooCheckoutPriceDetailsViewModel(quoteType: quoteType)
        let contentView = KarhooCheckoutPriceDetailsView(viewModel: contentViewModel)
        let onDismiss: (_: ScreenResult<Void>) -> Void = { _ in
            self.baseViewController.dismiss(animated: true, completion: nil)
        }
        baseViewController.presentUsingBootomSheet(
            title: title,
            bottomSheetContentView: contentView,
            onSheetDismiss: onDismiss
        )
    }
    
    func routeToFlightNumber(title: String, flightNumber: String) {
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        let contentViewModel = KarhooBottomSheetContentWithTextFieldViewModel(
            contentType: .flightNumber,
            initialValueForTextField: presenter.flightNumberCellViewModel.getFlightNumber(),
            viewSubtitle: UITexts.Booking.flightSubtitle,
            textFieldHint: UITexts.Booking.flightExample,
            errorMessage: UITexts.Booking.onlyLettersAndDigitsAllowedError
        ) { [weak self] newFlightNumber in

            self?.presenter?.flightNumberCellViewModel.setFlightNumber(newFlightNumber)
            self?.baseViewController.dismiss(animated: true, completion: nil)
            
        }
        let contentView = KarhooBottomSheetContentWithTextFieldView(viewModel: contentViewModel)
        let onDismiss: (_: ScreenResult<Void>) -> Void = { _ in
            self.baseViewController.dismiss(animated: true, completion: nil)
        }
        baseViewController.presentUsingBootomSheet(
            title: title,
            bottomSheetContentView: contentView,
            onSheetDismiss: onDismiss
        )
    }
    
    func routeToTrainNumber(title: String, trainNumber: String) {
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        let contentViewModel = KarhooBottomSheetContentWithTextFieldViewModel(
            contentType: .trainNumber,
            initialValueForTextField: presenter.trainNumberCellViewModel.getTrainNumber(),
            viewSubtitle: UITexts.Booking.trainSubtitle,
            textFieldHint: UITexts.Booking.trainExample,
            errorMessage: UITexts.Booking.onlyLettersAndDigitsAllowedError
        ) { [weak self] newTrainNumber in

            self?.presenter?.trainNumberCellViewModel.setTrainNumber(newTrainNumber)
            self?.baseViewController.dismiss(animated: true, completion: nil)
            
        }
        let contentView = KarhooBottomSheetContentWithTextFieldView(viewModel: contentViewModel)
        let onDismiss: (_: ScreenResult<Void>) -> Void = { _ in
            self.baseViewController.dismiss(animated: true, completion: nil)
        }
        baseViewController.presentUsingBootomSheet(
            title: title,
            bottomSheetContentView: contentView,
            onSheetDismiss: onDismiss
        )
    }
    
    func routeToComment(title: String, comments: String) {
        guard let presenter = presenter else {
            assertionFailure("Presenter is missing")
            return
        }
        let contentViewModel = KarhooBottomSheetCommentsViewModel(
            initialValueForTextView: presenter.commentCellViewModel.getComment(),
            viewSubtitle: UITexts.Booking.commentsSubtitle
        ) { [weak self] comment in
            self?.presenter?.commentCellViewModel.setComment(comment)
            self?.baseViewController.dismiss(animated: true, completion: nil)
        }
        let contentView = KarhooBottomSheetCommentsView(viewModel: contentViewModel)
        let onDismiss: (_: ScreenResult<Void>) -> Void = { _ in
            self.baseViewController.dismiss(animated: true, completion: nil)
        }
        baseViewController.presentUsingBootomSheet(
            title: title,
            bottomSheetContentView: contentView,
            onSheetDismiss: onDismiss
        )
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
                onDismiss: { [weak self] result in
                    self?.callback?(result)
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
        trip: TripInfo,
        quote: Quote,
        journeyDetails: JourneyDetails,
        loyaltyInfo: KarhooBasicLoyaltyInfo?,
        onDismiss: @escaping (ScreenResult<KarhooCheckoutResult>) -> Void
    ) {
        guard let viewController = viewController else {
            assertionFailure()
            return
        }
        let dismissCompletion: (ScreenResult<KarhooCheckoutResult>) -> Void = { result in
            viewController.dismiss(animated: true) {
                onDismiss(result)
            }
        }
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: UITexts.Booking.prebookConfirmed,
            onDismissCallback: {
                dismissCompletion(.completed(result: .init(tripInfo: trip)))
            }
        )

        let confirmationViewModel = KarhooBookingConfirmationViewModel(
            journeyDetails: journeyDetails,
            quote: quote,
            trip: trip,
            loyaltyInfo: loyaltyInfo ?? .loyaltyDisabled(),
            onDismissCallback: { result in
                dismissCompletion(.completed(result: result))
            }
        )

        let screenBuilder = UISDKScreenRouting.default.bottomSheetScreen()
        let sheet = screenBuilder.buildBottomSheetScreenBuilderForUIKit(viewModel: bottomSheetViewModel) {
            KarhooBookingConfirmationView(viewModel: confirmationViewModel)
        }
        viewController.present(sheet, animated: true)
    }
}
