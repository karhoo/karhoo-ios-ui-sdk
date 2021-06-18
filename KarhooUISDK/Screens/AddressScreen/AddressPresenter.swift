//
//  KarhooAddressPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK

final class KarhooAddressPresenter: AddressPresenter {

    internal let addressMode: AddressType
    private let selectionCallback: ScreenResultCallback<LocationInfo>
    private var searchProvider: AddressSearchProvider
    private var userLocationProvider: UserLocationProvider
    private let addressService: AddressService
    private let analytics: Analytics
    private let recentAddressProvider: RecentAddressProvider
    private weak var addressView: AddressView?
    private let locationService: LocationService

    private let searchDelay: Double
    private var currentSeachString: String = ""
    private static let sessionToken = UUID().uuidString
    private var reverseGeocodingCurrentLocation = false

    init(preferredLocation: CLLocation?,
         addressMode: AddressType,
         selectionCallback: @escaping ScreenResultCallback<LocationInfo>,
         searchProvider: AddressSearchProvider = KarhooAddressSearchProvider(),
         userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressService: AddressService = Karhoo.getAddressService(),
         analytics: Analytics = KarhooAnalytics(),
         recentAddressProvider: RecentAddressProvider = KarhooRecentAddressProvider(),
         searchDelay: Double = 0.5,
         locationService: LocationService = KarhooLocationService()) {
        
        self.selectionCallback = selectionCallback
        self.searchProvider = searchProvider
        self.userLocationProvider = userLocationProvider
        self.addressService = addressService
        self.addressMode = addressMode
        self.analytics = analytics
        self.recentAddressProvider = recentAddressProvider
        self.searchDelay = searchDelay
        self.searchProvider.sessionToken = KarhooAddressPresenter.sessionToken
        self.locationService = locationService
        searchProvider.set(delegate: self)
        searchProvider.set(preferredLocation: preferredLocation)
    }

    func set(view: AddressView?) {
        self.addressView = view
    }

    func viewWillShow() {
        configureFor(mode: addressMode)
        if currentSeachString == "" {
            searchProvider.fetchDefaultValues()
        }
        addressView?.focusInputField()
    }

    func search(text: String?) {
        performDelayedSearch(text: text ?? "")
    }

    private func performDelayedSearch(text: String) {
        currentSeachString = text

        DispatchQueue.global().asyncAfter(deadline: .now() + searchDelay) { [weak self] in
            guard self?.currentSeachString == text else {
                  return
              }

            DispatchQueue.main.async { [weak self] in
                self?.searchProvider.search(for: text)
            }
        }
    }

    private func locationResponseHandler(_ result: Result<LocationInfo>, saveLocation: Bool) {
        switch result {
        case .success(let locationInfo):
            if saveLocation {
                recentAddressProvider.add(recent: locationInfo.toAddress())
            }
            locationDetailsSelected(details: locationInfo)
        case .failure(let error):
            addressView?.focusInputField()
            addressView?.show(error: error)
        }
    }
    
    func selected(address: AddressCellViewModel) {
        addressView?.unfocusInputField()

        let locationInfoSearch = LocationInfoSearch(placeId: address.placeId,
                                                    sessionToken: KarhooAddressPresenter.sessionToken)

        addressService.locationInfo(locationInfoSearch: locationInfoSearch).execute(callback: { [weak self] result in
            self?.locationResponseHandler(result, saveLocation: true)
        })
    }

    func addressMapViewSelected(location: LocationInfo) {
        addressView?.unfocusInputField()
        recentAddressProvider.add(recent: location.toAddress())
        locationDetailsSelected(details: location)
    }

    private func locationDetailsSelected(details: LocationInfo) {
        
        switch addressMode {
        case .pickup:
            analytics.pickupAddressSelected(details)
        case .destination:
            analytics.destinationAddressSelected(details)
        }
        
        finishWithResult(.completed(result: details))
    }

    func close() {
        finishWithResult(.cancelled(byUser: true))
    }

    func clearSearch() {
        search(text: "")
        addressView?.hideEmptyDataSet()
        addressView?.clearSearchInputField()
        addressView?.hideLoadingIndicator()
    }

    private func configureFor(mode: AddressType?) {
        if mode == .pickup {
            addressView?.set(title: UITexts.Generic.pickup)
            addressView?.set(mapPickerIcon: .mapPickUp)
        } else {
            addressView?.set(title: UITexts.Generic.destination)
            addressView?.set(mapPickerIcon: .mapDropOff)
        }
    }

    private func finishWithResult(_ result: ScreenResult<LocationInfo>) {
        selectionCallback(result)
    }
    
    public func getCurrentLocation() {
        analytics.userPressedCurrentLocation(addressType: String(describing: addressMode))
        guard let location = userLocationProvider.getLastKnownLocation()?.coordinate,
              reverseGeocodingCurrentLocation == false else { return }
        reverseGeocodingCurrentLocation = true
        addressService.reverseGeocode(position: Position(latitude: location.latitude,
                                                         longitude: location.longitude)).execute { [weak self] result in
                                                            
            self?.locationResponseHandler(result, saveLocation: false)
            self?.reverseGeocodingCurrentLocation = false
        }
    }
    
    public func checkLocationPermissions() {
        if locationService.locationAccessEnabled() == true {
            addressView?.buildAddressMapView()
        } else {
            addressView?.disableLocationOptions()
        }
    }
}

extension KarhooAddressPresenter: AddressSearchProviderDelegate {

    func searchCompleted(places: [Place]) {
        
        switch addressMode {
        case .pickup:
            analytics.pickupAddressDisplayed(count: places.count)
        case .destination:
            analytics.destinationAddressDisplayed(count: places.count)
        }
      
        if places.isEmpty {
            addressView?.show(emptyDataSetMessage: UITexts.AddressScreen.noResultsFound)
        } else {
            let cells = places.map({AddressCellViewModel(place: $0) })
            let sortedCells = cells.sorted(by: { $0.iconImageName < $1.iconImageName })
            addressView?.set(cells: sortedCells)
            
            addressView?.hideLoadingIndicator()
            addressView?.hideEmptyDataSet()
        }
    }

    func useDefaultAddresses(recents: [Address]) {
        if recents.isEmpty {
            addressView?.show(emptyDataSetMessage: UITexts.AddressScreen.noRecentAddresses)
        } else {
            addressView?.hideEmptyDataSet()
            
            let cells = recents.map { AddressCellViewModel(address: $0) }
            addressView?.set(cells: cells)
        }
    }

    func searchInProgress() {
        addressView?.showLoadingIndicator()
    }

    func searchFailed(error: KarhooError?) {
        if error?.type == .couldNotAutocompleteAddress {
            addressView?.show(emptyDataSetMessage: UITexts.Errors.noResultsFound)
        } else {
            addressView?.hideEmptyDataSet()
        }

        addressView?.hideLoadingIndicator()
    }
}
