//
//  KarhooMKMapView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public struct KHMapViewID {
	public static let locateButtonIdentifier = "locate_button"
}

final class KarhooMKMapView: UIView, MapView, UIGestureRecognizerDelegate {

    var standardZoom: Float {
        return 0.009
    }

    var idealMaximumZoom: Float {
        return 0.075
    }

    private let centerIcon = UIImageView(image: UIImage.uisdkImage("pickup_pin"))
    private var mapView: MKMapView = MKMapView()
    private var mapViewActions: MapViewActions?
    private var pins: [MapView.TagType: KarhooMKAnnotation] = [:]
    private var presenter: MapPresenter?
    private let focusButtonBottomSpace: CGFloat = -20
    private var focusButtonBottomConstraint: NSLayoutConstraint!

    private var focusButton: UIButton = {
        var button = UIButton(type: .custom)
        button.accessibilityIdentifier = KHMapViewID.locateButtonIdentifier
        button.setImage(UIImage.uisdkImage("locate"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    private func setupView() {
        mapView.delegate = self
        mapView.isRotateEnabled = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        centerIcon.translatesAutoresizingMaskIntoConstraints = false
        centerIcon.isAccessibilityElement = true
        focusButton.addTarget(self, action: #selector(locatePressed), for: .touchUpInside)

        addSubview(mapView)
        mapView.addSubview(centerIcon)
        addSubview(focusButton)
        NSLayoutConstraint.activate([
              mapView.widthAnchor.constraint(equalTo: widthAnchor),
              mapView.heightAnchor.constraint(equalTo: heightAnchor),
              mapView.centerXAnchor.constraint(equalTo: centerXAnchor),
              mapView.centerYAnchor.constraint(equalTo: centerYAnchor),

              centerIcon.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: 95.0),
              centerIcon.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
              centerIcon.widthAnchor.constraint(equalToConstant: 35.0),
              centerIcon.heightAnchor.constraint(equalToConstant: 45.0),

              focusButton.heightAnchor.constraint(equalToConstant: 45),
              focusButton.widthAnchor.constraint(equalToConstant: 45),
              focusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
          ])

        focusButtonBottomConstraint = focusButton.bottomAnchor.constraint(equalTo: bottomAnchor,
																		  constant: -mapView.layoutMargins.bottom + focusButtonBottomSpace)
        focusButtonBottomConstraint.isActive = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func locatePressed() {
		presenter?.focusMap()
    }

	func set(presenter: MapPresenter) {
        self.presenter = presenter
	}

	func set(focusButtonHidden: Bool) {
        focusButton.isHidden = focusButtonHidden
	}

    func set(actions: MapViewActions?) {
        mapViewActions = actions
    }

    func set(padding: UIEdgeInsets) {
        mapView.layoutMargins = padding
        focusButtonBottomConstraint.constant = -mapView.layoutMargins.bottom + focusButtonBottomSpace
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    func set(userMarkerVisible: Bool) {
        mapView.showsUserLocation = userMarkerVisible
    }

    func getCenter() -> CLLocation? {
        return CLLocation(latitude: mapView.region.center.latitude,
                          longitude: mapView.region.center.longitude)
    }

    func center(on: CLLocation) {
        center(on: on, zoomLevel: standardZoom)
    }

    func center(on: CLLocation, zoomLevel: Float) {
        let span = MKCoordinateSpan(latitudeDelta: Double(zoomLevel), longitudeDelta: Double(zoomLevel))
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: on.coordinate.latitude,
                                                                       longitude: on.coordinate.longitude),
                                        span: span)

        mapView.setRegion(region, animated: true)
    }

    func zoomToDefaultLevel() {
        zoom(toLevel: standardZoom)
    }

    func zoom(to: [CLLocation]) {
        let annotations: [MKPointAnnotation] = to.map {
            let annotation = MKPointAnnotation()
            annotation.coordinate = $0.coordinate
            return annotation
        }

        mapView.showAnnotations(annotations, animated: true)
    }

    func zoom(toLevel: Float) {
        let span = MKCoordinateSpan(latitudeDelta: Double(toLevel), longitudeDelta: Double(toLevel))
        let region = MKCoordinateRegion(center: mapView.region.center, span: span)
        mapView.setRegion(region, animated: true)
    }

    func addPin(location: CLLocation, asset: String?, tag: MapView.TagType, zIndex: Int32) {
        let annotation = KarhooMKAnnotation(coordinate: location.coordinate, icon: UIImage.uisdkImage(asset ?? ""))

        pins[tag] = annotation
        mapView.addAnnotation(annotation)
    }

    func removePin(tag: Int) {
        guard let pinToRemove = pins[tag] else {
            return
        }
        mapView.removeAnnotation(pinToRemove)
        pins.removeValue(forKey: tag)
    }

    func movePin(tag: Int, to: CLLocation) {
        let annotation = pins[tag]
        annotation?.coordinate = to.coordinate
    }

    func centerPin(hidden: Bool) {
        centerIcon.isHidden = hidden
    }

    func addTripLine(pickup: CLLocation, dropoff: CLLocation) {
        removeTripLine()

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickup.coordinate,
                                                          addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dropoff.coordinate,
                                                               addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, _ in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
    }

    func removeTripLine() {
        mapView.removeOverlays(mapView.overlays)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func set(centerIcon: String) {
        self.centerIcon.image = UIImage.uisdkImage(centerIcon)
    }

    private var mapDragged = false
    @objc private func didDragMap(_ sender: UIGestureRecognizer) {
        mapDragged = true
    }
}

extension KarhooMKMapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapViewActions?.userStartedMovingTheMap()
        mapViewActions?.mapGestureDetected()
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapDragged {
            mapViewActions?.userStoppedMovingTheMap(center: CLLocation(latitude: mapView.region.center.latitude,
                                                                       longitude: mapView.region.center.longitude))
            mapDragged = false
        }

    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
       let customAnnotation = annotation as? KarhooMKAnnotation
       view.image = customAnnotation?.icon
       return view
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: (overlay as? MKPolyline)!)
        renderer.strokeColor = KarhooUI.colors.secondary
        renderer.lineWidth = 3
        return renderer
      }
}
