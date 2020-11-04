//
//  TripSummaryViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

class JourneySummaryViewController: UIViewController, JourneySummaryView {

    @IBOutlet private weak var tripSummaryInfoView: KarhooJourneySummaryInfoView?

    private let presenter: JourneySummaryPresenter

    init(presenter: JourneySummaryPresenter) {
        self.presenter = presenter
        super.init(nibName: "JourneySummaryViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded(view: self)
    }

    func set(trip: TripInfo) {
        tripSummaryInfoView?.set(viewModel: JourneySummaryInfoViewModel(trip: trip))
    }

    @IBAction private func didTapExitButton() {
        presenter.exitPressed()
    }

    @IBAction private func didTapRebookRide() {
        presenter.bookReturnRidePressed()
    }

    final class KarhooJourneySummaryScreenBuilder: JourneySummaryScreenBuilder {
        func buildJourneySummaryScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<JourneySummaryResult>) -> Screen {
            let journeySummaryPresenter = KarhooJourneySummaryPresenter(trip: trip,
                                                                        callback: callback)
            let journeySummaryViewController = JourneySummaryViewController(presenter: journeySummaryPresenter)

            return journeySummaryViewController
        }
    }
}
