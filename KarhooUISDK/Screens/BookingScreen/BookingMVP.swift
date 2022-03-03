//
//  BookingMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import CoreLocation

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

//    func setMapPadding(bottomPaddingEnabled: Bool)

    func set(leftNavigationButton: NavigationBarItemIcon)

    func set(sideMenu: SideMenu)
}

protocol BookingPresenter {

    func viewWillAppear()

    func load(view: BookingView?)

    func resetJourneyDetails()

    func populate(with journeyDetails: JourneyDetails)

    func getJourneyDetails() -> JourneyDetails?

    func tripSuccessfullyCancelled()

    func tripCancellationFailed(trip: TripInfo)

    func tripCancelledBySystem(trip: TripInfo)
    
    func tripDriverAllocationDelayed(trip: TripInfo)

    func didSelectQuote(quote: Quote)

    func showRidesList(presentationStyle: UIModalPresentationStyle?)

    func tripAllocated(trip: TripInfo)

    func exitPressed()

    func goToTripView(trip: TripInfo)
    
    func showRideDetailsView(trip: TripInfo)
    
    func didProvideJourneyDetails(_ details: JourneyDetails)
}

public enum BookingScreenResult {
    case tripAllocated(tripInfo: TripInfo)
    case prebookConfirmed(tripInfo: TripInfo, prebookConfirmationAction: PrebookConfirmationAction)
    case bookingFailed(error: KarhooError)
}
