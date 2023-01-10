//
//  TrainNumberCellViewController.swift
//
//
//  Created by Bartlomiej Sopala on 09/01/2023.
//

import Foundation
import SwiftUI
import KarhooSDK

class TrainNumberCellViewController: DetailsCellViewController, AddTrainNumberPresenter {
    
    private let analyticsService: AnalyticsService
    var trainNumber: String?
    weak var delegate: AddTrainNumberViewDelegate?
    
    init(
        analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
        trainNumber: String?,
        delegate: AddTrainNumberViewDelegate
    ) {
        self.analyticsService = analyticsService
        self.trainNumber = trainNumber
        self.delegate = delegate
        super.init(
            rootView: DetailsCellView(model: Self.getModel(trainNumber)),
            onTap: delegate.willUpdateTrainNumber
        )
        rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(trainNumber: String) {
        self.trainNumber = trainNumber
        let model = Self.getModel(trainNumber)
        delegate?.didUpdateTrainNumber(trainNumber)
        rootView.model.update(title: model.title, subtitle: model.subtitle)
    }
    
    private static func getModel(_ trainNumber: String?) -> DetailsCellViewModel {
        let subtitle = trainNumber ?? "e.g AF009"
        return DetailsCellViewModel(
            title: UITexts.PassengerDetails.title,
            subtitle: UITexts.PassengerDetails.add,
            iconName: "kh_uisdk_passenger"
        )
    }
}

