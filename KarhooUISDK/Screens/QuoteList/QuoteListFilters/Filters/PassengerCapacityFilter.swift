//
//  PassengerCapacityModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    struct PassengerCapacityModel: QuoteListNumericFilter {
        var value: Int
        var minValue: Int { 1 }
        var maxValue: Int { 7 }
        var filterCategory: Category { .passengers }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.passengerCapacity >= value
        }

        var icon: UIImage? {
            .uisdkImage("filter_passengers")
        }
    }
}
