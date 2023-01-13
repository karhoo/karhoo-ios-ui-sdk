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
}
