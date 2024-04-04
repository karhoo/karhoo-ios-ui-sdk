//
//  BookingMapView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.04.2024.
//  Copyright © 2024 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine

final class KarhooBookingMapView: UIStackView, BookingMapView {
    
    private var addressView: AddressBarView!
    private var mapView: MapView!
    private var bottomContainer: UIView!
    private var noCoverageView: NoCoverageView!
    private var asapButton: MainActionButton!
    private var scheduleButton: MainActionButton!
    
    private let journeyInfo: JourneyInfo?
    private let onLocationPermissionDenied: (() -> Void)?
    private let onAsapRidePressed: (() -> Void)
    private let onPrebookRidePressed: (() -> Void)
    
    init(
        journeyInfo: JourneyInfo?,
        onAsapRidePressed: @escaping (() -> Void),
        onPrebookRidePressed: @escaping (() -> Void),
        onLocationPermissionDenied: (() -> Void)?
    ) {
        self.journeyInfo = journeyInfo
        self.onLocationPermissionDenied = onLocationPermissionDenied
        self.onAsapRidePressed = onAsapRidePressed
        self.onPrebookRidePressed = onPrebookRidePressed
        super.init(frame: .zero)
        setUpView()
       
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 0
        axis = .vertical
        backgroundColor = .red
        contentMode = .scaleAspectFill

        setupMapView()
        addArrangedSubview(mapView)
        
        setupBottomContainer()
        
        setupAddressBar()
        insertSubview(addressView, aboveSubview: self)
        
        addressView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: UIConstants.Spacing.standard
        ).isActive = true
        addressView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 10.0
        ).isActive = true
        addressView.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -10.0
        ).isActive = true
        mapView.set(userMarkerVisible: true)
        
        layoutIfNeeded()
    }

    private func setupAddressBar() {
        addressView = KarhooComponents.shared.addressBar(journeyInfo: journeyInfo, hidePrebook: true)
    }
    
    private func setupMapView() {
        mapView = KarhooComponents.shared.mapView(
            journeyInfo: journeyInfo,
            onLocationPermissionDenied: onLocationPermissionDenied
        ).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func focusMap() {
        mapView.focusMap()
    }
    
    private func setupBottomContainer() {
        // bottom container
        bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.backgroundColor = KarhooUI.colors.white
        bottomContainer.clipsToBounds = true
        addArrangedSubview(bottomContainer)

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
        buttonsStack.addArrangedSubview(asapButton)
        if !KarhooUISDKConfigurationProvider.configuration.disablePrebookRides {
            buttonsStack.addArrangedSubview(scheduleButton)
        }
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
    }
    
    @objc private func asapRidePressed(_ selector: UIButton) {
        onAsapRidePressed()
    }
    
    @objc private func prebookRidePressed(_ selector: UIButton) {
        addressView.prebookSelected { [weak self] in
            self?.onPrebookRidePressed()
        }
    }
    
    func asapButtonEnabled(_ enabled: Bool) {
        asapButton.setEnabled(enabled)
    }
    
    func prebookButtonEnabled(_ enabled: Bool) {
        scheduleButton.setEnabled(enabled)
    }
    
    func bottomContainterVisible(_ visible: Bool) {
        guard visible != !bottomContainer.isHidden else {
            return
        }
        bottomContainer.isHidden = !visible
    }
    
    func coverageViewVisible(_ visible: Bool) {
        noCoverageView.isHidden = visible
    }
}
