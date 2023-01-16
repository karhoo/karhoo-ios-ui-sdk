//
//  TrainNumberCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class TrainNumberCellViewModel: DetailsCellViewModel {
    
    private var trainNumber: String = ""
    init(onTap: @escaping () -> Void){
        super.init(
            title: UITexts.Booking.trainTitle,
            subtitle: UITexts.Booking.trainSubtitle,
            iconName: "kh_uisdk_train_number",
            onTap: onTap
        )
    }
    
    func getTrainNumber() -> String {
        return trainNumber
    }
    
    private func getSubtitle() -> String {
        trainNumber.isNotEmpty ? trainNumber : UITexts.Booking.trainSubtitle
    }
    
    func setTrainNumber(trainNumber: String) {
        self.trainNumber = trainNumber
        subtitle = getSubtitle()
    }
}
