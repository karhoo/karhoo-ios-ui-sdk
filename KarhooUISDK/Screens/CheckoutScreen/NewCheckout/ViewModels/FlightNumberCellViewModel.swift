//
//  FlightNumberCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class FlightNumberCellViewModel: DetailsCellViewModel {
    
    private var flightNumber: String = ""

    init(onTap: @escaping () -> Void = {}) {

        super.init(
            title: UITexts.Booking.flightTitle,
            subtitle: UITexts.Booking.flightSubtitle,
            iconName: "kh_uisdk_flight_number",
            onTap: onTap
        )
    }
    
    func getFlightNumber() -> String {
        flightNumber
    }
    
    private func getSubtitle() -> String {
        flightNumber.isNotEmpty ? flightNumber : UITexts.Booking.flightSubtitle
    }
    
    func setFlightNumber(_ flightNumber: String) {
        self.flightNumber = flightNumber
        subtitle = getSubtitle()
    }
}
