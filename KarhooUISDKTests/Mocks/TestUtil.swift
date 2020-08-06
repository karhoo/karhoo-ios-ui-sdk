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

class TestUtil: PrimitiveUtil {
    
    class func getRandomError(code: String = TestUtil.getRandomString(),
                              message: String = TestUtil.getRandomString(),
                              userMessage: String = TestUtil.getRandomString()) -> MockError {
        let error = MockError(code: code,
                              message: message,
                              userMessage: userMessage)
        return error
    }

    class func getRandomTrip(tripId: String = TestUtil.getRandomString(),
                             dateSet: Bool = false,
                             dateScheduled: Date = getRandomDate(),
                             state: TripState = .completed,
                             vehicle: Vehicle = TestUtil.getRandomVehicle(),
                             fare: TripFare = TripFare(),
                             quote: TripQuote = getRandomTripQuote(quoteType: .estimated),
                             fleetInfo: FleetInfo = getRandomFleetInfo(),
                             meetingPoint: MeetingPoint? = getRandomMeetingPoint()) -> TripInfo {
        let trip = TripInfo(tripId: tripId,
                            displayId: TestUtil.getRandomString(),
                            origin: getRandomTripLocationDetails(),
                            destination: getRandomTripLocationDetails(),
                            dateScheduled: dateScheduled,
                            state: state,
                            quote: quote,
                            vehicle: vehicle,
                            fleetInfo: fleetInfo,
                            meetingPoint: meetingPoint,
                            fare: fare)
        return trip
    }

    class func getRandomMeetingPoint(type: MeetingPointType = .notSet) -> MeetingPoint {
        return MeetingPoint(position: getRandomPosition(),
                            instructions: getRandomString(),
                            type: type)
    }

    class func getRandomFleetInfo(fleetId: String = getRandomString(),
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

    class func getRandomTripLocationDetails() -> TripLocationDetails {
        return TripLocationDetails(displayAddress: TestUtil.getRandomString(),
                                   placeId: TestUtil.getRandomString(),
                                   position: getRandomPosition(),
                                   timeZoneIdentifier: "Europe/London")
        
    }
    
    class func getRandomPosition(latitude: Double = Double(TestUtil.getRandomInt()),
                                 longitude: Double = Double(TestUtil.getRandomInt())) -> Position {
        return Position(latitude: latitude, longitude: longitude)
    }

    class func getRandomFare() -> Fare {
        return Fare(breakdown: FareComponent(total: 1000.0, currency: "GBP"))
    }
    
    class func getRandomTripFare() -> TripFare {
        return TripFare(total: 20, currency: "GBP", gratuityPercent: 2)
    }

    class func getRandomVehicle(driver: Driver = getRandomDriver(),
                                vehicleClass: String = getRandomString()) -> Vehicle {
        return Vehicle(vehicleClass: vehicleClass,
                       vehicleLicensePlate: getRandomString(),
                       description: getRandomString(),
                       driver: driver)
    }

    class func getRandomDriver(firstName: String = getRandomString(),
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

    class func getRandomQuote(quoteId: String = getRandomString(),
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
                              vehicleAttributes: VehicleAttributes = VehicleAttributes()) -> Quote {
        let price = QuotePrice(highPrice: Double(highPrice),
                               lowPrice: Double(lowPrice),
                               currencyCode: currencyCode)
        let qta = QuoteQta(highMinutes: qtaHighMinutes, lowMinutes: qtaLowMinutes)
        let fleet = FleetInfo(name: fleetName)
        return Quote(id: quoteId,
                     quoteType: quoteType,
                     source: source,
                     pickUpType: pickUpType,
                     fleet: fleet,
                     vehicleAttributes: vehicleAttributes,
                     vehicle: QuoteVehicle(vehicleClass: categoryName, qta: qta),
                     price: price,
                     validity: 1)
    }

    class func getRandomUser(inOrganisation: Bool = true,
                             nonce: Nonce? = Nonce()) -> UserInfo {
        let org = Organisation(id: "some", name: "company", roles: ["bread"])
        return UserInfo(userId: getRandomString(),
                    firstName: getRandomString(),
                    lastName: getRandomString(),
                    email: getRandomString(),
                    mobileNumber: getRandomString(),
                    organisations: inOrganisation ? [org] : [],
                    nonce: nonce)
    }

    class func getRandomUserRegistration() -> UserRegistration {
        return UserRegistration(firstName: getRandomString(),
                                lastName: getRandomString(),
                                email: getRandomString(),
                                phoneNumber: getRandomString(),
                                locale: getRandomString(),
                                password: getRandomString())
    }

    class func getRandomPassengers() -> Passengers {
        return Passengers(additionalPassengers: 0, passengerDetails: [PassengerDetails(user: TestUtil.getRandomUser())])
    }

    class func getRandomBookingDetails(originSet: Bool = true,
                                       destinationSet: Bool = true,
                                       dateSet: Bool = true,
                                       originTimeZoneIdentifier: String = "Europe/London") -> BookingDetails {
        var details = BookingDetails()

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

    class func getAirportBookingDetails(originAsAirportAddress: Bool = false) -> BookingDetails {
        var bookingDetails: BookingDetails
        let airportLocationDetails = getRandomLocationInfo(poiType: .enriched, poiDetails: getAirportPoiDetails())
        if originAsAirportAddress == true {
            bookingDetails = BookingDetails(originLocationDetails: airportLocationDetails)
            bookingDetails.destinationLocationDetails = getRandomLocationInfo()
        } else {
            bookingDetails = BookingDetails(originLocationDetails: getRandomLocationInfo())
            bookingDetails.destinationLocationDetails = airportLocationDetails
        }

        return bookingDetails
    }

    class func getAirportPoiDetails() -> PoiDetails {
        return PoiDetails(iata: getRandomString(), terminal: getRandomString(), type: .airport)
    }

    class func getRandomAddress(placeId: String = getRandomString(),
                                location: CLLocation = getRandomLocation(),
                                timeZoneIdentifier: String? = nil) -> Address {
        return Address(placeId: placeId,
                       displayAddress: getRandomString(),
                       lineOne: getRandomString(),
                       timeZoneIdentifier: timeZoneIdentifier)
    }

    class func getRandomLocationInfo(placeId: String = getRandomString(),
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
        
        return LocationInfo(placeId: placeId,
                            timeZoneIdentifier: timeZoneIdentifier,
                            position: position,
                            poiType: poiType,
                            address: locationAddress,
                            details: poiDetails)
    }

    class func getRandomDriverTrackingInfo(etaToOrigin: Int = 10,
                                           etaToDestination: Int = 10) -> DriverTrackingInfo {
        return DriverTrackingInfo(position: TestUtil.getRandomPosition(),
                                  originEta: etaToOrigin,
                                  destinationEta: etaToDestination)
    }

    class func getRandomTripQuote(quoteType: QuoteType = .fixed,
                                  total: Int = getRandomInt()) -> TripQuote {
        return TripQuote(total: total,
                         currency: "GBP",
                         gratuityPercent: 5,
                         breakdown: [nil],
                         qtaHighMinutes: 10,
                         qtaLowMinutes: 5,
                         type: quoteType,
                         vehicleClass: "Saloon",
                         vehicleAttributes: getRandomVehicleAttributes())
    }

    class func getRandomVehicleAttributes() -> VehicleAttributes {
        return VehicleAttributes(childSeat: getRandomBool(),
                                 electric: getRandomBool(),
                                 hybrid: getRandomBool(),
                                 luggageCapacity: Int.random(in: 0...5),
                                 passengerCapacity: Int.random(in: 0...7))
    }
    
    class func getRandomJourneyInfo() -> JourneyInfo {
        return JourneyInfo(origin: CLLocation(latitude: 2000.0, longitude: -454.53),
                           destination: CLLocation(latitude: 900.65, longitude: 874.53),
                           date: Date())
    }

    class func getRandomBraintreePaymentMethod(nonce: String = getRandomString()) -> PaymentMethod {
        return PaymentMethod(nonce: nonce,
                             nonceType: getRandomString(),
                             icon: UIView(),
                             paymentDescription: getRandomString())
    }

    class func getRandomGuestSettings(organisationId: String = getRandomString()) -> GuestSettings {
        return GuestSettings(identifier: "identifier", referer: "referer", organisationId: organisationId)
    }

    class func getRandomPassengerDetails(firstName: String = getRandomString(),
                                         lastName: String = getRandomString(),
                                         email: String = getRandomString(),
                                         phoneNumber: String = getRandomString(),
                                         locale: String = getRandomString()) -> PassengerDetails {
        return PassengerDetails(firstName: firstName,
                                lastName: lastName,
                                email: email,
                                phoneNumber: phoneNumber,
                                locale: locale)
    }
}
