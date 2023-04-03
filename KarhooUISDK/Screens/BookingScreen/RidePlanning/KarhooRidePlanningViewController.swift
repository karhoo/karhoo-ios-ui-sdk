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
//    private var mapView: MapView = KarhooMKMapView()
//    private var mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter()

    private lazy var hostingController = UIHostingController(
        rootView: KarhooRidePlanningView(viewModel: KarhooRidePlanningViewModel())
    )
        .then {
            $0.loadViewIfNeeded()
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            $0.view.backgroundColor = .clear
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

//        setupMapView(reverseGeolocate: false)
//        mapView.set(userMarkerVisible: true)
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
        self.view = UIView()
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(mapView)
//        mapView.anchorToSuperview()
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.anchorToSuperview()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
        navigationItem.title = "Ride planning"
        navigationController?.set(style: .primary)
    }
    
//    private func setupMapView(reverseGeolocate: Bool) {
//        mapPresenter.load(
//            map: mapView,
//            reverseGeolocate: reverseGeolocate,
//            onLocationPermissionDenied: { // [weak self] in
//                // Do not show pop up when allocation view is visible
////                guard self?.tripAllocationView.alpha != 1 else {
////                    return
////                }
////                self?.showNoLocationPermissionsPopUp()
//            }
//        )
//        mapView.set(presenter: mapPresenter)
//    }
}
