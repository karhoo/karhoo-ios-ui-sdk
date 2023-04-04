//
//  KarhooMapUIViewRepresentable.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct RepresentedMapView: UIViewRepresentable {
    typealias UIViewType = KarhooMKMapView
    var mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter()
    var onLocationPermissionDenied: () -> Void
    
    func makeUIView(context: Context) -> KarhooMKMapView {
        let myView = KarhooMKMapView()
        setupMapView(myView, reverseGeolocate: getJourneyDetails() == nil)
        return myView
    }

    func updateUIView(_ uiView: KarhooMKMapView, context: Context) {
    }

    private func setupMapView(_ mapView: KarhooMKMapView, reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: {
                self.onLocationPermissionDenied()
            }
        )
        mapView.set(presenter: mapPresenter)
    }

    private func getJourneyDetails() -> JourneyDetails? {
        return KarhooJourneyDetailsManager.shared.getJourneyDetails()
    }
}
