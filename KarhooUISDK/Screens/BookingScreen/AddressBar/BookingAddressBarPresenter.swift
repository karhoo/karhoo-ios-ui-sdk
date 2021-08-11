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

    private let bookingStatus: BookingStatus
    private var journeyInfo: JourneyInfo?
    private let addressService: AddressService
    private weak var view: AddressBarView?
    private let userLocationProvider: UserLocationProvider
    private let addressScreenBuilder: AddressScreenBuilder
    private let datePickerScreenBuilder: DatePickerScreenBuilder

    init(bookingStatus: BookingStatus = KarhooBookingStatus.shared,
         journeyInfo: JourneyInfo? = nil,
         addressService: AddressService = Karhoo.getAddressService(),
         userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressScreenBuilder: AddressScreenBuilder = KarhooUI().screens().address(),
         datePickerScreenBuilder: DatePickerScreenBuilder = UISDKScreenRouting.default.datePicker()) {
        self.bookingStatus = bookingStatus
        self.journeyInfo = journeyInfo
        self.addressService = addressService
        self.userLocationProvider = userLocationProvider
        self.addressScreenBuilder = addressScreenBuilder
        self.datePickerScreenBuilder = datePickerScreenBuilder
        bookingStatus.add(observer: self)
    }

    deinit {
        bookingStatus.remove(observer: self)
    }

    func load(view: AddressBarView?) {
        self.view = view
        show(bookingDetails: bookingStatus.getBookingDetails())
    }

    func addressSelected(type: AddressType) {
        var searchBias: CLLocation?

        var typeSelected = type

        if typeSelected == .destination && bookingStatus.getBookingDetails()?.originLocationDetails == nil {
            typeSelected = .pickup
        }

        if case AddressType.pickup = typeSelected {
            searchBias = userLocationProvider.getLastKnownLocation()
        } else {
            searchBias = bookingStatus.getBookingDetails()?.originLocationDetails?.position.toCLLocation()
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
                bookingStatus.set(pickup: newOrigin)
            }
        case .destination:
            if let newDestination = result.completedValue() {
                bookingStatus.set(destination: newDestination)
            }
        }

        self.view?.parentViewController?.dismiss(animated: true, completion: nil)
    }

    func addressCleared(type: AddressType) {
        switch type {
        case .pickup: bookingStatus.set(pickup: nil)
        case .destination: bookingStatus.set(destination: nil)
        }
    }

    func prebookSelected() {
        guard let currentBookingDetails = bookingStatus.getBookingDetails(),
            let originTimeZone = bookingStatus.getBookingDetails()?.originLocationDetails?.timezone() else {
            return
        }

        let datePickerScreen = datePickerScreenBuilder
            .buildDatePickerScreen(startDate: currentBookingDetails.scheduledDate,
                                   timeZone: originTimeZone,
                                   callback: { [weak self] result in
                                    self?.view?.parentViewController?.dismiss(animated: true, completion: nil)
                                    self?.bookingStatus.set(prebookDate: result.completedValue())
        })

        datePickerScreen.modalPresentationStyle = .overCurrentContext
        
        view?.parentViewController?.present(datePickerScreen, animated: true, completion: nil)
    }

    func prebookCleared() {
        bookingStatus.set(prebookDate: nil)
    }

    func addressSwapSelected() {
        var swappedDetails = bookingStatus.getBookingDetails()?.reverse()
        pickupSet(locationInfo: swappedDetails?.originLocationDetails)
        destinationSet(locationInfo: swappedDetails?.destinationLocationDetails)
        swappedDetails?.scheduledDate = bookingStatus.getBookingDetails()?.scheduledDate

        show(bookingDetails: swappedDetails)
    }

    func bookingStateChanged(details: BookingDetails?) {
        show(bookingDetails: details)
    }

    private func pickupSet(locationInfo: LocationInfo?) {
        guard let pickup = locationInfo else {
            return
        }
        bookingStatus.set(pickup: pickup)
    }

    private func destinationSet(locationInfo: LocationInfo?) {
        guard let destination = locationInfo else {
            return
        }
        bookingStatus.set(destination: destination)
        view?.destinationSetState(disableClearButton: false)
    }

    private func show(bookingDetails: BookingDetails?) {
        setUpPickupState(locationInfo: bookingDetails?.originLocationDetails)
        setUpDestinationState(locationInfo: bookingDetails?.destinationLocationDetails)
        setUpPrebookState(date: bookingDetails?.scheduledDate)
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
        guard let originTimeZone = bookingStatus.getBookingDetails()?.originLocationDetails?.timezone() else {
            return
        }
        
        let timeZone = originTimeZone
        let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)
        view?.set(prebookDate: prebookFormatter.display(mediumStyleDate: date),
                  prebookTime: prebookFormatter.display(shortStyleTime: date))
    }
}
