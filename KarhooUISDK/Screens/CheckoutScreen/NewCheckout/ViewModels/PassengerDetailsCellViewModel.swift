//
//  PassengerDetailsCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class PassengerDetailsCellViewModel: DetailsCellViewModel {
    init(onTap: @escaping () -> Void) {
        super.init(
            title: UITexts.PassengerDetails.title,
            subtitle: UITexts.PassengerDetails.add,
            iconName: "kh_uisdk_passenger",
            onTap: onTap
        )
    }
}
