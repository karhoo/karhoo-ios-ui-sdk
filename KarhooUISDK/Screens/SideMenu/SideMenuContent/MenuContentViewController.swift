//
//  MenuContentViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class MenuContentViewController: UIViewController, MenuContentView {

    private let presenter: MenuContentScreenPresenter
    @IBOutlet private weak var logo: UIImageView?
    @IBOutlet private weak var profileView: UIView?
    @IBOutlet private weak var ridesView: UIView?
    
    @IBOutlet private weak var ridesImage: UIImageView?
    @IBOutlet private weak var profileImage: UIImageView?
    @IBOutlet private weak var aboutImage: UIImageView?
    @IBOutlet private weak var helpImage: UIImageView?

    init(presenter: MenuContentScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: "MenuContentViewController", bundle: Bundle.current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.logo?.image = KarhooUISDKConfigurationProvider.configuration.logo()
        presenter.checkGuestAuthentication()
    }

    func getFlowItem() -> Screen {
        return self
    }
    
    func showGuestMenu() {
        self.ridesView?.removeFromSuperview()
        self.profileView?.removeFromSuperview()
    }

    @IBAction private func profilePressed() {
        presenter.profilePressed()
    }

    @IBAction private func bookingHistoryPressed() {
        presenter.bookingsPressed()
    }

    @IBAction private func aboutPressed() {
        presenter.aboutPressed()
    }

    @IBAction private func helpPressed() {
        presenter.helpPressed()
    }
    
    private func configureColours() {
        ridesImage?.tintColor = KarhooUI.colors.infoColor
        profileImage?.tintColor = KarhooUI.colors.infoColor
        aboutImage?.tintColor = KarhooUI.colors.infoColor
        helpImage?.tintColor = KarhooUI.colors.infoColor
    }
}
