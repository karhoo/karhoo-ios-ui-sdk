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
    
    init(
        analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
        passengerDetails: PassengerDetails?,
        actions: AddPassengerDetailsViewDelegate
    ) {
        self.analyticsService = analyticsService
        super.init(
            rootView: DetailsCellView(model: Self.getModel(from: passengerDetails)),
            onClickAction: actions.willUpdatePassengerDetails
        )
        rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(details: PassengerDetails?) {
        let model = Self.getModel(from: details)
        rootView.model.update(title: model.title, subtitle: model.subtitle)
    }
    
    private static func getModel(from details: PassengerDetails?) -> DetailsCellModel {
        guard let details = details else {
            return DetailsCellModel(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add,
                iconName: "kh_uisdk_passenger"
            )
        }
        let passengerName = "\(details.firstName) \(details.lastName)"
        return DetailsCellModel(
            title: passengerName,
            subtitle: "\(details.phoneNumber)",
            iconName: "kh_uisdk_passenger"
        )
    }
}
