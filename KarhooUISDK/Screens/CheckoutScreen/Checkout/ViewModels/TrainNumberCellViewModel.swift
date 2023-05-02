//
//  TrainNumberCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine

class TrainNumberCellViewModel: DetailsCellViewModel {

    private(set)var trainNumberSubject = CurrentValueSubject<String?, Never>(nil)

    init(onTap: @escaping () -> Void = {}) {
        super.init(
            title: UITexts.Booking.trainTitle,
            subtitle: UITexts.Booking.trainSubtitle,
            iconName: "kh_uisdk_train_number",
            accessibilityTitle: UITexts.Accessibility.trainNumberTitle,
            accessibilityIconName: UITexts.Accessibility.trainNumberIcon,
            onTap: onTap
        )
    }
    
    func getTrainNumber() -> String {
        trainNumberSubject.value ?? ""
    }
    
    private func getSubtitle() -> String {
        guard let trainNumber = trainNumberSubject.value, trainNumber.isNotEmpty else {
            return UITexts.Booking.trainSubtitle
        }
        return trainNumber
    }
    
    func setTrainNumber(_ trainNumber: String) {
        self.trainNumberSubject.send(trainNumber)
        subtitle = getSubtitle()
    }
}
