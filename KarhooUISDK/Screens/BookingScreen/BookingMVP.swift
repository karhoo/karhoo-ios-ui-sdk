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

    func set(bookingDetails: BookingDetails)

    func openTrip(_ trip: TripInfo)

    func openRidesList(presentationStyle: UIModalPresentationStyle?)

    func resetAndLocate()
}

/* internal interface for controlling booking screen */
internal protocol BookingView: BookingScreen {

    func reset()

    func resetAndLocate()

    func set(bookingDetails: BookingDetails)

    func showAllocationScreen(trip: TripInfo)

    func hideAllocationScreen()

    func showQuoteList()

    func hideQuoteList()
    
    func showNoAvailabilityBar()

    func hideNoAvailabilityBar()

    func setMapPadding(bottomPaddingEnabled: Bool)

    func set(leftNavigationButton: NavigationBarItemIcon)

    func set(sideMenu: SideMenu)
}

protocol BookingPresenter {

    func viewWillAppear()

    func load(view: BookingView?)

    func resetBookingStatus()

    func populate(with bookingDetails: BookingDetails)

    func bookingDetails() -> BookingDetails?

    func tripSuccessfullyCancelled()

    func tripCancellationFailed(trip: TripInfo)

    func tripCancelledBySystem(trip: TripInfo)

    func didSelectQuote(quote: Quote)

    func showRidesList(presentationStyle: UIModalPresentationStyle?)

    func tripAllocated(trip: TripInfo)

    func exitPressed()

    func goToJourneyView(trip: TripInfo)
}

public enum BookingScreenResult {
    case tripAllocated(tripInfo: TripInfo)
    case prebookConfirmed(tripInfo: TripInfo, prebookConfirmationAction: PrebookConfirmationAction)
    case bookingFailed(error: KarhooError)
}
