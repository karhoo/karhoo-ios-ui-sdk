//
//  BookingMapViewController.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 20.03.2024.
//  Copyright © 2024 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import KarhooSDK
import UIKit

final class KarhooBookingMapViewController: UIViewController, BookingMapScreen {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }
    
    // MARK: - Views
    private var presenter: BookingMapScreenPresenter!
    private var stackView: UIStackView!
    private var bookingMapView: BookingMapView!
    private var journeyInfo: JourneyInfo?
    private let analyticsProvider: Analytics
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(
        presenter: BookingMapScreenPresenter = KarhooBookingMapScreenPresenter(),
        analyticsProvider: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        journeyInfo: JourneyInfo? = nil
    ) {
        self.presenter = presenter
        self.analyticsProvider = analyticsProvider
        self.journeyInfo = journeyInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        forceLightMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        setupNavigationBar()
    }
    
    // MARK: - Setup View
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
                self?.presenter.prebookRidePressed()
            },
            onLocationPermissionDenied: { [weak self] in
                self?.showNoLocationPermissionsPopUp()
            }).then {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        stackView.addArrangedSubview(bookingMapView)
        
        setupPublishers()
    }
    
    private func setupPublishers() {
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
    }
    
    // MARK: - Navigation bar
    private func setupNavigationBar() {
        if navigationItem.leftBarButtonItem == nil {
            setLeftNavigationButton()
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
    
    private func setLeftNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.uisdkImage("kh_uisdk_cross_new").withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(leftBarButtonPressed)
        )
        let accessibilityText = "\(UITexts.Accessibility.crossIcon), \(UITexts.Accessibility.closeScreen)"
        navigationItem.leftBarButtonItem?.accessibilityLabel = accessibilityText
    }
    
    @objc
    private func leftBarButtonPressed() {
        presenter.exitPressed()
    }
    
    @objc
    private func rightBarButtonPressed() {
        openRidesList(presentationStyle: nil)
    }
    
    func openRidesList(presentationStyle: UIModalPresentationStyle?) {
        presenter.showRidesList(presentationStyle: presentationStyle)
    }
    
    // MARK: - Map
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
    
    func focusMap() {
        bookingMapView.focusMap()
    }
    
    // MARK: - Bottom container
    private func updateBottomContainterVisiblity() {
        let shouldShow = presenter.isAsapEnabledPublisher.value ||
        presenter.isScheduleForLaterEnabledPublisher.value ||
        presenter.hasCoverageInTheAreaPublisher.value == false

        bookingMapView.set(bottomContainterVisible: shouldShow)
    }
    
    // MARK: - Coverage
    private func setCoverageView(_ hasCoverage: Bool?) {
        bookingMapView.set(coverageViewVisible: hasCoverage ?? true)
    }
    
    // MARK: - Utils
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
    
    // MARK: - Allocation
    func prepareForAllocation(with trip: TripInfo) {
        DispatchQueue.main.async {
            self.bookingMapView.set(addressBarVisible: false)
            self.bookingMapView.set(focusButtonVisible: false)
            self.presenter.isAsapEnabledPublisher.send(false)
            self.presenter.isScheduleForLaterEnabledPublisher.send(false)
            self.presenter.hasCoverageInTheAreaPublisher.send(nil)
        }
        
        let location = trip.origin.position.toCLLocation()
        self.bookingMapView.prepareForAllocation(location: location)
    }
    
    func resetPrepareForAllocation() {
        DispatchQueue.main.async {
            self.bookingMapView.set(addressBarVisible: true)
            self.bookingMapView.set(focusButtonVisible: true)
        }
        KarhooJourneyDetailsManager.shared.reset()
    }
}
