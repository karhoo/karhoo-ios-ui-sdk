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
    private var details: PassengerDetails?
    
    
    init(analyticsService: AnalyticsService = Karhoo.getAnalyticsService(), passengerDetails: PassengerDetails?){
        self.analyticsService = analyticsService
        let model = Self.getModel(from: passengerDetails)
        super.init(rootView: DetailsCellView(title: model.title, subtitle: model.subtitle, iconName: model.iconName))
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    func set(details: PassengerDetails?) {
        self.details = details
        let model = Self.getModel(from: details)
        (rootView as DetailsCellView).title = model.title
        (rootView as DetailsCellView).subtitle = model.subtitle
        (rootView as DetailsCellView).iconName = model.iconName
    }
    
    static func getModel(from details: PassengerDetails?) -> DetailsCellModel {
        let modelForIncompleteUser = DetailsCellModel(title: UITexts.PassengerDetails.title, subtitle: UITexts.PassengerDetails.add, iconName: "kh_uisdk_passenger")
        return DetailsCellModel(
            title: modelForIncompleteUser.title,
            subtitle: modelForIncompleteUser.subtitle,
            iconName: modelForIncompleteUser.iconName
        )
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
