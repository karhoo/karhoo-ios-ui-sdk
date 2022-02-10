//
//  BookingsRootPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

public enum RidesListAction {
    case bookNewTrip
    case trackTrip(trip: TripInfo)
    case rebookTrip(trip: TripInfo)
}

public final class KarhooRidesPresenter: RidesPresenter {

    private let completionHandler: ScreenResultCallback<RidesListAction>
    private weak var view: RidesView?
    private let analytics: Analytics
    private var pages: [RidesListView]?

    public init(
        analytics: Analytics? = nil,
        completion: @escaping ScreenResultCallback<RidesListAction>
    ) {
        self.completionHandler = completion
        self.analytics = analytics ?? KarhooUISDKConfigurationProvider.configuration.analytics()
    }

    public func didPressClose() {
        finishWithResult(.cancelled(byUser: true))
    }

    func bind(view: RidesView) {
        self.view = view
        setUpPages()
        view.set(title: UITexts.Generic.rides)
    }

    func set(pages: [RidesListView]) {
        self.pages = pages
    }

    func didPressTrackTrip(trip: TripInfo) {
        finishWithResult(.completed(result: .trackTrip(trip: trip)))
        analytics.trackTripClicked(tripDetails: trip)
    }

    func didPressRebookTrip(trip: TripInfo) {
        finishWithResult(.completed(result: .rebookTrip(trip: trip)))
    }

    func didPressRequestTrip() {
        finishWithResult(.completed(result: .bookNewTrip))
    }

    func didSwitchToPage(index: Int) {
        if index == 0 {
            view?.moveTabToUpcomingBookings()
            analytics.upcomingTripsOpened()
            return
        }
        view?.moveTabToPastBookings()
        analytics.pastTripsOpened()
    }

    func contactFleet(_ trip: TripInfo, number: String) {
        analytics.contactFleetClicked(page: .upcomingRides, tripDetails: trip)
        PhoneNumberCaller().call(number: number)
    }
    
    func contactDriver(_ trip: TripInfo, number: String) {
        analytics.contactDriverClicked(page: .upcomingRides, tripDetails: trip)
        PhoneNumberCaller().call(number: number)
    }

    private func setUpPages() {
        guard let view = self.view,
              let pages = self.pages else {
            return
        }

        view.set(pageViews: pages)
    }

    private func finishWithResult(_ result: ScreenResult<RidesListAction>) {
        completionHandler(result)
    }
}
