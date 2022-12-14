//
//  TestUtil.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import CoreLocation
@testable import KarhooSDK
@testable import KarhooUISDK

public class TestUtil: PrimitiveUtil {
    public override init() { }

    public class func getRandomError(code: String = TestUtil.getRandomString(),
                              message: String = TestUtil.getRandomString(),
                              userMessage: String = TestUtil.getRandomString()) -> MockError {
        let error = MockError(code: code,
                              message: message,
                              userMessage: userMessage)
        return error
    }

    public class func getRandomTrip(tripId: String = TestUtil.getRandomString(),
                             followCode: String = TestUtil.getRandomString(),
                             dateSet: Bool = false,
                             dateScheduled: Date = getRandomDate(),
                             state: TripState = .completed,
                             vehicle: Vehicle = TestUtil.getRandomVehicle(),
                             fare: TripFare = TripFare(),
                             quote: TripQuote = getRandomTripQuote(quoteType: .estimated),
                             fleetInfo: FleetInfo = getRandomFleetInfo(),
                             meetingPoint: MeetingPoint? = getRandomMeetingPoint(),
                             serviceAgreements: ServiceAgreements? = nil) -> TripInfo {
        let trip = TripInfo(tripId: tripId,
                            displayId: TestUtil.getRandomString(),
                            followCode: followCode,
                            origin: getRandomTripLocationDetails(),
                            destination: getRandomTripLocationDetails(),
                            dateScheduled: dateScheduled,
                            state: state,
                            quote: quote,
                            vehicle: vehicle,
                            fleetInfo: fleetInfo,
                            meetingPoint: meetingPoint,
                            fare: fare,
                            serviceAgreements: serviceAgreements)
        return trip
    }

    public class func getRandomMeetingPoint(type: MeetingPointType = .notSet) -> MeetingPoint {
        return MeetingPoint(position: getRandomPosition(),
                            instructions: getRandomString(),
                            type: type)
    }

    public class func getRandomFleetInfo(fleetId: String = getRandomString(),
                                  name: String =  getRandomString(),
                                  description: String =  getRandomString(),
                                  phoneNumber: String =  getRandomString(),
                                  termsConditionsUrl: String =  getRandomString(),
                                  logoUrl: String =  getRandomString(),
                                  email: String =  getRandomString()) -> FleetInfo {
        return FleetInfo(fleetId: fleetId,
                         name: name,
                         description: description,
                         phoneNumber: phoneNumber,
                         termsConditionsUrl: termsConditionsUrl,
                         logoUrl: logoUrl)
    }

    public class func getRandomTripLocationDetails() -> TripLocationDetails {
        return TripLocationDetails(displayAddress: TestUtil.getRandomString(),
                                   placeId: TestUtil.getRandomString(),
                                   position: getRandomPosition(),
                                   timeZoneIdentifier: "Europe/London")

    }

    public class func getRandomPosition(latitude: Double = Double(TestUtil.getRandomInt()),
                                 longitude: Double = Double(TestUtil.getRandomInt())) -> Position {
        return Position(latitude: latitude, longitude: longitude)
    }

    public class func getRandomDirection(kph: Int = Int(TestUtil.getRandomInt()),
                                  heading: Int = Int(TestUtil.getRandomInt())) -> Direction {
        return Direction(kph: kph, heading: heading)
    }

    public class func getRandomFare() -> Fare {
        return Fare(breakdown: FareComponent(total: 1000.0, currency: "GBP"))
    }

    public class func getRandomTripFare() -> TripFare {
        return TripFare(total: 20, currency: "GBP", gratuityPercent: 2)
    }

    public class func getRandomVehicle(driver: Driver = getRandomDriver(),
                                vehicleClass: String = getRandomString()) -> Vehicle {
        return Vehicle(vehicleClass: vehicleClass,
                       vehicleLicensePlate: getRandomString(),
                       description: getRandomString(),
                       driver: driver)
    }

    public class func getRandomDriver(firstName: String = getRandomString(),
                               lastName: String = getRandomString(),
                               photoURL: String = TestUtil.getRandomString(),
                               phoneNumber: String = TestUtil.getRandomString(),
                               licenseNumber: String = TestUtil.getRandomString()) -> Driver {
        return Driver(firstName: firstName,
                      lastName: lastName,
                      phoneNumber: phoneNumber,
                      photoUrl: photoURL,
                      licenseNumber: licenseNumber)
    }

    public class func getRandomQuote(quoteId: String = getRandomString(),
                              availabilityId: String = getRandomString(),
                              fleetName: String = getRandomString(),
                              highPrice: Int = 1000,
                              lowPrice: Int = 100,
                              qtaHighMinutes: Int = 10,
                              qtaLowMinutes: Int = 1,
                              quoteType: QuoteType = .fixed,
                              categoryName: String = getRandomString(),
                              currencyCode: String = "GBP",
                              source: QuoteSource = .market,
                              pickUpType: PickUpType = .default,
                              passengerCapacity: Int = 1,
                              luggageCapacity: Int = 2,
                              type: String = getRandomString(),
                              serviceLevelAgreements: ServiceAgreements? = ServiceAgreements()) -> Quote {
        let price = QuotePrice(highPrice: Double(highPrice),
                               lowPrice: Double(lowPrice),
                               currencyCode: currencyCode,
                               intLowPrice: lowPrice,
                               intHighPrice: highPrice)
        let qta = QuoteQta(highMinutes: qtaHighMinutes, lowMinutes: qtaLowMinutes)
        let fleet = Fleet(name: fleetName)
        let vehicle = QuoteVehicle(vehicleClass: categoryName, type: type, qta: qta, passengerCapacity: passengerCapacity, luggageCapacity: luggageCapacity)
        return Quote(id: quoteId,
                     quoteType: quoteType,
                     source: source,
                     pickUpType: pickUpType,
                     fleet: fleet,
                     vehicle: vehicle,
                     price: price,
                     validity: 1,
                     serviceLevelAgreements: serviceLevelAgreements ?? ServiceAgreements())
    }

    public class func getRandomUser(inOrganisation: Bool = true,
                             nonce: Nonce? = Nonce(),
                             paymentProvider: String = "braintree") -> UserInfo {
        let org = Organisation(id: "some", name: "company", roles: ["bread"])
        var user = UserInfo(userId: getRandomString(),
                            firstName: getRandomString(),
                            lastName: getRandomString(),
                            email: getRandomString(),
                            mobileNumber: getRandomString(),
                            organisations: inOrganisation ? [org] : [],
                            nonce: nonce)
        user.paymentProvider = PaymentProvider(provider: Provider(id: paymentProvider),
                                               loyaltyProgamme: LoyaltyProgramme())
        return user
    }

    public class func getRandomUserRegistration() -> UserRegistration {
        return UserRegistration(firstName: getRandomString(),
                                lastName: getRandomString(),
                                email: getRandomString(),
                                phoneNumber: getRandomString(),
                                locale: getRandomString(),
                                password: getRandomString())
    }

    public class func getRandomPassengers() -> Passengers {
        return Passengers(additionalPassengers: 0, passengerDetails: [PassengerDetails(user: TestUtil.getRandomUser())])
    }

    public class func getRandomJourneyDetails(originSet: Bool = true,
                                       destinationSet: Bool = true,
                                       dateSet: Bool = true,
                                       originTimeZoneIdentifier: String = "Europe/London") -> JourneyDetails {
        var details = JourneyDetails()

        if originSet {
            details.originLocationDetails = getRandomLocationInfo(timeZoneIdentifier: originTimeZoneIdentifier)
        }

        if destinationSet {
            details.destinationLocationDetails = getRandomLocationInfo()
        }

        if dateSet {
            details.scheduledDate = Date(timeIntervalSince1970: TimeInterval(arc4random_uniform(10000000)))
        }

        return details
    }

    public class func getAirportBookingDetails(originAsAirportAddress: Bool = false) -> JourneyDetails {
        var journeyDetails: JourneyDetails
        let airportLocationDetails = getRandomLocationInfo(poiType: .enriched, poiDetails: getAirportPoiDetails())
        if originAsAirportAddress == true {
            journeyDetails = JourneyDetails(originLocationDetails: airportLocationDetails)
            journeyDetails.destinationLocationDetails = getRandomLocationInfo()
        } else {
            journeyDetails = JourneyDetails(originLocationDetails: getRandomLocationInfo())
            journeyDetails.destinationLocationDetails = airportLocationDetails
        }

        return journeyDetails
    }

    public class func getAirportPoiDetails() -> PoiDetails {
        PoiDetails(iata: getRandomString(), terminal: getRandomString(), type: .airport)
    }

    public class func getRandomLocationInfo(placeId: String = getRandomString(),
                                     timeZoneIdentifier: String = "Europe/London",
                                     poiType: PoiType = .notSetPoiType,
                                     poiDetails: PoiDetails = PoiDetails(),
                                     position: Position = getRandomPosition()) -> LocationInfo {

        let locationAddress = LocationInfoAddress(displayAddress: getRandomString(),
                                                  lineOne: getRandomString(),
                                                  lineTwo: getRandomString(),
                                                  buildingNumber: getRandomString(),
                                                  streetName: getRandomString(),
                                                  city: getRandomString(),
                                                  postalCode: getRandomString(),
                                                  countryCode: getRandomString(),
                                                  region: getRandomString())
        
        return LocationInfo(
            placeId: placeId,
            timeZoneIdentifier: timeZoneIdentifier,
            position: position,
            poiType: poiType,
            address: locationAddress,
            details: poiDetails
        )
    }

    public class func getRandomDriverTrackingInfo(etaToOrigin: Int = 10,
                                           etaToDestination: Int = 10) -> DriverTrackingInfo {
        DriverTrackingInfo(
            position: TestUtil.getRandomPosition(),
            direction: TestUtil.getRandomDirection(),
            originEta: etaToOrigin,
            destinationEta: etaToDestination
        )
    }

    public class func getRandomTripQuote(
        quoteType: QuoteType = .fixed,
        total: Int = getRandomInt()
    ) -> TripQuote {
        TripQuote(
            total: total,
            currency: "GBP",
            gratuityPercent: 5,
            breakdown: [nil],
            qtaHighMinutes: 10,
            qtaLowMinutes: 5,
            type: quoteType,
            vehicleClass: "Saloon"
        )
    }

    public class func getRandomVehicleAttributes() -> QuoteVehicle {
        QuoteVehicle(
            vehicleClass: "Saloon",
            passengerCapacity: Int.random(in: 0...5),
            luggageCapacity: Int.random(in: 0...7)
        )
    }
    
    public class func getRandomJourneyInfo() -> JourneyInfo {
        JourneyInfo(
            origin: CLLocation(latitude: 2000.0, longitude: -454.53),
           destination: CLLocation(latitude: 900.65, longitude: 874.53),
           date: Date()
        )
    }

    public class func getRandomBraintreePaymentMethod(nonce: String = getRandomString()) -> Nonce {
        Nonce(
            nonce: nonce,
            cardType: getRandomString(),
            lastFour: "1111"
        )
    }

    public class func getRandomGuestSettings(organisationId: String = getRandomString()) -> GuestSettings {
        return GuestSettings(identifier: "identifier", referer: "referer", organisationId: organisationId)
    }

    public class func getRandomPassengerDetails(
        firstName: String = getRandomString(),
        lastName: String = getRandomString(),
        email: String = getRandomString(),
        phoneNumber: String = getRandomString(),
        locale: String = getRandomString()
    ) -> PassengerDetails {
        return PassengerDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            locale: locale
        )
    }

    public class func getRandomValidPassengerDetails(
        firstName: String = getRandomLabel(),
        lastName: String = getRandomLabel(),
        email: String = getRandomEmail(),
        phoneNumber: String = gerRandomPhoneNumber(),
        locale: String = getRandomString()
    ) -> PassengerDetails {
        PassengerDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            locale: locale
        )
    }
}
