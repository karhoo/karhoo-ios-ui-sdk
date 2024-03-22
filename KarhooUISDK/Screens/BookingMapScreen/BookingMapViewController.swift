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

final class KarhooBookingMapViewController: UIViewController, BookingMapScreen {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }
    
    // MARK: - Views
    private var presenter: BookingMapScreenPresenter!
    private var stackView: UIStackView!
    private var addressView: AddressBarView!
    private var mapView: MapView!
    private var bottomContainer: UIView!
    private var noCoverageView: NoCoverageView!
    private var asapButton: MainActionButton!
    private var scheduleButton: MainActionButton!
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
        mapView.set(userMarkerVisible: true)
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
        
        setupMapView()
        stackView.addArrangedSubview(mapView)
        
        setupBottomContainer()
        
        setupAddressBar()
        view.insertSubview(addressView, aboveSubview: stackView)
        
        addressView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: UIConstants.Spacing.standard
        ).isActive = true
        addressView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 10.0
        ).isActive = true
        addressView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10.0
        ).isActive = true
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
    
    // MARK: - Address
    private func setupAddressBar() {
        addressView = KarhooComponents.shared.addressBar(journeyInfo: journeyInfo)
    }
    
    // MARK: - Map
    private func setupMapView() {
        mapView = KarhooComponents.shared.mapView(
            journeyInfo: journeyInfo,
            onLocationPermissionDenied: { [weak self] in
            self?.showNoLocationPermissionsPopUp()
        })
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
    
    func focusMap() {
        mapView.focusMap()
    }
    
    // MARK: - Bottom container setup
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
        scheduleButton.addTarget(self, action: #selector(prebookRidePressed), for: .touchUpInside)
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
    
    private func updateBottomContainterVisiblity() {
        let shouldShow = presenter.isAsapEnabledPublisher.value ||
        presenter.isScheduleForLaterEnabledPublisher.value ||
        presenter.hasCoverageInTheAreaPublisher.value == false
        
        guard shouldShow != !bottomContainer.isHidden else {
            return
        }
        bottomContainer.isHidden = !shouldShow
    }
    
    // MARK: - Asap / prebook
    
    @objc private func asapRidePressed(_ selector: UIButton) {
        presenter.asapRidePressed()
    }
    
    @objc private func prebookRidePressed(_ selector: UIButton) {
        addressView.prebookSelected { [weak self] in
            self?.presenter.prebookRidePressed()
        }
    }
    
    // MARK: - Coverage
    private func setCoverageView(_ hasCoverage: Bool?) {
        noCoverageView.isHidden = hasCoverage ?? true
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
}
