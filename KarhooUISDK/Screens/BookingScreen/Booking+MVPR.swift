//
//  BookingMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import CoreLocation
import UIKit
import Combine

/* public interface for controlling booking screen */

public protocol BookingScreen: BaseViewController {

    func set(journeyDetails: JourneyDetails)

    func openTrip(_ trip: TripInfo)

    func openRidesList(presentationStyle: UIModalPresentationStyle?)

    func resetAndLocate()
    
    func openRideDetailsFor(_ trip: TripInfo)
}

/* internal interface for controlling booking screen */
internal protocol BookingView: BookingScreen {

    func reset()

    func resetAndLocate()

    func set(journeyDetails: JourneyDetails)

    func showAllocationScreen(trip: TripInfo)

    func hideAllocationScreen()

    func set(leftNavigationButton: NavigationBarItemIcon)

    func set(sideMenu: SideMenu)
}

protocol BookingPresenter {

    var hasCoverageInTheAreaPublisher: CurrentValueSubject<Bool?, Never> { get }

    var isAsapEnabledPublisher: CurrentValueSubject<Bool, Never> { get }

    var isScheduleForLaterEnabledPublisher: CurrentValueSubject<Bool, Never> { get }

    func viewWillAppear()

    func load(view: BookingView?)

    func resetJourneyDetails()

    func populate(with journeyDetails: JourneyDetails)

    func getJourneyDetails() -> JourneyDetails?

    func tripSuccessfullyCancelled()

    func tripCancellationFailed(trip: TripInfo)

    func tripCancelledBySystem(trip: TripInfo)
    
    func tripDriverAllocationDelayed(trip: TripInfo)

    func showRidesList(presentationStyle: UIModalPresentationStyle?)

    func tripAllocated(trip: TripInfo)

    func exitPressed()

    func asapRidePressed()

    func dataForScheduledRideProvided()

    func goToTripView(trip: TripInfo)
    
    func showRideDetailsView(trip: TripInfo)
    
    func didProvideJourneyDetails(_ details: JourneyDetails)
}

public enum BookingScreenResult {
    case tripAllocated(tripInfo: TripInfo)
    case prebookConfirmed(tripInfo: TripInfo)
    case bookingFailed(error: KarhooError)
}

protocol BookingRouter {
    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    )

    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<KarhooCheckoutResult>, Quote, JourneyDetails) -> Void
    )
}
