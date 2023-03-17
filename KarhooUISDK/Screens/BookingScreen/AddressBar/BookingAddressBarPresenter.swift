//
//  BookingAddressBarPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import CoreLocation

final class BookingAddressBarPresenter: AddressBarPresenter {

    private let journeyDetailsManager: JourneyDetailsManager
    private var journeyInfo: JourneyInfo?
    private let addressService: AddressService
    private weak var view: AddressBarView?
    private let userLocationProvider: UserLocationProvider
    private let addressScreenBuilder: AddressScreenBuilder
    private let datePickerScreenBuilder: DatePickerScreenBuilder

    init(journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
         journeyInfo: JourneyInfo? = nil,
         addressService: AddressService = Karhoo.getAddressService(),
         userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressScreenBuilder: AddressScreenBuilder = KarhooUI().screens().address(),
         datePickerScreenBuilder: DatePickerScreenBuilder = UISDKScreenRouting.default.datePicker()) {
        self.journeyDetailsManager = journeyDetailsManager
        self.journeyInfo = journeyInfo
        self.addressService = addressService
        self.userLocationProvider = userLocationProvider
        self.addressScreenBuilder = addressScreenBuilder
        self.datePickerScreenBuilder = datePickerScreenBuilder
        journeyDetailsManager.add(observer: self)
    }

    deinit {
        journeyDetailsManager.remove(observer: self)
    }

    func load(view: AddressBarView?) {
        self.view = view
        show(journeyDetails: journeyDetailsManager.getJourneyDetails())
    }

    func addressSelected(type: AddressType) {
        var searchBias: CLLocation?

        var typeSelected = type

        if typeSelected == .destination && journeyDetailsManager.getJourneyDetails()?.originLocationDetails == nil {
            typeSelected = .pickup
        }

        if case AddressType.pickup = typeSelected {
            searchBias = userLocationProvider.getLastKnownLocation()
        } else {
            searchBias = journeyDetailsManager.getJourneyDetails()?.originLocationDetails?.position.toCLLocation()
        }
        
        let addressSearchScreen = addressScreenBuilder.buildAddressScreen(locationBias: searchBias,
                                                                          addressType: typeSelected,
                                                                          callback: { [weak self] result in
                                                                            self?.addressScreenCompleted(result: result, addressType: typeSelected)
        })
        addressSearchScreen.modalPresentationStyle = .fullScreen
        view?.parentViewController?.present(addressSearchScreen,
                                            animated: true, completion: nil)
    }

    private func addressScreenCompleted(result: ScreenResult<LocationInfo>, addressType: AddressType) {
        switch addressType {
        case .pickup:
            if let newOrigin = result.completedValue() {
                journeyDetailsManager.set(pickup: newOrigin)
            }
        case .destination:
            if let newDestination = result.completedValue() {
                journeyDetailsManager.set(destination: newDestination)
            }
        }

        self.view?.parentViewController?.dismiss(animated: true, completion: nil)
    }

    func addressCleared(type: AddressType) {
        switch type {
        case .pickup: journeyDetailsManager.set(pickup: nil)
        case .destination: journeyDetailsManager.set(destination: nil)
        }
    }

    func prebookSelected(optionalDoneCallback: (() -> Void)?) {
        guard let currentBookingDetails = journeyDetailsManager.getJourneyDetails(),
            let originTimeZone = journeyDetailsManager.getJourneyDetails()?.originLocationDetails?.timezone() else {
            return
        }
        
        let datePickerScreen = datePickerScreenBuilder
            .buildDatePickerScreen(
                startDate: currentBookingDetails.scheduledDate,
                timeZone: originTimeZone,
                callback: { [weak self] result in
                    if result.isComplete(), let optionalDoneCallback {
                        optionalDoneCallback()
                        self?.view?.parentViewController?.dismiss(animated: false, completion: nil)
                    } else {
                        self?.view?.parentViewController?.dismiss(animated: true, completion: nil)
                    }
                    if result.isComplete() {
                        self?.journeyDetailsManager.set(prebookDate: result.completedValue())
                    }
                }
            )

        datePickerScreen.modalPresentationStyle = .overCurrentContext
        
        view?.parentViewController?.present(datePickerScreen, animated: true, completion: nil)
    }

    func prebookCleared() {
        journeyDetailsManager.set(prebookDate: nil)
    }

    func addressSwapSelected() {
        var swappedDetails = journeyDetailsManager.getJourneyDetails()?.reverse()
        pickupSet(locationInfo: swappedDetails?.originLocationDetails)
        destinationSet(locationInfo: swappedDetails?.destinationLocationDetails)
        swappedDetails?.scheduledDate = journeyDetailsManager.getJourneyDetails()?.scheduledDate

        show(journeyDetails: swappedDetails)
    }

    func journeyDetailsChanged(details: JourneyDetails?) {
        show(journeyDetails: details)
    }

    private func pickupSet(locationInfo: LocationInfo?) {
        guard let pickup = locationInfo else {
            return
        }
        journeyDetailsManager.set(pickup: pickup)
    }

    private func destinationSet(locationInfo: LocationInfo?) {
        guard let destination = locationInfo else {
            return
        }
        journeyDetailsManager.set(destination: destination)
        view?.destinationSetState(disableClearButton: false)
    }

    private func show(journeyDetails: JourneyDetails?) {
        setUpPickupState(locationInfo: journeyDetails?.originLocationDetails)
        setUpDestinationState(locationInfo: journeyDetails?.destinationLocationDetails)
        setUpPrebookState(date: journeyDetails?.scheduledDate)
    }

    private func setUpPickupState(locationInfo: LocationInfo?) {
        if locationInfo == nil {
            view?.pickupNotSetState()
            view?.set(pickupDisplayAddress: UITexts.AddressBar.addPickup)
            return
        }
        
        view?.pickupSetState()
        view?.set(pickupDisplayAddress: locationInfo?.address.displayAddress)
    }

    private func setUpDestinationState(locationInfo: LocationInfo?) {
        if locationInfo == nil {
            view?.destinationNotSetState()
        } else {
            view?.set(destinationDisplayAddress: locationInfo?.address.displayAddress)
            view?.destinationSetState(disableClearButton: false)
        }
    }

    private func setUpPrebookState(date: Date?) {
        if let date = date {
            setPrebook(date: date)
        } else {
            view?.setDefaultPrebookState()
        }
    }

    private func setPrebook(date: Date) {
        guard let originTimeZone = journeyDetailsManager.getJourneyDetails()?.originLocationDetails?.timezone() else {
            return
        }
        
        let timeZone = originTimeZone
        let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)
        view?.set(prebookDate: prebookFormatter.display(mediumStyleDate: date),
                  prebookTime: prebookFormatter.display(shortStyleTime: date))
    }
}
