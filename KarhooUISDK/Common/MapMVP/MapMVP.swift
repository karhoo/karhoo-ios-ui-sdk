//
//  MapMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import UIKit
import KarhooSDK

protocol MapView: UIView {

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

    func zoom(to: [CLLocation])

    func zoom(toLevel: Float)

    func addPin(annotation: KarhooMKAnnotation, tag: TripPinTags)

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
extension MapView {
    func addTripLine(pickup: CLLocation, dropoff: CLLocation) {}
    
    func draw(polyline: String) {}

    func remove(polyline: String) {}

    func zoom(toPolyline: String) {}

    func removeTripLine() {}

    func set(minimumZoom: Float, maximumZoom: Float) {}
}

protocol MapViewActions: AnyObject {

    func userStartedMovingTheMap()

    func userStoppedMovingTheMap(center: CLLocation?)

    func mapGestureDetected()
}

// Optional Map View action methods
extension MapViewActions {

    func mapGestureDetected() {}

    func userStoppedMovingTheMap(center: CLLocation?) {}

    func userStartedMovingTheMap() {}
}

protocol MapPresenter {
	func focusMap()
}

extension MapPresenter {
    func focusMap() {}
}

protocol BookingMapPresenter: MapPresenter {
    func load(map: MapView?, reverseGeolocate: Bool)
}

protocol TripMapPresenter: MapPresenter {
    func load(map: MapView?)
    func focusOnRoute()
    func focusOnPickupAndDriver()
    func focusOnDestinationAndDriver()
    func updateDriver(location: CLLocation)
    func plotPins()
}

protocol AddressMapPresenter: MapPresenter {
    func lastSelectedLocation() -> LocationInfo?
}
