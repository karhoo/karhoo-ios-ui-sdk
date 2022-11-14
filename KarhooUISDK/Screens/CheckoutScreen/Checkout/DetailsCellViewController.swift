//
//  DetailsCellViewController.swift
//  
//
//  Created by Bartlomiej Sopala on 08/11/2022.
//

import Foundation
import SwiftUI
import KarhooSDK

class DetailsCellViewController: UIHostingController<DetailsCellView>, AddPassengerDetailsPresenter {
    
    private let analyticsService: AnalyticsService
    let actions: AddPassengerDetailsViewDelegate
    
    
    init(analyticsService: AnalyticsService = Karhoo.getAnalyticsService(), passengerDetails: PassengerDetails?, actions: AddPassengerDetailsViewDelegate){
        self.analyticsService = analyticsService
        self.actions = actions
        let model = Self.getModel(from: passengerDetails)
        super.init(rootView: DetailsCellView(model: model))
        self.rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    func set(details: PassengerDetails?) {
        let model = Self.getModel(from: details)
        self.rootView.model.update(title: model.title, subtitle:model.subtitle)
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
        return DetailsCellModel (
            title: passengerName,
            subtitle:  "\(details.phoneNumber)",
            iconName: "kh_uisdk_passenger"
        )
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
