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
                onTap: onTap
            )
        }
    }

    func update(using details: PassengerDetails?) {
        if let details {
            update(
                title: details.firstName + " " + details.lastName,
                subtitle: UITexts.Generic.edit
            )
        } else {
            update(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add
            )
        }
    }

    func update(using details: PassengerDetails?) {
        if let details {
            update(
                title: details.firstName + " " + details.lastName,
                subtitle: UITexts.Generic.edit
            )
        } else {
            update(
                title: UITexts.PassengerDetails.title,
                subtitle: UITexts.PassengerDetails.add
            )
        }
    }
}
