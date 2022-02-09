//
//  RideCellStackButtonPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class RideCellStackButtonPresenter {

    private let rideCellStackButtonActions: RideCellStackButtonActions
    private let trip: TripInfo
    private let view: StackButtonView

    init(stackButton: StackButtonView,
         trip: TripInfo,
         rideCellStackButtonActions: RideCellStackButtonActions) {
        self.rideCellStackButtonActions = rideCellStackButtonActions
        self.trip = trip
        self.view = stackButton

        if trip.state == .passengerOnBoard {
            setupSingleTrackRideButton()
            return
        }

        if TripInfoUtility.canTrackDriver(trip: trip) {
            if TripInfoUtility.canContactDriver(trip: trip) {
                setupTrackAndContactDriverState(driverNumber: trip.vehicle.driver.phoneNumber)
            } else {
                setupSingleTrackRideButton()
            }
            return
        }

        if TripInfoUtility.preDriverAllocation(trip: trip) {
            setupPreDriverAllocationState(supplierNumber: trip.fleetInfo.phoneNumber)
        }
    }

    private func setupSingleTrackRideButton() {
        view.set(buttonText: UITexts.Bookings.trackTrip, action: { [weak self] in
            self?.trackTripPressed()
        })
    }

    private func setupTrackAndContactDriverState(driverNumber: String) {
        view.set(firstButtonText: UITexts.Bookings.contactDriver, firstButtonAction: {
            PhoneNumberCaller().call(number: driverNumber)
        },
        secondButtonText: UITexts.Bookings.trackDriver, secondButtonAction: { [weak self] in
            self?.trackTripPressed()
        })
    }

    private func setupPreDriverAllocationState(supplierNumber: String) {
        view.set(
            buttonText: UITexts.Bookings.contactFleet,
            action: { [weak self] in
                guard let self = self else { return }
                self.rideCellStackButtonActions.contactFleet(self.trip, number: supplierNumber)
            }
        )
    }

    private func trackTripPressed() {
        rideCellStackButtonActions.track(self.trip)
    }
}
