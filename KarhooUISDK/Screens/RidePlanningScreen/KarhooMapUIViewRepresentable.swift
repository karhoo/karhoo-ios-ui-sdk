//
//  KarhooMapUIViewRepresentable.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct KarhooRepresentedMapView: UIViewRepresentable, RepresentedMapView {
    typealias UIViewType = KarhooMKMapView
    
    // MARK: - Properties
    
    var mapPresenter: BookingMapPresenter
    var journeyDetails: JourneyDetails?
    
    var locationPersissionDeniedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init(
        mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter(),
        journeyDetails: JourneyDetails? = KarhooJourneyDetailsManager.shared.getJourneyDetails()
    ) {
        self.mapPresenter = mapPresenter
        self.journeyDetails = journeyDetails
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> KarhooMKMapView {
        let myView = KarhooMKMapView()
        setupMapView(myView, reverseGeolocate: journeyDetails == nil)
        return myView
    }

    func updateUIView(_ uiView: KarhooMKMapView, context: Context) {
    }

    // MARK: - Helpers
    
    private func setupMapView(_ mapView: KarhooMKMapView, reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: {
                self.locationPersissionDeniedSubject.send()
            }
        )
        mapView.set(presenter: mapPresenter)
    }
}
