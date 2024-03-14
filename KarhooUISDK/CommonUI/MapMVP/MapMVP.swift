//
//  MapMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import KarhooSDK
import UIKit

public protocol MapView: UIView {

    var standardZoom: Float { get }
    var idealMaximumZoom: Float { get }

    func set(actions: MapViewActions?)

    func set(presenter: MapPresenter)

    func set(padding: UIEdgeInsets)

    func set(userMarkerVisible: Bool)

    func getCenter() -> CLLocation?

    func center(on: CLLocation)

    func center(on: CLLocation, zoomLevel: Float)

    func zoomToDefaultLevel()

    func zoomToUserPosition(completion: @escaping (Bool) -> Void)

    func zoom(to: [CLLocation])

    func zoom(toLevel: Float)

    func addPin(annotation: MapAnnotationViewModel, tag: TripPinTags)

    func removePin(tag: TripPinTags)

    func movePin(tag: TripPinTags, to: CLLocation)

    func centerPin(hidden: Bool)

    func set(centerIcon: String, tintColor: UIColor)

    func addTripLine(pickup: CLLocation, dropoff: CLLocation)

    func draw(polyline: String)

    func remove(polyline: String)

    func zoom(toPolyline: String)

    func removeTripLine()

    func set(minimumZoom: Float, maximumZoom: Float)

	func set(focusButtonHidden: Bool)
}

/* optional MapView methods */
public extension MapView {
    func addTripLine(pickup: CLLocation, dropoff: CLLocation) {}
    
    func draw(polyline: String) {}

    func remove(polyline: String) {}

    func zoom(toPolyline: String) {}

    func removeTripLine() {}

    func set(minimumZoom: Float, maximumZoom: Float) {}
}

public protocol MapViewActions: AnyObject {

    func userStartedMovingTheMap()

    func userStoppedMovingTheMap(center: CLLocation?)

    func mapGestureDetected()
}

// Optional Map View action methods
public extension MapViewActions {

    func mapGestureDetected() {}

    func userStoppedMovingTheMap(center: CLLocation?) {}

    func userStartedMovingTheMap() {}
}

public protocol MapPresenter {
    func locatePressed()
	func focusMap()
}

public extension MapPresenter {
    func focusMap() {}
}

public protocol BookingMapPresenter: MapPresenter {
    func load(
        map: MapView?,
        reverseGeolocate: Bool,
        onLocationPermissionDenied: (() -> Void)?
    )
}

protocol TripMapPresenter: MapPresenter {
    func load(map: MapView?, onLocationPermissionDenied: (() -> Void)?)
    func focusOnAllPOI()
    func focusOnRoute()
    func focusOnPickup()
    func focusOnPickupAndDriver()
    func focusOnUserLocation()
    func focusOnDriver()
    func updateDriver(location: CLLocation)
    func plotPins()
}

protocol AddressMapPresenter: MapPresenter {
    func lastSelectedLocation() -> LocationInfo?
}
