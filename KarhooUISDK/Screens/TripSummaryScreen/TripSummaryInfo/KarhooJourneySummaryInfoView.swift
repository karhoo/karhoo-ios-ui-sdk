//
//  KarhooJourneySummaryInfoView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooJourneySummaryInfoView: NibLoadableView, JourneySummaryInfoView {

    @IBOutlet private weak var clientLogo: UIImageView?
    @IBOutlet private weak var originLabel: UILabel?
    @IBOutlet private weak var destinationLabel: UILabel?
    @IBOutlet private weak var tripDateLabel: UILabel?
    @IBOutlet private weak var supplierNameLabel: UILabel?
    @IBOutlet private weak var vehicleDescriptionLabel: UILabel?
    @IBOutlet private weak var tripPriceLabel: UILabel?
    @IBOutlet private weak var priceDescriptionLabel: UILabel?
    @IBOutlet private weak var tripSummaryHeader: JourneySummaryHeaderView?
    @IBOutlet private weak var paymentSummaryHeader: JourneySummaryHeaderView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(viewModel: JourneySummaryInfoViewModel) {
        originLabel?.text = viewModel.pickup
        destinationLabel?.text = viewModel.destination
        supplierNameLabel?.text = viewModel.supplierName
        vehicleDescriptionLabel?.text = viewModel.vehicleInformation
        tripPriceLabel?.text = viewModel.price
        priceDescriptionLabel?.text = viewModel.priceDescription
        tripDateLabel?.text = viewModel.formattedDate
        tripSummaryHeader?.set(headerText: UITexts.TripSummary.tripSummary.uppercased())
        paymentSummaryHeader?.set(headerText: UITexts.TripSummary.paymentSummary.uppercased())
        clientLogo?.image = viewModel.clientLogo
    }
}
