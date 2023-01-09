//
//  FlightNumberCellViewController.swift
//
//
//  Created by Bartlomiej Sopala on 05/01/2023.
//

import Foundation
import SwiftUI
import KarhooSDK

class FlightNumberCellViewController: DetailsCellViewController, AddFlightNumberPresenter {
    
    private let analyticsService: AnalyticsService
    var flightNumber: String?
    weak var delegate: AddFlightNumberViewDelegate?
    
    init(
        analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
        flightNumber: String?,
        delegate: AddPassengerDetailsViewDelegate
    ) {
        self.analyticsService = analyticsService
        self.flightNumber = flightNumber
        super.init(
            rootView: DetailsCellView(model: Self.getModel(flightNumber)),
            onTap: delegate.willUpdatePassengerDetails
        )
        rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(flightNumber: String) {
        self.flightNumber = flightNumber
        let model = Self.getModel(flightNumber)
        delegate?.didUpdateFlightNumber(flightNumber)
        rootView.model.update(title: model.title, subtitle: model.subtitle)
    }
    
    private static func getModel(_ flightNumber: String?) -> DetailsCellViewModel {
        let subtitle = flightNumber ?? "e.g AF009"
        return DetailsCellViewModel(
            title: UITexts.PassengerDetails.title,
            subtitle: UITexts.PassengerDetails.add,
            iconName: "kh_uisdk_passenger"
        )
    }
}

