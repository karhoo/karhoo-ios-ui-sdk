//
//  MenuContentViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class MenuContentViewController: UIViewController, MenuContentView {

    private let presenter: MenuContentScreenPresenter
    @IBOutlet private weak var logo: UIImageView?

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
    }

    func getFlowItem() -> Screen {
        return self
    }

    @IBAction private func profilePressed() {
        presenter.profilePressed()
    }

    @IBAction private func bookingHistoryPressed() {
        presenter.bookingsPressed()
    }

    @IBAction private func feedbackPressed() {
        presenter.feedbackPressed()
    }

    @IBAction private func aboutPressed() {
        presenter.aboutPressed()
    }
}
