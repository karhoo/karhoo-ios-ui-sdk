//
//  KarhooRidePlanningViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import KarhooSDK

final class KarhooRidePlanningViewModel: ObservableObject {
    private let journeyInfo: JourneyInfo?
    private let passengerDetails: PassengerDetails?
    private let bookingMetadata: [String: Any]?
    private let router: RidePlanningRouter
    
    init(
        journeyInfo: JourneyInfo?,
        passengerDetails: PassengerDetails?,
        bookingMetadata: [String: Any]?,
        router: RidePlanningRouter
    ) {
        self.journeyInfo = journeyInfo
        self.passengerDetails = passengerDetails
        self.bookingMetadata = bookingMetadata
        self.router = router
    }
}
