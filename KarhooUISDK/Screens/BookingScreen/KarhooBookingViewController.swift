//
//  BookingViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK
import CoreLocation
import SwiftUI
import Combine

final class KarhooBookingViewController: UIViewController, BookingView {

    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }

    private var cancellables: Set<AnyCancellable> = []

    private var addressBar: AddressBarView!
    private var addressBarPresenter: AddressBarPresenter!
    private var tripAllocationView: KarhooTripAllocationView!
    private var stackView: UIStackView!
    private var mapView: MapView = KarhooMKMapView()
    private var bottomContainer: UIView!
    private var noCoverageView: NoCoverageView!
    private var asapButton: MainActionButton!
    private var scheduleButton: MainActionButton!
    private var sideMenu: SideMenu?
    private var journeyInfo: JourneyInfo?
    private let presenter: BookingPresenter
    private let mapPresenter: BookingMapPresenter
    private let analyticsProvider: Analytics

    init(presenter: BookingPresenter,
         mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter(),
         analyticsProvider: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         journeyInfo: JourneyInfo? = nil) {
        self.presenter = presenter
        self.mapPresenter = mapPresenter
        self.analyticsProvider = analyticsProvider
        self.journeyInfo = journeyInfo
        super.init(nibName: nil, bundle: nil)
        self.setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
        setupMapView(reverseGeolocate: journeyInfo == nil)
        mapView.set(userMarkerVisible: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        sideMenu?.hideMenu()
        setupNavigationBar()
    }

    private func setUpView() {
        presenter.load(view: self)
        edgesForExtendedLayout = []
        mapView.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.spacing = 0
            $0.axis = .vertical
        }
        view.addSubview(stackView)
        stackView.anchorToSuperview()
        stackView.addArrangedSubview(mapView)
        
        setupBottomContainer()
        setupAddressBar()
        
        view.insertSubview(addressBar, aboveSubview: stackView)

        addressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.Spacing.standard).isActive = true
        addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
        addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -10.0).isActive = true
        
        tripAllocationView = KarhooTripAllocationView()
        tripAllocationView.set(actions: self)
        view.addSubview(tripAllocationView)
        _ = [tripAllocationView.topAnchor.constraint(equalTo: view.topAnchor),
             tripAllocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tripAllocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tripAllocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
    }
    
    private func setupMapView(reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: { [weak self] in
                // Do not show pop up when allocation view is visible
                guard self?.tripAllocationView.alpha != 1 else {
                    return
                }
                self?.showNoLocationPermissionsPopUp()
            }
        )
        mapView.set(presenter: mapPresenter)
    }

    private func setupAddressBar() {
        addressBarPresenter = BookingAddressBarPresenter()
        let addressBarView = KarhooAddressBarView(
            cornerRadious: UIConstants.CornerRadius.large,
            borderLine: true,
            dropShadow: false,
            verticalPadding: 0,
            horizontalPadding: 0,
            hidePickUpDestinationConnector: true,
            hidePrebookButton: true
        )

        addressBarView.set(presenter: addressBarPresenter)
        addressBarPresenter.load(view: addressBarView)
        
        addressBar = addressBarView
    }

    private func setupNavigationBar() {
        if navigationItem.leftBarButtonItem == nil {
            set(leftNavigationButton: .exitIcon)
        }
        if !(Karhoo.configuration.authenticationMethod().guestSettings != nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: UITexts.Generic.rides,
                style: .plain,
                target: self,
                action: #selector(rightBarButtonPressed)
            )
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.set(style: .primary)
        navigationItem.backButtonTitle = ""
    }

    private func setupBottomContainer() {
        // bottom container
        bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.backgroundColor = KarhooUI.colors.white
        bottomContainer.clipsToBounds = true
        stackView.addArrangedSubview(bottomContainer)

        bottomContainer.heightAnchor.constraint(equalToConstant: 100).then { $0.priority = .defaultLow }.isActive = true

        noCoverageView = NoCoverageView()
        noCoverageView.isHidden = true
        
        // asap button
        asapButton = MainActionButton(design: .secondary)
        asapButton.addTarget(self, action: #selector(asapRidePressed), for: .touchUpInside)
        asapButton.setTitle(UITexts.Generic.now.uppercased(), for: .normal)

        // later button
        scheduleButton = MainActionButton(design: .primary)
        scheduleButton.addTarget(self, action: #selector(scheduleForLaterPressed), for: .touchUpInside)
        scheduleButton.setTitle(UITexts.Generic.later.uppercased(), for: .normal)

        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.addArrangedSubviews([asapButton, scheduleButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = UIConstants.Spacing.standard
        buttonsStack.distribution = .fillEqually
        buttonsStack.heightAnchor.constraint(equalToConstant: UIConstants.Dimension.Button.mainActionButtonHeight).isActive = true

        let verticalStackView = UIStackView(arrangedSubviews: [noCoverageView, buttonsStack])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = UIConstants.Spacing.standard

        bottomContainer.addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: UIConstants.Spacing.standard).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: UIConstants.Spacing.standard).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -UIConstants.Spacing.standard).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.Spacing.standard).isActive = true

        presenter.isAsapEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAsapEnabled in
                self?.asapButton.setEnabled(isAsapEnabled)
                self?.updateBottomContainterVisiblity()
            }.store(in: &cancellables)

        presenter.isScheduleForLaterEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScheduleForLaterEnabled in
                self?.scheduleButton.setEnabled(isScheduleForLaterEnabled)
                self?.updateBottomContainterVisiblity()
            }.store(in: &cancellables)
        
        presenter.hasCoverageInTheAreaPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasCoverage in
                self?.setCoverageView(hasCoverage)
            }.store(in: &cancellables)
    }

    func reset() {
        presenter.resetJourneyDetails()
    }

    func resetAndLocate() {
        presenter.resetJourneyDetails()
        mapPresenter.focusMap()
    }

    func set(journeyDetails: JourneyDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.populate(with: journeyDetails)
        }
    }

    func showAllocationScreen(trip: TripInfo) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.addressBar.alpha = 0
						self?.mapView.set(focusButtonHidden: true)
            }, completion: nil)

        tripAllocationView?.presentScreen(forTrip: trip)

        let location = trip.origin.position.toCLLocation()
        mapView.center(on: location, zoomLevel: mapView.idealMaximumZoom)
        mapView.removeTripLine()
    }

    func hideAllocationScreen() {
        addressBar.alpha = 1
        tripAllocationView.dismissScreen()
    }

    func set(sideMenu: SideMenu) {
        self.sideMenu = sideMenu
    }

    func set(leftNavigationButton: NavigationBarItemIcon) {
        switch leftNavigationButton {
        case .exitIcon:
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage.uisdkImage("kh_uisdk_cross_new").withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self,
                action: #selector(leftBarButtonPressed)
            )
        case .menuIcon:
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(leftBarButtonPressed)
            )
        }
    }
    
    private func showNoLocationPermissionsPopUp() {
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
    
    func showIncorrectVersionPopup(completion: @escaping () -> Void) {
        showAlert(
            title: nil,
            message: UITexts.Errors.errorIncorrectSdkVersionMessage,
            error: nil,
            actions: [
                AlertAction(
                    title: UITexts.Generic.ok,
                    style: .default,
                    handler: { _ in completion() }
                )
            ]
        )
    }

    private func updateBottomContainterVisiblity() {
        let shouldShow = presenter.isAsapEnabledPublisher.value ||
        presenter.isScheduleForLaterEnabledPublisher.value ||
        presenter.hasCoverageInTheAreaPublisher.value == false
        
        guard shouldShow != !bottomContainer.isHidden else {
            return
        }
        bottomContainer.isHidden = !shouldShow
    }

    private func setCoverageView(_ hasCoverage: Bool?) {
        noCoverageView.isHidden = hasCoverage ?? true
    }

    @objc
    private func rightBarButtonPressed() {
        openRidesList(presentationStyle: nil)
    }

    @objc
    private func leftBarButtonPressed() {
        if let menu = sideMenu {
            menu.showMenu()
        } else {
            presenter.exitPressed()
        }
    }

    @objc private func asapRidePressed(_ selector: UIButton) {
        presenter.asapRidePressed()
    }

    @objc private func scheduleForLaterPressed(_ selector: UIButton) {
        addressBarPresenter.prebookSelected { [weak self] in
            self?.presenter.dataForScheduledRideProvided()
        }
    }
}

extension KarhooBookingViewController: TripAllocationActions {

    func userSuccessfullyCancelledTrip() {
        presenter.tripSuccessfullyCancelled()
        setupMapView(reverseGeolocate: true)
    }

    func tripAllocated(trip: TripInfo) {
        presenter.tripAllocated(trip: trip)
        setupMapView(reverseGeolocate: true)
    }

    func tripCancelledBySystem(trip: TripInfo) {
        presenter.tripCancelledBySystem(trip: trip)
        setupMapView(reverseGeolocate: true)
    }
    
    func tripDriverAllocationDelayed(trip: TripInfo) {
        presenter.tripDriverAllocationDelayed(trip: trip)
        setupMapView(reverseGeolocate: true)
    }
    
    func cancelTripFailed(error: KarhooError?,
                          trip: TripInfo) {
        presenter.tripCancellationFailed(trip: trip)
        setupMapView(reverseGeolocate: true)
    }

}

extension KarhooBookingViewController: BookingScreen {

    func openRidesList(presentationStyle: UIModalPresentationStyle?) {
        presenter.showRidesList(presentationStyle: presentationStyle)
    }

    func openTrip(_ trip: TripInfo) {
        presenter.goToTripView(trip: trip)
    }
    
    func openRideDetailsFor(_ trip: TripInfo) {
        presenter.showRideDetailsView(trip: trip)
    }
}

// MARK: Builder
public final class KarhooBookingScreenBuilder: BookingScreenBuilder {

    private let locationService: LocationService

    public init(locationService: LocationService = KarhooLocationService()) {
        self.locationService = locationService
    }
    
    public func buildBookingScreen(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        callback: ScreenResultCallback<BookingScreenResult>?
    ) -> Screen {
        KarhooPassengerInfo.shared.set(details: passengerDetails)
        
        var validatedJourneyInfo: JourneyInfo? {
            guard let origin = journeyInfo?.origin else {
                return nil
            }
            
            var isDateAllowed: Bool {
                guard let injectedDate = journeyInfo?.date else {
                    return false
                }
                return injectedDate >= Date().addingTimeInterval(60*60)
            }
            
            return JourneyInfo(
                origin: origin,
                destination: journeyInfo?.destination,
                date: isDateAllowed ? journeyInfo?.date : nil
            )
        }
        KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: validatedJourneyInfo)

        let router = KarhooBookingRouter()
        let bookingPresenter = KarhooBookingPresenter(
            router: router,
            callback: callback
        )
        let bookingViewController = KarhooBookingViewController(
            presenter: bookingPresenter,
            journeyInfo: validatedJourneyInfo
        )
        router.viewController = bookingViewController
        router.checkoutScreenBuilder = UISDKScreenRouting.default.checkout()

        let navigationController = NavigationController(rootViewController: bookingViewController, style: .primary)

        if let sideMenuRouting = KarhooUI.sideMenuHandler {
            let sideMenu = UISDKScreenRouting
                .default.sideMenu().buildSideMenu(
                    hostViewController: bookingViewController,
                    routing: sideMenuRouting
                )
            bookingViewController.set(sideMenu: sideMenu)
            bookingViewController.set(leftNavigationButton: .menuIcon)
        } else {
            bookingViewController.set(leftNavigationButton: .exitIcon)
        }
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}

class MockSideMenuHandler: SideMenuHandler {
    func showProfile(onViewController viewController: UIViewController) {
        print("showProfile")
    }
    
    func showBookingsList(onViewController viewController: UIViewController) {
    }
    
    func showAbout(onViewController viewController: UIViewController) {
    }
    
    func showHelp(onViewController viewController: UIViewController) {
    }
}
