//
//  DetailsCellViewController.swift
//  
//
//  Created by Bartlomiej Sopala on 08/11/2022.
//

import Foundation
import SwiftUI
import KarhooSDK

class PassengerCellViewController: DetailsCellViewController, AddPassengerDetailsPresenter {
    
    private let analyticsService: AnalyticsService
    var details: PassengerDetails?
    weak var delegate: AddPassengerDetailsViewDelegate?
    
    init(
        analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
        passengerDetails: PassengerDetails?,
        delegate: AddPassengerDetailsViewDelegate
    ) {
        self.analyticsService = analyticsService
        self.details = passengerDetails
        super.init(
            rootView: DetailsCellView(viewModel: Self.getModel(from: passengerDetails)),
            onTap: delegate.willUpdatePassengerDetails
        )
        rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(details: PassengerDetails?) {
        self.details = details
        let model = Self.getModel(from: details)
        delegate?.didUpdatePassengerDetails(details: details)
        rootView.viewModel.update(title: model.title, subtitle: model.subtitle)
    }
    
    private static func getModel(from details: PassengerDetails?) -> DetailsCellViewModel {
        guard let details = details else {
            return DetailsCellViewModel(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add,
                iconName: "kh_uisdk_passenger",
                onTap: { return } // temporary sollution. Whole class will be removed when new Checkout will be finished
            )
        }
        let passengerName = "\(details.firstName) \(details.lastName)"
        return DetailsCellViewModel(
            title: passengerName,
            subtitle: "\(details.phoneNumber)",
            iconName: "kh_uisdk_passenger",
            onTap: { return }  // temporary sollution. Whole class will be removed when new Checkout will be finished
        )
    }
}
