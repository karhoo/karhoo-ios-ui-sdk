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
        label.text = "Uber is a private-hired vehicles fleet providing e-hailing services in more than 10,000 cities. It has transparent pricing with upfront pricing in real time."
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
        stackView.addArrangedSubview(detailsLabel)
        
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            stackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingLeft: 10.0,
                             paddingRight: 10.0)
            fleetCapabilitiesStackView.anchor(top: stackView.topAnchor,
                                              leading: stackView.leadingAnchor,
                                              bottom: detailsLabel.topAnchor,
                                              trailing: stackView.trailingAnchor)
            detailsLabel.anchor(leading: stackView.leadingAnchor,
                                trailing: stackView.trailingAnchor)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        detailsLabel.text = viewModel.fleetDescription
        
        [FleetCapabilities.driverDetails, FleetCapabilities.gpsTracking, FleetCapabilities.flightTracking].forEach { capability in
            let circleBackgroundView = UIView()
            circleBackgroundView.backgroundColor = KarhooUI.colors.lightGrey
            circleBackgroundView.setDimensions(height: 20.0,
                                               width: 20.0)
            circleBackgroundView.layer.cornerRadius = 10.0
            
            let iconView = UIImageView()
            iconView.image = capability.image
            iconView.setDimensions(height: 20.0,
                                   width: 20.0)
            iconView.tintColor = KarhooUI.colors.infoColor
            circleBackgroundView.addSubview(iconView)
            
            let titleLabel = UILabel()
            titleLabel.text = capability.title
            
            let stackView = UIStackView()
            stackView.accessibilityIdentifier = KHMoreDetailsViewID.fleetCapabilitiesStackView + "_\(capability.title)"
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = 5
            stackView.backgroundColor = .systemPink
            stackView.addArrangedSubview(circleBackgroundView)
            stackView.addArrangedSubview(titleLabel)
            
            fleetCapabilitiesStackView.addArrangedSubview(stackView)
        }
    }
}
