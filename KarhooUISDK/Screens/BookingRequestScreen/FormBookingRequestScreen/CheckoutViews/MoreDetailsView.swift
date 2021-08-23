//
//  MoreDetailsView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHMoreDetailsViewID {
    static let container = "more_details_container"
    static let fleetCapabilitiesStackView = "fleet_capabilities_stack_view"
    static let fleetDescriptionLabel = "fleet_description_label"
}

final class MoreDetailsView: UIView {
    
    private var didSetupConstraints: Bool = false

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHMoreDetailsViewID.container
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var fleetCapabilitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHMoreDetailsViewID.fleetCapabilitiesStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHMoreDetailsViewID.fleetDescriptionLabel
        label.textColor = KarhooUI.colors.infoColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHMoreDetailsViewID.container
        
        addSubview(stackView)
        stackView.addArrangedSubview(fleetCapabilitiesStackView)
    }
    
    private func setupConstraints() {
        if !didSetupConstraints {
            
            stackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor)
            fleetCapabilitiesStackView.anchor(top: stackView.topAnchor,
                                              leading: stackView.leadingAnchor,
                                              trailing: stackView.trailingAnchor)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        detailsLabel.text = viewModel.fleetDescription
        
        if viewModel.passengerCapacity > 0 {
            setupCapacityView(forPassenger: true, maxNumber: viewModel.passengerCapacity)
        }
        
        if viewModel.baggageCapacity > 0 {
            setupCapacityView(forPassenger: false, maxNumber: viewModel.baggageCapacity)
        }
        
        viewModel.fleetCapabilities.forEach { capability in
            setupCapabilityView(for: capability)
        }
        fleetCapabilitiesStackView.addArrangedSubview(detailsLabel)
        
        setupConstraints()
    }
    
    private func setupCapabilityView(for capability: FleetCapabilities) {
        let image = capability.image
        let accessibilityId = KHMoreDetailsViewID.fleetCapabilitiesStackView + "_\(capability.title)"
        setupView(for: capability.title, with: image, accessibilityId: accessibilityId)
    }
    
    private func setupCapacityView(forPassenger passenger: Bool, maxNumber: Int) {
        let title = String(format: (passenger ? UITexts.Booking.maximumPassengers : UITexts.Booking.maximumLuggages), "\(maxNumber)")
        let image = passenger ? UIImage.uisdkImage("passenger_capacity_icon") : UIImage.uisdkImage("luggage_icon")
        let accessibilityId = KHMoreDetailsViewID.fleetCapabilitiesStackView + "_\(passenger ? "passenger" : "baggage")"
        setupView(for: title, with: image, accessibilityId: accessibilityId)
    }
    
    private func setupView(for title: String, with image: UIImage, accessibilityId: String) {
        let circleBackgroundView = UIView()
        circleBackgroundView.backgroundColor = KarhooUI.colors.lightGrey
        circleBackgroundView.setDimensions(height: 20.0,
                                           width: 20.0)
        circleBackgroundView.layer.cornerRadius = 10.0
        
        let iconView = UIImageView()
        iconView.image = image
        iconView.setDimensions(height: 14.0,
                               width: 14.0)
        iconView.tintColor = KarhooUI.colors.infoColor
        circleBackgroundView.addSubview(iconView)
        iconView.centerX(inView: circleBackgroundView)
        iconView.centerY(inView: circleBackgroundView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = KarhooUI.colors.infoColor
        titleLabel.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = accessibilityId
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(circleBackgroundView)
        stackView.addArrangedSubview(titleLabel)
        
        fleetCapabilitiesStackView.addArrangedSubview(stackView)
    }
}
