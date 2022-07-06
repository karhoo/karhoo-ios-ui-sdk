//
//  QuoteListFilterSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 15/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK
@testable import KarhooUISDK

class QuoteListFIlterSpec: KarhooTestCase {
    
    func testLuggageCapasityFilterSuccess() {
        let filter = QuoteListFilters.LuggageCapacityModel(value: 3)
        let quote = Quote(vehicle: QuoteVehicle(luggageCapacity: 3))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testLuggageCapasityFilterFailure() {
        let filter = QuoteListFilters.LuggageCapacityModel(value: 3)
        let quote = Quote(vehicle: QuoteVehicle(luggageCapacity: 2))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }

    func testPassengersCapasityFilterSuccess() {
        let filter = QuoteListFilters.PassengerCapacityModel(value: 3)
        let quote = Quote(vehicle: QuoteVehicle(passengerCapacity: 3))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testPassengersCapasityFilterFailure() {
        let filter = QuoteListFilters.PassengerCapacityModel(value: 3)
        let quote = Quote(vehicle: QuoteVehicle(passengerCapacity: 2))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }

    func testVehicleTypeFilterSuccess() {
        let filter = QuoteListFilters.VehicleType.moto
        let quote = Quote(vehicle: QuoteVehicle(type: "moto"))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testVehicleTypeFilterFailure() {
        let filter = QuoteListFilters.VehicleType.moto
        let quote = Quote(vehicle: QuoteVehicle(type: "bike"))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }

    func testVehicleClassFilterSuccess() {
        let filter = QuoteListFilters.VehicleClass.luxury
        let quote = Quote(vehicle: QuoteVehicle(vehicleClass: "luxury"))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testVehicleClassFilterFailure() {
        let filter = QuoteListFilters.VehicleClass.executive
        let quote = Quote(vehicle: QuoteVehicle(vehicleClass: "luxury"))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }
    
    func testVehicleExtrasFilterSuccess() {
        let filter = QuoteListFilters.VehicleExtras.childSeat
        let quote = Quote(vehicle: QuoteVehicle(tags: ["child-seat", "wheelchair"]))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testVehicleExtrasFilterFailure() {
        let filter = QuoteListFilters.VehicleExtras.wheelchair
        let quote = Quote(vehicle: QuoteVehicle(tags: ["child-seat"]))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }

    func testVehicleEcoFilterSuccess() {
        let filter = QuoteListFilters.EcoFriendly.electric
        let quote = Quote(vehicle: QuoteVehicle(tags: ["electric", "wheelchair"]))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testVehicleEcoFilterFailure() {
        let filter = QuoteListFilters.EcoFriendly.electric
        let quote = Quote(vehicle: QuoteVehicle(tags: []))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }

    func testQuoteTypeFilterSuccess() {
        let filter = QuoteListFilters.QuoteType.metered
        let quote = Quote(quoteType: .metered)
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testQuoteTypeFilterFailure() {
        let filter = QuoteListFilters.QuoteType.metered
        let quote = Quote(quoteType: .fixed)
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }
    
    func testServiceAgreementsFilterSuccess() {
        let filter = QuoteListFilters.ServiceAgreements.freeWatingTime
        let quote = Quote(serviceLevelAgreements: .init(
            serviceCancellation: ServiceCancellation(type: .beforeDriverEnRoute, minutes: 10),
            serviceWaiting: ServiceWaiting(minutes: 10)
        ))
        
        XCTAssert(filter.conditionMet(for: quote))
    }

    func testServiceAgreementsFilterFailure() {
        let filter = QuoteListFilters.ServiceAgreements.freeWatingTime
        let quote = Quote(serviceLevelAgreements: .init(
            serviceCancellation: ServiceCancellation(type: .beforeDriverEnRoute, minutes: 10),
            serviceWaiting: ServiceWaiting(minutes: 0)
        ))
        
        XCTAssertFalse(filter.conditionMet(for: quote))
    }
}
