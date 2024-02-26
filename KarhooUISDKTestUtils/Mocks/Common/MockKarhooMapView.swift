//
//  MockKarhooMapView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import UIKit
@testable import KarhooUISDK

final public class MockKarhooMapView: UIView, MapView {

    public func set(presenter: MapPresenter) {}

    public var standardZoom: Float {
        return 1
    }

    public var idealMaximumZoom: Float {
        return 2
    }

    public var centerIconSet: String?
    public func set(centerIcon: String, tintColor: UIColor) {
        centerIconSet = centerIcon
    }

    public var minimumZoomSet: Float?
    public var maximumZoomSet: Float?
    public func set(minimumZoom: Float, maximumZoom: Float) {
        minimumZoomSet = minimumZoom
        maximumZoomSet = maximumZoom
    }

    public var actionsSet: MapViewActions?
    public func set(actions: MapViewActions?) {
        actionsSet = actions
    }

    public func set(padding: UIEdgeInsets) {}

    public func set(userMarkerVisible: Bool) {}

    public var focusButtonHiddenSet: Bool?
	public func set(focusButtonHidden: Bool) {
        focusButtonHiddenSet = focusButtonHidden
    }

    public func getCenter() -> CLLocation? { return CLLocation() }

    public var locationToCenterOn: CLLocation?
    public func center(on: CLLocation) {
        locationToCenterOn = on
    }

    public var locationToCenterOnZoom: CLLocation?
    public var locationToCenterOnZoomLevel: Float?
    public func center(on: CLLocation, zoomLevel: Float) {
        locationToCenterOnZoom = on
        locationToCenterOn = on
        locationToCenterOnZoomLevel = zoomLevel
    }

    public func draw(polyline: String) {}

    public func remove(polyline: String) {}

    public var zoomedToDefaultLevelCalled = false
    public func zoomToDefaultLevel() {
        zoomedToDefaultLevelCalled = true
    }

    public func zoom(toPolyline: String) {}

    public var locationsToZoomTo: [CLLocation]?
    public func zoom(to: [CLLocation]) {
        locationsToZoomTo = to
    }

    public var zoomToUserPositionToReturn = true
    public func zoomToUserPosition(completion: @escaping (Bool) -> Void) {
        completion(zoomToUserPositionToReturn)
    }

    public var levelToZoomTo: Float?
    public func zoom(toLevel: Float) {
        levelToZoomTo = toLevel
    }

    public var addedPins: [TripPinTags: CLLocationCoordinate2D] = [:]
    public func addPin(annotation: MapAnnotationViewModel, tag: TripPinTags) {
        addedPins[tag] = annotation.coordinate
    }

    public var removedPins: [TripPinTags] = []
    public func removePin(tag: TripPinTags) {
        removedPins.append(tag)
    }

    public var movedPins: [TripPinTags: CLLocation] = [:]
    public func movePin(tag: TripPinTags, to: CLLocation) {
        movedPins[tag] = to
    }

    public var centerPinHidden: Bool?
    public func centerPin(hidden: Bool) {
        centerPinHidden = hidden
    }

    public var addTripLineCalled = false
    public func addTripLine(pickup: CLLocation, dropoff: CLLocation) {
        addTripLineCalled = true
    }

    public var removeTripLineCalled = false
    public func removeTripLine() {
        removeTripLineCalled = true
    }
}
