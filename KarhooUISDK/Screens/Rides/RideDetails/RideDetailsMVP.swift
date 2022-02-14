//
//  RideDetailsMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol RideDetailsPresenter: AnyObject {

    func bind(view: RideDetailsView)

    func didPresssReportIsssue()

    func didPressTrackTrip()

    func didPressRebookTrip()

    func didPressCancelTrip()

    func didPressBaseFareExplanation()

    func didPressTripFeedback()
    
    func sendTripRate(rating: Int)

    func didPressContactFleet(_ phoneNumber: String)

    func didPressContactDriver(_ phoneNumber: String)
}

protocol RideDetailsView: BaseViewController {

    func setUpWith(trip: TripInfo, mailComposer: FeedbackEmailComposer)

    func set(navigationTitle: String)

    func showLoading()

    func hideLoading()

    func hideFeedbackOptions()
}

public enum RideDetailsAction {
    case trackTrip(_ trip: TripInfo)
    case rebookTrip(_ trip: TripInfo)
}
