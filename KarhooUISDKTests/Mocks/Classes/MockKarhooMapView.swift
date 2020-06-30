//
//  MockMapView.swift
//  Karhoo
//
//  Created by Yaser on 2017-04-26.
//  Copyright © 2017 Flit Technologies LTD. All rights reserved.
//

import UIKit
import CoreLocation

@testable import Karhoo

final class MockKarhooMapView: MapView {

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

    func getCenter() -> CLLocation? { return CLLocation() }

    var locationToCenterOn: CLLocation?
    func center(on: CLLocation) {
        locationToCenterOn = on
    }

    var locationToCenterOnZoom: CLLocation?
    var locationToCenterOnZoomLevel: Float?
    func center(on: CLLocation, zoomLevel: Float) {
        locationToCenterOnZoom = on
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

    var addedPins: [Int: CLLocation] = [:]
    func addPin(location: CLLocation, asset: String?, tag: MapView.TagType) {
        addedPins[tag] = location
    }

    var removedPins: [Int] = []
    func removePin(tag: Int) {
        removedPins.append(tag)
    }

    var movedPins: [Int: CLLocation] = [:]
    func movePin(tag: Int, to: CLLocation) {
        movedPins[tag] = to
    }

    var addCenterPinCalled = false
    func addCenterPin() {
        addCenterPinCalled = true
    }

    var removeCenterPinCalled = false
    func removeCenterPin() {
        removeCenterPinCalled = true
    }

    var addJourneyLineCalled = false
    func addJourneyLine(pickup: CLLocation, dropoff: CLLocation) {
        addJourneyLineCalled = true
    }

    var removeJourneyLineCalled = false
    func removeJourneyLine() {
        removeJourneyLineCalled = true
    }
}
