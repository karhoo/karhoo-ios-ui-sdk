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

    private let journeyDetailsController: JourneyDetailsController
    private var journeyInfo: JourneyInfo?
    private let addressService: AddressService
    private weak var view: AddressBarView?
    private let userLocationProvider: UserLocationProvider
    private let addressScreenBuilder: AddressScreenBuilder
    private let datePickerScreenBuilder: DatePickerScreenBuilder

    init(journeyDetailsController: JourneyDetailsController = KarhooJourneyDetailsController.shared,
         journeyInfo: JourneyInfo? = nil,
         addressService: AddressService = Karhoo.getAddressService(),
         userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressScreenBuilder: AddressScreenBuilder = KarhooUI().screens().address(),
         datePickerScreenBuilder: DatePickerScreenBuilder = UISDKScreenRouting.default.datePicker()) {
        self.journeyDetailsController = journeyDetailsController
        self.journeyInfo = journeyInfo
        self.addressService = addressService
        self.userLocationProvider = userLocationProvider
        self.addressScreenBuilder = addressScreenBuilder
        self.datePickerScreenBuilder = datePickerScreenBuilder
        journeyDetailsController.add(observer: self)
    }

    deinit {
        journeyDetailsController.remove(observer: self)
    }

    func load(view: AddressBarView?) {
        self.view = view
        show(journeyDetails: journeyDetailsController.getJourneyDetails())
    }

    func addressSelected(type: AddressType) {
        var searchBias: CLLocation?

        var typeSelected = type

        if typeSelected == .destination && journeyDetailsController.getJourneyDetails()?.originLocationDetails == nil {
            typeSelected = .pickup
        }

        if case AddressType.pickup = typeSelected {
            searchBias = userLocationProvider.getLastKnownLocation()
        } else {
            searchBias = journeyDetailsController.getJourneyDetails()?.originLocationDetails?.position.toCLLocation()
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
                journeyDetailsController.set(pickup: newOrigin)
            }
        case .destination:
            if let newDestination = result.completedValue() {
                journeyDetailsController.set(destination: newDestination)
            }
        }

        self.view?.parentViewController?.dismiss(animated: true, completion: nil)
    }

    func addressCleared(type: AddressType) {
        switch type {
        case .pickup: journeyDetailsController.set(pickup: nil)
        case .destination: journeyDetailsController.set(destination: nil)
        }
    }

    func prebookSelected() {
        guard let currentBookingDetails = journeyDetailsController.getJourneyDetails(),
            let originTimeZone = journeyDetailsController.getJourneyDetails()?.originLocationDetails?.timezone() else {
            return
        }

        let datePickerScreen = datePickerScreenBuilder
            .buildDatePickerScreen(startDate: currentBookingDetails.scheduledDate,
                                   timeZone: originTimeZone,
                                   callback: { [weak self] result in
                                    self?.view?.parentViewController?.dismiss(animated: true, completion: nil)
                                    self?.journeyDetailsController.set(prebookDate: result.completedValue())
        })

        datePickerScreen.modalPresentationStyle = .overCurrentContext
        
        view?.parentViewController?.present(datePickerScreen, animated: true, completion: nil)
    }

    func prebookCleared() {
        journeyDetailsController.set(prebookDate: nil)
    }

    func addressSwapSelected() {
        var swappedDetails = journeyDetailsController.getJourneyDetails()?.reverse()
        pickupSet(locationInfo: swappedDetails?.originLocationDetails)
        destinationSet(locationInfo: swappedDetails?.destinationLocationDetails)
        swappedDetails?.scheduledDate = journeyDetailsController.getJourneyDetails()?.scheduledDate

        show(journeyDetails: swappedDetails)
    }

    func journeyDetailsChanged(details: JourneyDetails?) {
        show(journeyDetails: details)
    }

    private func pickupSet(locationInfo: LocationInfo?) {
        guard let pickup = locationInfo else {
            return
        }
        journeyDetailsController.set(pickup: pickup)
    }

    private func destinationSet(locationInfo: LocationInfo?) {
        guard let destination = locationInfo else {
            return
        }
        journeyDetailsController.set(destination: destination)
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
        guard let originTimeZone = journeyDetailsController.getJourneyDetails()?.originLocationDetails?.timezone() else {
            return
        }
        
        let timeZone = originTimeZone
        let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)
        view?.set(prebookDate: prebookFormatter.display(mediumStyleDate: date),
                  prebookTime: prebookFormatter.display(shortStyleTime: date))
    }
}
