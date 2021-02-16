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
    private let mailComposer: FeedbackEmailComposer?
    private weak var view: StackButtonView?
    private weak var rideDetailsStackButtonActions: RideDetailsStackButtonActions?

    init(trip: TripInfo,
         stackButton: StackButtonView?,
         mailComposer: FeedbackEmailComposer?,
         rideDetailsStackButtonActions: RideDetailsStackButtonActions) {
        self.trip = trip
        self.mailComposer = mailComposer
        self.view = stackButton
        self.rideDetailsStackButtonActions = rideDetailsStackButtonActions

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
        view?.set(buttonText: UITexts.Bookings.trackTrip, action: { [weak self] in
            self?.rideDetailsStackButtonActions?.trackRide()
        })
    }

    private func setupUpAndComingTrip() {
        view?.set(firstButtonText: UITexts.Bookings.cancelRide, firstButtonAction: { [weak self] in
            self?.rideDetailsStackButtonActions?.cancelRide()
        }, secondButtonText: UITexts.Bookings.contactFleet, secondButtonAction: {
            PhoneNumberCaller().call(number: self.trip.fleetInfo.phoneNumber)
        })
    }

    private func setupPastTrip() {
        view?.set(firstButtonText: UITexts.Bookings.reportIssue, firstButtonAction: { [weak self] in
            self?.reportIssue()
        }, secondButtonText: UITexts.Bookings.rebookRide, secondButtonAction: { [weak self] in
            self?.rideDetailsStackButtonActions?.rebookRide()
        })
    }

    private func reportIssue() {
        if ((self.mailComposer?.reportIssueWith(trip: self.trip)) != nil) {
            return
        }

        self.rideDetailsStackButtonActions?.reportIssueError()
    }
}
