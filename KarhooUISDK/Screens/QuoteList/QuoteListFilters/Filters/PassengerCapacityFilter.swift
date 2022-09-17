//
//  PassengerCapacityModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

extension QuoteListFilters {
    struct PassengerCapacityModel: QuoteListNumericFilter {
        var value: Int
        var minValue: Int { 1 }
        var maxValue: Int { 7 }
        var defaultValue: Int { QuoteListFilters.defaultPassengersCount }
        var filterCategory: Category { .passengers }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.passengerCapacity >= value
        }

        var localizedString: String { filterCategory.localized }

        var icon: UIImage? {
            .uisdkImage("kh_filter_passengers")
        }
    }
}
