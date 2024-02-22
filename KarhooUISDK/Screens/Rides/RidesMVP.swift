//
//  RidesMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol RidesView: AnyObject {

    func set(pageViews: [RidesListView])

    func moveTabToPastBookings()

    func moveTabToUpcomingBookings()

    func set(title: String)
}

protocol RidesPresenter {

    func bind(view: RidesView)

    func set(pages: [RidesListView])

    func didPressClose()

    func didPressTrackTrip(trip: TripInfo)

    func didPressRebookTrip(trip: TripInfo)

    func didPressRequestTrip()

    func didSwitchToPage(index: Int)

    func contactFleet(_ trip: TripInfo, number: String)

    func contactDriver(_ trip: TripInfo, number: String)
}
