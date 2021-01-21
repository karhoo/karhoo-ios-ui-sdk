//
//  TestAnalytics.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

class MockAnalytics: Analytics {

    var changePaymentPrssedCalled = false
    func changePaymentPressed() {
        changePaymentPrssedCalled = true
    }

    private(set) var vehicleTypeSelectedCalled = false
    func vehicleTypeSelected(selectedCategory: String, quoteListId: String?) {
        vehicleTypeSelectedCalled = true
    }

    var pickupAddressSelectedCalled = false
    func pickupAddressSelected(_: LocationInfo) {
        pickupAddressSelectedCalled = true
    }

    var destinationAddressSelected = false
    func destinationAddressSelected(_: LocationInfo) {
        destinationAddressSelected = true
    }

    var pickupAddressDisplayedCalled = false
    func pickupAddressDisplayed(count: Int) {
        pickupAddressDisplayedCalled = true
    }

    var destinationAddressDisplayedCalled = false
    func destinationAddressDisplayed(count: Int) {
        destinationAddressDisplayedCalled = true
    }

    private(set) var prebookTimeSetCalled = false
    func prebookTimeSet(date: Date) {
        prebookTimeSetCalled = true
    }

    var fleetListShownCalled = false
    var fleetListShownWithQuouteListId: String?
    func fleetListShown(quoteListId: String?) {
        fleetListShownCalled = true
        fleetListShownWithQuouteListId = quoteListId
    }

    private(set) var cardRegistrationFailedCalled = false
    func cardRegistrationFailed() {
        cardRegistrationFailedCalled = true
    }

    private(set) var userCardRegisteredCalled = false
    func userCardRegistered() {
        userCardRegisteredCalled = true
    }

    private(set) var userTermsReviewedCalled = false
    func userTermsReviewed() {
        userTermsReviewedCalled = true
    }

    private(set) var userDidCallDriver = false
    func userCalledDriver() {
        userDidCallDriver = true
    }

    private(set) var preebokPickerOpened = false
    func prebookPickerOpened() {
        preebokPickerOpened = true
    }

    private(set) var fleetsSortedBy: String?
    func fleetsSorted(by sortType: String) {
        fleetsSortedBy = sortType
    }

    func appReopened() {}

    func appBackgrounded() {}

    func appClosed() {}

    func appOpened() {}

    var tripStateChangedCalled = false
    func tripStateChanged(to newState: String) {
        tripStateChangedCalled = true
    }

    var categorySelectedArgument: String?
    func categorySelected(selectedCategory: String) {
        categorySelectedArgument = selectedCategory
    }

    var availabilityListExpandedCalled = false
    func availabilityListExpanded() {
        availabilityListExpandedCalled = true
    }

    var locationServicesRejectedCalled = false
    func locationServicesRejected() {
        locationServicesRejectedCalled = true
    }

    var prebookOpenedCalled = false
    func prebookOpened() {
        prebookOpenedCalled = true
    }

    var returnRideRequestedCalled = false
    func returnRideRequested() {
        returnRideRequestedCalled = true
    }

    var rideSummaryExitCalled = false
    func rideSummaryExited() {
        rideSummaryExitCalled = true
    }

    private(set) var tripCancellationInitiatedCalled: TripInfo?
    func tripAllocationCancellationIntiatedByUser(trip: TripInfo) {
        tripCancellationInitiatedCalled = trip
    }
    
    var isChangeCardDetailsPressed = false
    func changeCardDetailsPressed() {
        isChangeCardDetailsPressed = true
    }
    
    var userPressedCurrentLocationWithAddressType: (called: Bool, addressType: String) = (called: false,
                                                                                          addressType: "")
    func userPressedCurrentLocation(addressType: String) {
        userPressedCurrentLocationWithAddressType.called = true
        userPressedCurrentLocationWithAddressType.addressType = addressType
    }

    var bookingRequestedCalled = false
    func bookingRequested(destination: LocationInfo, dateScheduled: Date?, quote: Quote) {
        bookingRequestedCalled = true
    }
}
