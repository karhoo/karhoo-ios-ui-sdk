//
//  RideDetailsStackButtonPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class RideDetailsStackButtonPresenter {

    private let trip: TripInfo
    private let isFleetCall: Bool
    private let mailComposer: FeedbackEmailComposer?
    private let phoneNumberCaller: PhoneNumberCallerProtocol?
    private weak var view: StackButtonView?
    private weak var rideDetailsStackButtonActions: RideDetailsStackButtonActions?
    init(
        trip: TripInfo,
        stackButton: StackButtonView?,
        mailComposer: FeedbackEmailComposer?,
        rideDetailsStackButtonActions: RideDetailsStackButtonActions,
        phoneNumberCaller: PhoneNumberCallerProtocol? = PhoneNumberCaller()
    ) {
        self.trip = trip
        self.isFleetCall = trip.vehicle.driver.phoneNumber.isEmpty
        self.mailComposer = mailComposer
        self.view = stackButton
        self.rideDetailsStackButtonActions = rideDetailsStackButtonActions
        self.phoneNumberCaller = phoneNumberCaller

        if TripInfoUtility.canCancel(trip: trip) {
            setupUpAndComingTrip()
            return
        }

        let pastStates = TripStatesGetter().getStatesForTripRequest(type: .past)
        if pastStates.contains(trip.state) {
            setupPastTrip()
            return
        }

        if trip.state == .passengerOnBoard {
            setupPassengerOnBoardState()
            return
        }

        self.rideDetailsStackButtonActions?.hideRideOptions()
    }

    private func setupPassengerOnBoardState() {
        view?.set(buttonText: UITexts.Bookings.contactFleet, action: {
            self.phoneNumberCaller?.call(number: self.trip.fleetInfo.phoneNumber)
        })
    }

    private func setupUpAndComingTrip() {
        let buttonText = isFleetCall ? UITexts.Bookings.contactFleet : UITexts.Bookings.contactDriver
        let phoneNumber = isFleetCall ? self.trip.fleetInfo.phoneNumber : self.trip.vehicle.driver.phoneNumber
        view?.set(
            firstButtonText: UITexts.Bookings.cancelRide,
            firstButtonAction: { [weak self] in
                self?.rideDetailsStackButtonActions?.cancelRide()
            },
            secondButtonText: buttonText,
            secondButtonAction: { [weak self] in
                self?.contact(phoneNumber)
            }
        )
    }

    private func setupPastTrip() {
        view?.set(firstButtonText: UITexts.Bookings.reportIssue, firstButtonAction: { [weak self] in
            self?.reportIssue()
        }, secondButtonText: UITexts.Bookings.rebookRide, secondButtonAction: { [weak self] in
            self?.rideDetailsStackButtonActions?.rebookRide()
        })
    }

    private func contact(_ phoneNumber: String) {
        if isFleetCall {
            rideDetailsStackButtonActions?.contactFleet(phoneNumber)
        } else {
            rideDetailsStackButtonActions?.contactDriver(phoneNumber)
        }
    }

    private func reportIssue() {
        if self.mailComposer?.reportIssueWith(trip: self.trip) != nil {
            return
        }

        self.rideDetailsStackButtonActions?.reportIssueError()
    }
}
