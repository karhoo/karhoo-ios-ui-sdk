//
//  KarhooTripSummaryPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KarhooTripSummaryPresenter: TripSummaryPresenter {

    private var tripSummaryView: TripSummaryView?
    private let callback: ScreenResultCallback<TripSummaryResult>
    private let analytics: Analytics
    private let trip: TripInfo

    init(
        trip: TripInfo,
        callback: @escaping ScreenResultCallback<TripSummaryResult>,
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.trip = trip
        self.callback = callback
        self.analytics = analytics
    }

    func viewLoaded(view: TripSummaryView) {
        self.tripSummaryView = view
        setViewContent()
    }

    func bookReturnRidePressed() {
        guard let initialDestination = trip.destination else {
            return
        }

        var returnBooking = BookingDetails(originLocationDetails: initialDestination.toLocationInfo())
        returnBooking.destinationLocationDetails = trip.origin.toLocationInfo()

        finishWithResult(.completed(result: .rebookWithBookingDetails(returnBooking)))
    }

    func exitPressed() {
        finishWithResult(.completed(result: .closed))
    }

    private func finishWithResult(_ result: ScreenResult<TripSummaryResult>) {
        callback(result)
    }

    private func setViewContent() {
        tripSummaryView?.set(trip: trip)
    }
}
