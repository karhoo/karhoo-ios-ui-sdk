//
//  RidesListMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol RidesListView: BaseViewController {
    
    var paginationEnabled: Bool { get set }

    func set(trips: [TripInfo])

    func setEmptyState(title: String, message: String)

    func set(ridesListActions: RidesListActions)

    func trackTrip(_ trip: TripInfo)

    func rebookTrip(_ trip: TripInfo)
}

protocol RidesListPresenter {

    func load(screen: RidesListView)

    func viewWillAppear()

    func rideSelected(_ tripInfo: TripInfo)
    
    func requestNewPage()
}

protocol RidesListActions: AnyObject {

    func trackTrip(_ trip: TripInfo)

    func rebookTrip(_ trip: TripInfo)

    func contactFleet(_ trip: TripInfo, number: String)

    func contactDriver(_ trip: TripInfo, number: String)
}
