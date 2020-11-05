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

    typealias TagType = Int

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

    func addPin(location: CLLocation, asset: String?, tag: TagType, zIndex: Int32)

    func removePin(tag: Int)

    func movePin(tag: Int, to: CLLocation)

    func centerPin(hidden: Bool)

    func set(centerIcon: String)

    func addJourneyLine(pickup: CLLocation, dropoff: CLLocation)

    func draw(polyline: String)

    func remove(polyline: String)

    func zoom(toPolyline: String)

    func removeJourneyLine()

    func set(minimumZoom: Float, maximumZoom: Float)

	func set(focusButtonHidden: Bool)
}

/* optional MapView methods */
extension MapView {

    func addPin(location: CLLocation, asset: String?, tag: TagType, zIndex: Int32 = 1) {
        addPin(location: location, asset: asset, tag: tag, zIndex: zIndex)
    }

    func addJourneyLine(pickup: CLLocation, dropoff: CLLocation) {}
    
    func draw(polyline: String) {}

    func remove(polyline: String) {}

    func zoom(toPolyline: String) {}

    func removeJourneyLine() {}

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
