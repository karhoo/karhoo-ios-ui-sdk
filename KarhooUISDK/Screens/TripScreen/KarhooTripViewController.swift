//
//  KarhooTripViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import CoreLocation
import KarhooSDK

public struct KHKarhooTripViewID {
    public static let closeButton = "close_button"
    public static let locateButton = "locate_button"
}
 
final class KarhooTripViewController: UIViewController, TripView {

    private var didSetupConstraints: Bool = false
    private var addressBar: KarhooAddressBarView!
    private var map: MapView!
    private var closeButton: UIButton!
    private var gradientView: GradientView!
    private var notificationView: KarhooNotificationView!
    private var tripDetailsView: TripScreenDetailsView!
    private var originEtaView: KarhooOriginEtaView!
    private var destinationEtaView: KarhooDestinationEtaView!
    private var locateButton: UIButton!
    private var loadingOverlayView: LoadingView!

    private var firstTimeLoading: Bool = true
    private let fadedAnimationTime = 0.5
    private let overlayAlphaValue: CGFloat = 0.6

    private let trip: TripInfo
    private let presenter: TripPresenter
    private let addressBarPresenter: TripAddressBarPresenter
    private let tripMapPresenter: TripMapPresenter

    init(trip: TripInfo,
         presenter: TripPresenter,
         addressBarPresenter: TripAddressBarPresenter,
         mapPresenter: TripMapPresenter) {
        self.trip = trip
        self.presenter = presenter
        self.addressBarPresenter = addressBarPresenter
        self.tripMapPresenter = mapPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        setUpView()
    }

    func currentTrip() -> TripInfo {
        return trip
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView = GradientView(gradient: KarhooGradients().whiteTopToBottomGradient())
        view.addSubview(gradientView)
        
        notificationView = KarhooNotificationView()
        view.addSubview(notificationView)
        
        closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.accessibilityIdentifier = KHKarhooTripViewID.closeButton
        closeButton.setImage(UIImage.uisdkImage("kh_uisdk_drop_down_arrow")
            .withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = KarhooUI.colors.darkGrey
        closeButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        addressBar = KarhooAddressBarView()
        addressBarPresenter.load(view: addressBar)
        addressBar.destinationSetState(disableClearButton: true)
        view.addSubview(addressBar)

        loadingOverlayView = LoadingView()
        loadingOverlayView.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlayView.set(loadingText: UITexts.Trip.tripCancellingActivityIndicatorText)
        loadingOverlayView.set(backgroundColor: KarhooUI.colors.darkGrey, alpha: overlayAlphaValue)
        view.addSubview(loadingOverlayView)
        
        map = KarhooMKMapView()
        map.set(actions: self)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.set(focusButtonHidden: true)
        view.insertSubview(map, at: 0)
        
        tripDetailsView = KarhooTripScreenDetailsView()
        view.addSubview(tripDetailsView)
        
        locateButton = UIButton(type: .custom)
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        locateButton.accessibilityIdentifier = KHKarhooTripViewID.locateButton
        locateButton.addTarget(self, action: #selector(locatePressed), for: .touchUpInside)
        locateButton.setImage(UIImage.uisdkImage("kh_uisdk_locate"), for: .normal)
        view.addSubview(locateButton)

        originEtaView = KarhooOriginEtaView()
        view.addSubview(originEtaView)
        
        destinationEtaView = KarhooDestinationEtaView()
        view.addSubview(destinationEtaView)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            _ = [view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                 view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)].map { $0.isActive = true }
            
            _ = [gradientView.topAnchor.constraint(equalTo: view.topAnchor),
                 gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 gradientView.heightAnchor.constraint(equalToConstant: 115.0)].map { $0.isActive = true }
            
            _ = [notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }
            
            let buttonSize: CGFloat = 28.0
            _ = [closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
                 closeButton.heightAnchor.constraint(equalToConstant: buttonSize),
                 closeButton.topAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 8.0),
                 closeButton.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor,
                                                      constant: 20.0)].map { $0.isActive = true }
            
            _ = [addressBar.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 18.0),
                 addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
                 addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -10.0)].map { $0.isActive = true }
            
            _ = [loadingOverlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 loadingOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 loadingOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 loadingOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
            
            _ = [map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 map.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
            
            let locateButtonSize: CGFloat = 46.0
            _ = [locateButton.widthAnchor.constraint(equalToConstant: locateButtonSize),
                 locateButton.heightAnchor.constraint(equalToConstant: locateButtonSize),
                 locateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
                 locateButton.bottomAnchor.constraint(equalTo: tripDetailsView.topAnchor,
                                                      constant: -20.0)].map { $0.isActive = true }
            
            _ = [originEtaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
                 originEtaView.bottomAnchor.constraint(equalTo: tripDetailsView.topAnchor,
                                                       constant: -20.0)].map { $0.isActive = true }
            
            _ = [destinationEtaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
                 destinationEtaView.bottomAnchor.constraint(equalTo: tripDetailsView.topAnchor,
                                                            constant: -20.0)].map { $0.isActive = true }
            
            _ = [tripDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                            constant: -10),
                 tripDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                 tripDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                             constant: 10)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load(view: self)
        tripDetailsView.set(actions: self,
                               detailsSuperview: self.view)
        
        forceLightMode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tripMapPresenter.load(
            map: map,
            onLocationPermissionDenied: { [weak self] in
                self?.showNoLocationPermissionsPopUp()
                self?.focusMapOnPickup()
            }
        )
        presenter.screenAppeared()
        originEtaView?.start(tripId: trip.tripId)
        destinationEtaView?.start(tripId: trip.tripId)

        setMapPadding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTimeLoading == true {
            firstTimeLoading = false
            presenter.screenDidLayoutSubviews()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        originEtaView?.stop()
        destinationEtaView?.stop()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.screenDidDisappear()
    }

    func userMovedMap() {
        presenter.userMovedMap()
    }

    func set(trip: TripInfo) {
        notificationView.change(title: TripInfoUtility.longDescription(trip: trip))
        tripDetailsView.updateViewModel(tripDetailsViewModel: TripScreenDetailsViewModel(trip: trip))
    }

    func update(driverLocation: CLLocation) {
        tripMapPresenter.updateDriver(location: driverLocation)
    }

    func showLoading() {
        loadingOverlayView?.show()
    }

    func hideLoading() {
        loadingOverlayView?.hide()
    }

    func plotPinsOnMap() {
        tripMapPresenter.plotPins()
    }

    func focusMapOnAllPOI() {
        tripMapPresenter.focusOnAllPOI()
    }


    func focusMapOnRoute() {
        tripMapPresenter.focusOnRoute()
    }

    func focusOnUserLocation() {
        tripMapPresenter.focusOnUserLocation()
    }

    func focusMapOnDriverAndPickup() {
        tripMapPresenter.focusOnPickupAndDriver()
    }

    func focusMapOnDriver() {
        tripMapPresenter.focusOnDriver()
    }
    
    func focusMapOnPickup() {
        tripMapPresenter.focusOnPickup()
    }

    func setAddressBar(with trip: TripInfo) {
        addressBar.set(pickupDisplayAddress: trip.origin.displayAddress)
        addressBar.set(destinationDisplayAddress: trip.destination?.displayAddress)
    }

    func set(locateButtonHidden: Bool) {
        locateButton?.isHidden = locateButtonHidden
    }

    func set(userMarkerVisible: Bool) {
        map.set(userMarkerVisible: userMarkerVisible)
    }

    @objc
    private func locatePressed() {
        presenter.locatePressed()
    }

    private func setMapPadding() {
        let topPadding = CGFloat(30)
        let sideMargin = CGFloat(15)
        let addressBarBottom = addressBar.frame.maxY
        let bottomPadding = tripDetailsView.frame.height
            + destinationEtaView!.frame.height
            + (topPadding + sideMargin)

        let padding = UIEdgeInsets(top: addressBarBottom + topPadding,
                                   left: sideMargin,
                                   bottom: bottomPadding,
                                   right: sideMargin)
        map.set(padding: padding)
    }

    func showNoLocationPermissionsPopUp() {
        let alertController = UIAlertController(
            title: UITexts.Booking.noLocationPermissionTitle,
            message: UITexts.Booking.noLocationPermissionMessage,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: UITexts.Booking.noLocationPermissionConfirm,
            style: .default,
            handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        ))
        alertController.addAction(UIAlertAction(title: UITexts.Generic.cancel, style: .cancel))
        showAsOverlay(item: alertController, animated: true)
    }

    @objc
    private func backButtonTapped() {
        presenter.userDidCloseTrip()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    final class KarhooTripScreenBuilder: TripScreenBuilder {
        func buildTripScreen(trip: TripInfo, callback: @escaping ScreenResultCallback<TripScreenResult>) -> Screen {
            let alertHandler = AlertHandler()

            let cancelRideBehaviour = CancelRideBehaviour(trip: trip, alertHandler: alertHandler)
            let presenter = KarhooTripPresenter(initialTrip: trip,
                                                cancelRideBehaviour: cancelRideBehaviour,
                                                callback: callback)

            let addressBarPresenter = KarhooTripAddressBarPresenter(trip: trip)

            let tripMapPresenter = KarhooTripMapPresenter(originAddress: trip.origin,
                                                                destinationAddress: trip.destination)

            let item = KarhooTripViewController(trip: trip,
                                                   presenter: presenter,
                                                   addressBarPresenter: addressBarPresenter,
                                                   mapPresenter: tripMapPresenter)

            alertHandler.set(viewController: item)

            return item
        }
    }
}

extension KarhooTripViewController: TripScreenDetailsActions {
    func contactDriver(_ phoneNumber: String) {
        presenter.contactDriver(phoneNumber)
    }
    
    func contactFleet(_ phoneNumber: String) {
        presenter.contactFleet(phoneNumber)
    }
    
    func cancelTrip() {
        presenter.cancelBookingPressed()
    }
    
    func tripDetailViewDidChangeSize() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.setMapPadding()
        })
    }
}

extension KarhooTripViewController: MapViewActions {
	func mapGestureDetected() {
        presenter.userMovedMap()
	}
}
