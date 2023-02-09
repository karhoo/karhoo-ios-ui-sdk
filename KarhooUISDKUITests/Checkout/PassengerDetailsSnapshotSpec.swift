//
//  PassengerDetailsSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Bartlomiej Sopala on 08/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import KarhooSDK
import KarhooUISDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class PassengerDetailsSnapshotSpec: QuickSpec {
    
    override func spec() {
        
        var sut: PassengerDetailsView!
        
        context("when Passenger details is opened without details") {
            beforeEach {
                sut = KarhooComponents().passengerDetails(details: nil, delegate: nil)
            }
            it("should present empty form") {
                testSnapshot(sut)
            }
        }
        
        context("when Passenger details is opened with only first name") {
            beforeEach {
                let details = PassengerDetails(firstName: "First")
                sut = KarhooComponents().passengerDetails(details: details, delegate: nil)
            }
            it("should present form with first name filled") {
                testSnapshot(sut)
            }
        }
        
        context("when Passenger details is opened with all details") {
            beforeEach {
                let details = PassengerDetails(
                    firstName: "First",
                    lastName: "Last",
                    email: "email@email.com",
                    phoneNumber: "1234567896",
                    locale: "GB"
                    
                )
                sut = KarhooComponents().passengerDetails(details: details, delegate: nil)
            }
            it("should have all details and buton enabled") {
                testSnapshot(sut)
            }
        }
    }
}
