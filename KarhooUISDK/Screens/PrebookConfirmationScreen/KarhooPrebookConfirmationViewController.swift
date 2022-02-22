//
//  KarhooPrebookConfirmationViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooPrebookConfirmationViewController: UIViewController, PrebookConfirmationView {

    @IBOutlet private weak var formButton: FormButton?
    @IBOutlet private weak var blurView: UIVisualEffectView?
    @IBOutlet private weak var pinView: PinView?

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var originLocationLabel: UILabel?
    @IBOutlet private weak var destinationLocationLabel: UILabel?
    @IBOutlet private weak var timeLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var estimatedPriceLabel: UILabel?
    @IBOutlet private weak var estimatedTitleLabel: UILabel?
    @IBOutlet private weak var pickUpTypeLabel: RoundedLabel?
    
    private let presenter: PrebookConfirmationPresenter

    init(presenter: PrebookConfirmationPresenter) {
        self.presenter = presenter
        super.init(nibName: "KarhooPrebookConfirmationViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load(view: self)
        formButton?.delegate = self
        formButton?.setEnabledMode()
        forceLightMode()
        
    }

    @IBAction private func didTapBackground() {
        presenter.didTapScreen()
    }

    @IBAction private func didTapClose() {
        presenter.didTapClose()
    }

    func updateUI(withViewModel viewModel: PrebookConfirmationViewModel) {
        titleLabel?.text = viewModel.title
        originLocationLabel?.text = viewModel.originLocation
        destinationLocationLabel?.text = viewModel.destinationLocation
        timeLabel?.text = viewModel.time
        dateLabel?.text = viewModel.date
        formButton?.set(title: viewModel.buttonTitle)
        estimatedTitleLabel?.text = viewModel.priceTitle
        estimatedPriceLabel?.text = viewModel.price
        pickUpTypeLabel?.text = viewModel.pickUpType
        pickUpTypeLabel?.isHidden = !viewModel.showPickUpType
    }

    final class KarhooPrebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder {

        public func buildPrebookConfirmationScreen(quote: Quote,
                                                   bookingDetails: JourneyDetails,
                                                   confirmationCallback:
            @escaping ScreenResultCallback<PrebookConfirmationAction>) -> Screen {
            let presenter = KarhooPrebookConfirmationPresenter(quote: quote,
                                                               bookingDetails: bookingDetails,
                                                               callback: confirmationCallback)

            return KarhooPrebookConfirmationViewController(presenter: presenter)
        }
    }

}

extension KarhooPrebookConfirmationViewController: FormButtonDelegate {

    func formButtonPressed() {
        presenter.didTapPopupButton()
    }
}
