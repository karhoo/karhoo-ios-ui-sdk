//
//  FlightNumberCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine

class FlightNumberCellViewModel: DetailsCellViewModel {

    private(set)var flightNumberSubject = CurrentValueSubject<String?, Never>(nil)

    init(onTap: @escaping () -> Void = {}) {

        super.init(
            title: UITexts.Booking.flightTitle,
            subtitle: UITexts.Booking.flightSubtitle,
            iconName: "kh_uisdk_flight_number",
            accessibilityTitle: UITexts.Accessibility.flightNumberTitle,
            accessibilityIconName: UITexts.Accessibility.flightNumberIcon,
            onTap: onTap
        )
    }
    
    func getFlightNumber() -> String {
        flightNumberSubject.value ?? ""
    }
    
    private func getSubtitle() -> String {
        guard let flightNumber = flightNumberSubject.value, flightNumber.isNotEmpty else {
            return UITexts.Booking.flightSubtitle
        }
        return flightNumber
    }
    
    func setFlightNumber(_ flightNumber: String) {
        self.flightNumberSubject.send(flightNumber)
        subtitle = getSubtitle()
    }
}
