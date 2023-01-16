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

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) {
        self.navigationController = navigationController
        self.presenter = KarhooNewCheckoutViewModel(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            router: self,
            callback: callback
        )
        self.viewController = KarhooNewCheckoutViewController().then {
            $0.setupBinding(presenter!)
        }
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
    
    func routeToFlightNumber(title: String, flightNumber: String) {
        guard let presenter = presenter else { return }
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: title) { [weak self] in
                self?.baseViewController.dismiss(animated: true, completion: nil)
            }
        
        let contentViewModel = KarhooBottomSheetContentWithTextFieldViewModel(
            initialValueForTextField: presenter.flightNumberCellViewModel.getFlightNumber(),
            viewSubtitle: UITexts.Booking.flightSubtitle,
            textFieldHint: UITexts.Booking.flightExcample
        ){
            [weak self] newFlightNumber in
            self?.presenter?.flightNumberCellViewModel.setFlightNumber(flightNumber: newFlightNumber)
            self?.baseViewController.dismiss(animated: true, completion: nil)
            
        }
        let bottomSheet = KarhooBottomSheet(viewModel: bottomSheetViewModel) {
            KarhooBottomSheetContentWithTextFieldView(viewModel: contentViewModel)
        }
        
        let viewController = UIHostingController(rootView: bottomSheet)
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overFullScreen
        baseViewController.present(viewController, animated: true, completion: nil)
    }
    
    func routeToTrainNumber(title: String, trainNumber: String) {
        guard let presenter = presenter else { return }
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: title) { [weak self] in
                self?.baseViewController.dismiss(animated: true, completion: nil)
            }
        
        let contentViewModel = KarhooBottomSheetContentWithTextFieldViewModel(
            initialValueForTextField: presenter.trainNumberCellViewModel.getTrainNumber(),
            viewSubtitle: UITexts.Booking.trainSubtitle,
            textFieldHint: UITexts.Booking.trainExcample
        ){
            [weak self] newTrainNumber in
            self?.presenter?.trainNumberCellViewModel.setTrainNumber(trainNumber: newTrainNumber)
            self?.baseViewController.dismiss(animated: true, completion: nil)
            
        }
        let bottomSheet = KarhooBottomSheet(viewModel: bottomSheetViewModel) {
            KarhooBottomSheetContentWithTextFieldView(viewModel: contentViewModel)
        }
        
        let viewController = UIHostingController(rootView: bottomSheet)
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overFullScreen
        baseViewController.present(viewController, animated: true, completion: nil)
    }
}
