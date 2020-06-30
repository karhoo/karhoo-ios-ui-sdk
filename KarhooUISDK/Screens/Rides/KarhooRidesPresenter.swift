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
    private var pages: [RidesListView]?

    public init(completion: @escaping ScreenResultCallback<RidesListAction>) {
        completionHandler = completion
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
            return
        }
        view?.moveTabToPastBookings()
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
