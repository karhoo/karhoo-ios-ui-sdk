//
//  QuoteCellViewModelSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class QuoteCellViewModelSpec: XCTestCase {

    private var testObject: QuoteViewModel!
    
    /**
     * Given: A quote
     * Then: The view model should return the correct value for each of its properties
     */
    func testInit() {
        let highMin: Int = 20
        let lowMin: Int = 5
        let expectedEta = QtaStringFormatter().qtaString(min: lowMin, max: highMin)
        
        let quote = TestUtil.getRandomQuote(fleetName: "TestFleet",
                                            qtaHighMinutes: highMin,
                                            qtaLowMinutes: lowMin,
                                            vehicleAttributes: VehicleAttributes(luggageCapacity: 2,
                                                                                 passengerCapacity: 1))
        
        testObject = QuoteViewModel(quote: quote)
        
        XCTAssertEqual(testObject.fleetName, "TestFleet")
        XCTAssertEqual(testObject.eta, expectedEta)
        XCTAssertEqual("1", testObject.passengerCapacity)
        XCTAssertEqual("2", testObject.baggageCapacity)
    }
    
    /**
     * Given: A quote with pickUpType = .default
     * And: a BookingStatus with origin = .airport
     * Then: The view model should return the correct value for each of its properties
     * And: showPickUpLabel should be false
     */
    func testDefaultAirportPickup() {
        let quote = TestUtil.getRandomQuote()
        let bookingStatus = MockBookingStatus()
        let locationInfo = LocationInfo(details: PoiDetails(type: .airport))
        bookingStatus.bookingDetailsToReturn = BookingDetails(originLocationDetails: locationInfo)
        
        testObject = QuoteViewModel(quote: quote, bookingStatus: bookingStatus)
        
        XCTAssertFalse(testObject.showPickUpLabel)
    }
    
    /**
     * Given: A quote with pickUpType != .default
     * And: a BookingStatus with origin = .airport
     * Then: The view model should return the correct value for each of its properties
     * And: showPickUpLabel should be true
     */
     func testAirportPickupType() {
        let quote = TestUtil.getRandomQuote(pickUpType: .meetAndGreet)
        let bookingStatus = MockBookingStatus()
        let locationInfo = LocationInfo(details: PoiDetails(type: .airport))
        bookingStatus.bookingDetailsToReturn = BookingDetails(originLocationDetails: locationInfo)
        
        testObject = QuoteViewModel(quote: quote, bookingStatus: bookingStatus)
        
        XCTAssertTrue(testObject.showPickUpLabel)
    }
    
    /**
     * Given: A quote with pickUpType = .default
     * And: a BookingStatus with origin != .airport
     * Then: The view model should return the correct value for each of its properties
     * And: showPickUpLabel should be false
     */
    func testDefaultPickup() {
        let quote = TestUtil.getRandomQuote()
        let bookingStatus = MockBookingStatus()
        let locationInfo = LocationInfo(details: PoiDetails(type: .trainStation))
        bookingStatus.bookingDetailsToReturn = BookingDetails(originLocationDetails: locationInfo)
        
        testObject = QuoteViewModel(quote: quote, bookingStatus: bookingStatus)
        
        XCTAssertFalse(testObject.showPickUpLabel)
    }
    
    /**
     * Given: A quote with pickUpType != .default
     * And: a BookingStatus with origin != .airport
     * Then: The view model should return the correct value for each of its properties
     * And: showPickUpLabel should be false
     */
    func testNonPoiPickup() {
        let quote = TestUtil.getRandomQuote(pickUpType: .meetAndGreet)
        let bookingStatus = MockBookingStatus()
        let locationInfo = LocationInfo(details: PoiDetails(type: .trainStation))
        bookingStatus.bookingDetailsToReturn = BookingDetails(originLocationDetails: locationInfo)
        
        testObject = QuoteViewModel(quote: quote, bookingStatus: bookingStatus)
        
        XCTAssertFalse(testObject.showPickUpLabel)
    }

    /**
     * When: Quote comes from the market place
     * Then: Fare should be a range
     */
    func testMarketQuoteShowsRange() {
        let quote = TestUtil.getRandomQuote(highPrice: 50, lowPrice: 10, source: .market)

        testObject = QuoteViewModel(quote: quote, bookingStatus: MockBookingStatus())

        XCTAssertEqual(testObject.fare, "£10.00 - £50.00")
    }

    /**
     * When: Quote comes from the fleet
     * Then: Fare should be a single price (high price)
     */
    func testFleetQuoteSingleFare() {
        let quote = TestUtil.getRandomQuote(highPrice: 50, lowPrice: 10, source: .fleet)

        testObject = QuoteViewModel(quote: quote, bookingStatus: MockBookingStatus())

        XCTAssertEqual(testObject.fare, "£50.00")
    }
}
