//
//  KarhooRidePlanningViewController.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 31.03.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import SwiftUI
import KarhooSDK
import CoreLocation

public class KarhooRidePlanningViewController: UIViewController {
    private var mapView: MapView = KarhooMKMapView()
    private var mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter()

    private lazy var hostingController = UIHostingController(rootView: KarhooRidePlanningView()).then {
        $0.loadViewIfNeeded()
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.view.backgroundColor = .clear
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView(reverseGeolocate: false)
        mapView.set(userMarkerVisible: true)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        
    }
    
    private func setupView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view = UIView()
        self.view.setDimensions(height: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width)
        self.view.addSubview(mapView)
        mapView.anchorToSuperview()
        self.view.addSubview(hostingController.view)
        hostingController.view.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
    
    private func setupMapView(reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: { // [weak self] in
                // Do not show pop up when allocation view is visible
//                guard self?.tripAllocationView.alpha != 1 else {
//                    return
//                }
//                self?.showNoLocationPermissionsPopUp()
            }
        )
        mapView.set(presenter: mapPresenter)
    }
}
