//
//  BookingsListPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class KarhooRidesListPresenter: RidesListPresenter, TripsProviderDelegate {

    private let tripsSorter: TripsSorter
    private var tripsProvider: TripsProvider
    private weak var ridesListView: RidesListView?
    internal var listOfTrips: [TripInfo] = []
    private let rideDetailsScreenBuilder: RideDetailsScreenBuilder

    init(tripsSorter: TripsSorter = KarhooTripsSorter(sortOrder: .orderedSame),
         tripsProvider: TripsProvider,
         rideDetailsScreenBuilder: RideDetailsScreenBuilder = UISDKScreenRouting.default.rideDetails()) {
        self.tripsSorter = tripsSorter
        self.tripsProvider = tripsProvider
        self.rideDetailsScreenBuilder = rideDetailsScreenBuilder
        self.tripsProvider.delegate = self
    }

    func load(screen: RidesListView) {
        ridesListView = screen
        reloadList()
    }

    func viewWillAppear() {
        reloadList()
    }

    func fetched(trips: [TripInfo]) {
        let filteredTrips = trips.filter { $0.state != .failed }
        
        guard let paginationEnabled = ridesListView?.paginationEnabled  else { return }
        if paginationEnabled {
            listOfTrips.append(contentsOf: tripsSorter.sort(trips: filteredTrips))
        } else {
            listOfTrips = tripsSorter.sort(trips: filteredTrips)
        }
        
        setUpScreen()
    }

    func tripProviderFailed(error: KarhooError?) {
        ridesListView?.setEmptyState(title: UITexts.Bookings.noTrips, message: UITexts.Bookings.couldNotLoadTrips)
    }

    func rideSelected(_ tripInfo: TripInfo) {
        let rideDetailsScreen = rideDetailsScreenBuilder.buildRideDetailsScreen(trip: tripInfo,
                                                                                callback: { [weak self] result in
            guard let action = result.completedValue() else {
                return
            }

            switch action {
            case .trackTrip(let trip):
                self?.ridesListView?.trackTrip(trip)
            case .rebookTrip(let trip):
                self?.ridesListView?.rebookTrip(trip)
            }

            self?.ridesListView?.dismiss(animated: true, completion: nil)
        })

        ridesListView?.push(rideDetailsScreen)
    }

    private func setUpScreen() {
        if listOfTrips.isEmpty {
            ridesListView?.setEmptyState(title: UITexts.Bookings.noTrips,
                                  message: UITexts.Bookings.noTripsBookedMessage)
        } else {
            ridesListView?.set(trips: tripsSorter.sort(trips: listOfTrips))
        }
    }

    private func reloadList() {
        tripsProvider.stop()
        listOfTrips = []
        tripsProvider.start()
    }
    
    public func requestNewPage() {
        tripsProvider.requestNewPage(pageOffset: listOfTrips.count)
    }
}
