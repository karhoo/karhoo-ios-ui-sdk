//
//  MockMapView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import CoreLocation
@testable import KarhooUISDK

final class MockKarhooMapView: UIView, MapView {

    func set(presenter: MapPresenter) {}

    var standardZoom: Float {
        return 1
    }

    var idealMaximumZoom: Float {
        return 2
    }

    private(set) var centerIconSet: String?
    func set(centerIcon: String, tintColor: UIColor) {
        centerIconSet = centerIcon
    }

    var minimumZoomSet: Float?
    var maximumZoomSet: Float?
    func set(minimumZoom: Float, maximumZoom: Float) {
        minimumZoomSet = minimumZoom
        maximumZoomSet = maximumZoom
    }

    var actionsSet: MapViewActions?
    func set(actions: MapViewActions?) {
        actionsSet = actions
    }

    func set(padding: UIEdgeInsets) {}

    func set(userMarkerVisible: Bool) {}

    var focusButtonHiddenSet: Bool?
	func set(focusButtonHidden: Bool) {
        focusButtonHiddenSet = focusButtonHidden
    }

    func getCenter() -> CLLocation? { return CLLocation() }

    var locationToCenterOn: CLLocation?
    func center(on: CLLocation) {
        locationToCenterOn = on
    }

    var locationToCenterOnZoom: CLLocation?
    var locationToCenterOnZoomLevel: Float?
    func center(on: CLLocation, zoomLevel: Float) {
        locationToCenterOnZoom = on
        locationToCenterOn = on
        locationToCenterOnZoomLevel = zoomLevel
    }

    func draw(polyline: String) {}

    func remove(polyline: String) {}

    var zoomedToDefaultLevelCalled = false
    func zoomToDefaultLevel() {
        zoomedToDefaultLevelCalled = true
    }

    func zoom(toPolyline: String) {}

    var locationsToZoomTo: [CLLocation]?
    func zoom(to: [CLLocation]) {
        locationsToZoomTo = to
    }

    var levelToZoomTo: Float?
    func zoom(toLevel: Float) {
        levelToZoomTo = toLevel
    }

    var addedPins: [TripPinTags: CLLocationCoordinate2D] = [:]
    func addPin(annotation: KarhooMKAnnotation, tag: TripPinTags) {
        addedPins[tag] = annotation.coordinate
    }

    var removedPins: [TripPinTags] = []
    func removePin(tag: TripPinTags) {
        removedPins.append(tag)
    }

    var movedPins: [TripPinTags: CLLocation] = [:]
    func movePin(tag: TripPinTags, to: CLLocation) {
        movedPins[tag] = to
    }

    var centerPinHidden: Bool?
    func centerPin(hidden: Bool) {
        centerPinHidden = hidden
    }

    var addTripLineCalled = false
    func addTripLine(pickup: CLLocation, dropoff: CLLocation) {
        addTripLineCalled = true
    }

    var removeTripLineCalled = false
    func removeTripLine() {
        removeTripLineCalled = true
    }
}
