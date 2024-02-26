//
//  KarhooTripSummaryInfoView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import UIKit

final class KarhooTripSummaryInfoView: NibLoadableView, TripSummaryInfoView {

    @IBOutlet private weak var clientLogo: UIImageView?
    @IBOutlet private weak var originLabel: UILabel?
    @IBOutlet private weak var destinationLabel: UILabel?
    @IBOutlet private weak var tripDateLabel: UILabel?
    @IBOutlet private weak var supplierNameLabel: UILabel?
    @IBOutlet private weak var vehicleDescriptionLabel: UILabel?
    @IBOutlet private weak var tripPriceLabel: UILabel?
    @IBOutlet private weak var priceDescriptionLabel: UILabel?
    @IBOutlet private weak var tripSummaryHeader: TripSummaryHeaderView?
    @IBOutlet private weak var paymentSummaryHeader: TripSummaryHeaderView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(viewModel: TripSummaryInfoViewModel) {
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
