//
//  TripSummaryViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

class TripSummaryViewController: UIViewController, TripSummaryView {

    @IBOutlet private weak var tripSummaryInfoView: KarhooTripSummaryInfoView?

    private let presenter: TripSummaryPresenter

    init(presenter: TripSummaryPresenter) {
        self.presenter = presenter
        super.init(nibName: "TripSummaryViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded(view: self)
    }

    func set(trip: TripInfo) {
        tripSummaryInfoView?.set(viewModel: TripSummaryInfoViewModel(trip: trip))
    }

    @IBAction private func didTapExitButton() {
        presenter.exitPressed()
    }

    @IBAction private func didTapRebookRide() {
        presenter.bookReturnRidePressed()
    }

    final class KarhooTripSummaryScreenBuilder: TripSummaryScreenBuilder {
        func buildTripSummaryScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen {
            let tripSummaryPresenter = KarhooTripSummaryPresenter(trip: trip,
                                                                        callback: callback)
            let tripSummaryViewController = TripSummaryViewController(presenter: tripSummaryPresenter)

            return tripSummaryViewController
        }
    }
}
