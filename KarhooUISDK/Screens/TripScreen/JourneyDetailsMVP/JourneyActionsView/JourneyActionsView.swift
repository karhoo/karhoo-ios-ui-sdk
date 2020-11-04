//
//  JourneyActionsView.swift
//  JourneyVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHJourneyActionsViewID {
    public static let cancelRideButton = "cancel_ride_button"
    public static let contactDriverButton = "contact_driver_button"
}

final class JourneyActionsView: UIView {
    
    private var cancelRideButton: UIButton!
    private var contactDriverButton: UIButton!
    private var container: UIView!
    private var buttonContainer: UIStackView!
    
    private weak var actions: JourneyOptionsActions?
    private var presenter: JourneyOptionsPresenter?
    private var viewModel: JourneyOptionsViewModel?
    
    public init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        accessibilityIdentifier = "journey_actions_view"
        translatesAutoresizingMaskIntoConstraints = false
        
        presenter = KarhooJourneyOptionsPresenter()
        
        container = UIView()
        container.accessibilityIdentifier = "container"
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        addSubview(container)
        _ = [container.topAnchor.constraint(equalTo: self.topAnchor),
             container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             container.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        buttonContainer = UIStackView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.accessibilityIdentifier = "button_container"
        buttonContainer.distribution = .fillEqually
        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 10.0
        
        addSubview(buttonContainer)
        _ = [buttonContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
             buttonContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             buttonContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             buttonContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                     constant: -10.0)].map { $0.isActive = true }
        
        cancelRideButton = UIButton(type: .custom)
        cancelRideButton.translatesAutoresizingMaskIntoConstraints = false
        cancelRideButton.accessibilityIdentifier = KHJourneyActionsViewID.cancelRideButton
        cancelRideButton.setTitle(UITexts.Journey.journeyCancelRide, for: .normal)
        cancelRideButton.backgroundColor = .white
        cancelRideButton.setTitleColor(KarhooUI.colors.neonRed, for: .normal)
        cancelRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0,
                                                     weight: .semibold)
        cancelRideButton.layer.cornerRadius = 5
        cancelRideButton.addTarget(self, action: #selector(cancelRideTapped), for: .touchUpInside)
        
        buttonContainer.addArrangedSubview(cancelRideButton)
        cancelRideButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        contactDriverButton = UIButton(type: .custom)
        contactDriverButton.translatesAutoresizingMaskIntoConstraints = false
        contactDriverButton.accessibilityIdentifier = KHJourneyActionsViewID.contactDriverButton
        contactDriverButton.setTitle(UITexts.Journey.journeyContactDriver, for: .normal)
        contactDriverButton.backgroundColor = .white
        contactDriverButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0,
                                                     weight: .semibold)
        contactDriverButton.setTitleColor(.black, for: .normal)
        contactDriverButton.layer.cornerRadius = 5
        contactDriverButton.addTarget(self, action: #selector(contactDriverTapped), for: .touchUpInside)
        
        buttonContainer.addArrangedSubview(contactDriverButton)
        contactDriverButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        cancelRideButton.addOuterShadow()
        contactDriverButton.addOuterShadow()
    }
    
    @objc
    private func cancelRideTapped() {
        actions?.cancelSelected()
    }
    
    @objc
    private func contactDriverTapped() {
        guard let number = viewModel?.tripContactNumber else {
            return
        }
        presenter?.call(phoneNumber: number)
    }
    
    public func set(viewModel: JourneyOptionsViewModel) {
        self.viewModel = viewModel
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.cancelRideButton.isHidden = !viewModel.cancelEnabled
            self?.contactDriverButton.setTitle(viewModel.tripContactInfo, for: .normal)
        })
    }
    
    public func set(actions: JourneyOptionsActions) {
        self.actions = actions
    }
}
