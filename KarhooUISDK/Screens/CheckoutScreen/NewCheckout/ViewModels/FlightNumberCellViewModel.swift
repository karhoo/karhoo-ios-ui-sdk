//
//  FlightNumberCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class FlightNumberCellViewModel: DetailsCellViewModel {
    init(){
        super.init(
            title: UITexts.Booking.flightTitle,
            subtitle: UITexts.Booking.flightSubtitle,
            iconName: "kh_uisdk_flight_number"
        )
    }
}
