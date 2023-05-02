//
//  PassengerDetailsCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class PassengerDetailsCellViewModel: DetailsCellViewModel {
    init(
        passengerDetails: PassengerDetails?,
        onTap: @escaping () -> Void = {}
    ) {
        if let passengerDetails = passengerDetails {
            super.init()
            self.update(using: passengerDetails)
            self.onTap = onTap
        } else {
            super.init(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add,
                iconName: "kh_uisdk_passenger",
                accessibilityTitle: UITexts.Accessibility.passengerTitle,
                accessibilityIconName: UITexts.Accessibility.passengerIcon,
                onTap: onTap
            )
        }
    }

    func update(using details: PassengerDetails?) {
        if let details {
            let title = details.firstName + " " + details.lastName
            update(
                title: title,
                subtitle: UITexts.Generic.edit,
                accessibilityTitle: "\(UITexts.Accessibility.passengerTitle), \(title)"
            )
        } else {
            update(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add,
                accessibilityTitle: UITexts.Accessibility.passengerTitle
            )
        }
    }
}
