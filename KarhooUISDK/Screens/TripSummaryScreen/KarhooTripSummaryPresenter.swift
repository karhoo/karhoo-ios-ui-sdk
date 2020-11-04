//
//  KarhooJourneySummaryPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KarhooJourneySummaryPresenter: JourneySummaryPresenter {

    private var journeySummaryView: JourneySummaryView?
    private let callback: ScreenResultCallback<JourneySummaryResult>
    private let analytics: Analytics
    private let trip: TripInfo

    init(trip: TripInfo,
         callback: @escaping ScreenResultCallback<JourneySummaryResult>,
         analytics: Analytics = KarhooAnalytics()) {
        self.trip = trip
        self.callback = callback
        self.analytics = analytics
    }

    func viewLoaded(view: JourneySummaryView) {
        self.journeySummaryView = view
        setViewContent()
    }

    func bookReturnRidePressed() {
        guard let initialDestination = trip.destination else {
            return
        }

        var returnBooking = BookingDetails(originLocationDetails: initialDestination.toLocationInfo())
        returnBooking.destinationLocationDetails = trip.origin.toLocationInfo()

        analytics.returnRideRequested()
        finishWithResult(.completed(result: .rebookWithBookingDetails(returnBooking)))
    }

    func exitPressed() {
        analytics.rideSummaryExited()
        finishWithResult(.completed(result: .closed))
    }

    private func finishWithResult(_ result: ScreenResult<JourneySummaryResult>) {
        callback(result)
    }

    private func setViewContent() {
        journeySummaryView?.set(trip: trip)
    }
}
