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
    private let bookingMetadata: [String: Any]?
    private let router: RidePlanningRouter
    private let journeyDetailsManager: JourneyDetailsManager
    
    init(
        bookingMetadata: [String: Any]?,
        router: RidePlanningRouter,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager()
    ) {
        self.bookingMetadata = bookingMetadata
        self.router = router
        self.journeyDetailsManager = journeyDetailsManager
    }
    
    func exitPressed() {
        journeyDetailsManager.reset()
        router.exitPressed()
    }
}
