//
//  KarhooBookingViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Combine
import CoreLocation
import KarhooSDK
import SwiftUI
import UIKit

final class KarhooBookingViewController: UIViewController, BookingView {

    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }

    private var cancellables: Set<AnyCancellable> = []

    private var tripAllocationView: KarhooTripAllocationView!
    private var stackView: UIStackView!
    private var sideMenu: SideMenu?
    private var journeyInfo: JourneyInfo?
    private let presenter: BookingPresenter
    private let analyticsProvider: Analytics
    private var bookingMapView: BookingMapView!

    init(presenter: BookingPresenter,
         analyticsProvider: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         journeyInfo: JourneyInfo? = nil) {
        self.presenter = presenter
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

        stackView = UIStackView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.spacing = 0
            $0.axis = .vertical
        }
        view.addSubview(stackView)
        stackView.anchorToSuperview()
        
        bookingMapView = KarhooBookingMapView(
            journeyInfo: journeyInfo,
            onAsapRidePressed: { [weak self] in
                self?.presenter.asapRidePressed()
            },
            onPrebookRidePressed: { [weak self] in
                self?.presenter.dataForScheduledRideProvided()
            },
            onLocationPermissionDenied: { [weak self] in
                guard self?.tripAllocationView.alpha != 1 else {
                    return
                }
                self?.showNoLocationPermissionsPopUp()
            }).then {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        stackView.addArrangedSubview(bookingMapView)
        
        presenter.isAsapEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAsapEnabled in
                self?.bookingMapView.set(asapButtonEnabled: isAsapEnabled)
                self?.updateBottomContainterVisiblity()
            }.store(in: &cancellables)

        presenter.isScheduleForLaterEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScheduleForLaterEnabled in
                self?.bookingMapView.set(prebookButtonEnabled: isScheduleForLaterEnabled)
                self?.updateBottomContainterVisiblity()
            }.store(in: &cancellables)

        presenter.hasCoverageInTheAreaPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasCoverage in
                self?.setCoverageView(hasCoverage)
            }.store(in: &cancellables)
        
        tripAllocationView = KarhooTripAllocationView()
        tripAllocationView.set(actions: self)
        view.addSubview(tripAllocationView)
        _ = [tripAllocationView.topAnchor.constraint(equalTo: view.topAnchor),
             tripAllocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tripAllocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tripAllocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
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

    func reset() {
        presenter.resetJourneyDetails()
    }

    func resetAndLocate() {
        presenter.resetJourneyDetails()
        bookingMapView.focusMap()
    }

    func set(journeyDetails: JourneyDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.populate(with: journeyDetails)
        }
    }

    func showAllocationScreen(trip: TripInfo) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
            self?.bookingMapView.set(addressBarVisible: false)
            self?.bookingMapView.set(focusButtonVisible: false)
            }, completion: nil)

        tripAllocationView?.presentScreen(forTrip: trip)

        let location = trip.origin.position.toCLLocation()
        bookingMapView.prepareForAllocation(location: location)
    }

    func hideAllocationScreen() {
        bookingMapView.set(addressBarVisible: true)
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
            let accessibilityText = "\(UITexts.Accessibility.crossIcon), \(UITexts.Accessibility.closeScreen)"
            navigationItem.leftBarButtonItem?.accessibilityLabel = accessibilityText
        case .menuIcon:
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: UITexts.SideMenu.signOut,
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
        
        bookingMapView.set(bottomContainterVisible: shouldShow)
    }

    private func setCoverageView(_ hasCoverage: Bool?) {
        bookingMapView.set(coverageViewVisible: hasCoverage ?? true)
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
}

extension KarhooBookingViewController: TripAllocationActions {

    func userSuccessfullyCancelledTrip() {
        presenter.tripSuccessfullyCancelled()
        bookingMapView.set(reverseGeolocate: true)
    }

    func tripAllocated(trip: TripInfo) {
        presenter.tripAllocated(trip: trip)
        bookingMapView.set(reverseGeolocate: true)
    }

    func tripCancelledBySystem(trip: TripInfo) {
        presenter.tripCancelledBySystem(trip: trip)
        bookingMapView.set(reverseGeolocate: true)
    }
    
    func tripDriverAllocationDelayed(trip: TripInfo) {
        presenter.tripDriverAllocationDelayed(trip: trip)
        bookingMapView.set(reverseGeolocate: true)
    }
    
    func cancelTripFailed(error: KarhooError?,
                          trip: TripInfo) {
        presenter.tripCancellationFailed(trip: trip)
        bookingMapView.set(reverseGeolocate: true)
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
        
        let validatedJourneyInfo = journeyInfo.validatedOrNilJourneyInfo
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
