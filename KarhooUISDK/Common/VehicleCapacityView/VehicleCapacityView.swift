//
//  VehicleCapacityView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHVehicleCapacityViewID {
     public static let baggageInfoView = "baggage_info_view"
     public static let baggageIcon = "baggage_image"
     public static let baggageCapacityLabel = "baggage_capacity_label"
     public static let capacityInfoView = "capacity_info_view"
     public static let capacityIcon = "passenger_capacity_image"
     public static let passengerCapacityLabel = "passenger_capacity_label"
}

final class VehicleCapacityView: UIView {

    private var stackContainer: UIStackView!
    private var baggageInfoView: UIView!
    private var capacityInfoView: UIView!
    
    private var baggageIcon: UIImageView!
    private var baggageCapacityLabel: UILabel!
    private var capacityIcon: UIImageView!
    private var passengerCapacityLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "vehicle_capacity_view"
        backgroundColor = .clear
        
        stackContainer = UIStackView()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.axis = .horizontal
        stackContainer.spacing = 5.0
        stackContainer.distribution = .fillEqually
        addSubview(stackContainer)
        
        baggageInfoView = UIView()
        baggageInfoView.translatesAutoresizingMaskIntoConstraints = false
        baggageInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.baggageInfoView
        stackContainer.addArrangedSubview(baggageInfoView)
        
        baggageIcon = UIImageView(image: UIImage.uisdkImage("luggage_icon"))
        baggageIcon.translatesAutoresizingMaskIntoConstraints = false
        baggageIcon.contentMode = .scaleAspectFill
        baggageIcon.accessibilityIdentifier = KHVehicleCapacityViewID.baggageIcon
        baggageInfoView.addSubview(baggageIcon)
        
        baggageCapacityLabel = UILabel()
        baggageCapacityLabel.translatesAutoresizingMaskIntoConstraints = false
        baggageCapacityLabel.accessibilityIdentifier = KHVehicleCapacityViewID.baggageCapacityLabel
        baggageCapacityLabel.textColor = KarhooUI.colors.guestCheckoutLightGrey
        baggageCapacityLabel.font = UIFont.systemFont(ofSize: 13.0)
        baggageCapacityLabel.text = "x0"
        baggageInfoView.addSubview(baggageCapacityLabel)
        
        capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.capacityInfoView
        stackContainer.addArrangedSubview(capacityInfoView)

        capacityIcon = UIImageView(image: UIImage.uisdkImage("passenger_capacity_icon"))
        capacityIcon.translatesAutoresizingMaskIntoConstraints = false
        capacityIcon.contentMode = .scaleAspectFill
        capacityIcon.accessibilityIdentifier = KHVehicleCapacityViewID.capacityIcon
        capacityInfoView.addSubview(capacityIcon)

        passengerCapacityLabel = UILabel()
        passengerCapacityLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerCapacityLabel.accessibilityIdentifier = KHVehicleCapacityViewID.passengerCapacityLabel
        passengerCapacityLabel.textColor = KarhooUI.colors.guestCheckoutLightGrey
        passengerCapacityLabel.font = UIFont.systemFont(ofSize: 13.0)
        passengerCapacityLabel.text = "x0"
        capacityInfoView.addSubview(passengerCapacityLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [stackContainer.topAnchor.constraint(equalTo: topAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
             stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
        
        _ = [baggageIcon.topAnchor.constraint(equalTo: baggageInfoView.topAnchor),
             baggageIcon.leadingAnchor.constraint(equalTo: baggageInfoView.leadingAnchor),
             baggageIcon.bottomAnchor.constraint(equalTo: baggageInfoView.bottomAnchor),
             baggageIcon.widthAnchor.constraint(equalToConstant: 20.0),
             baggageIcon.heightAnchor.constraint(equalToConstant: 14.0)].map { $0.isActive = true }
        
        _ = [baggageCapacityLabel.centerYAnchor.constraint(equalTo: baggageIcon.centerYAnchor),
             baggageCapacityLabel.leadingAnchor.constraint(equalTo: baggageIcon.trailingAnchor, constant: 4.0),
             baggageCapacityLabel.trailingAnchor.constraint(equalTo: baggageInfoView.trailingAnchor)]
            .map { $0.isActive = true }
        
        _ = [capacityIcon.topAnchor.constraint(equalTo: capacityInfoView.topAnchor),
             capacityIcon.leadingAnchor.constraint(equalTo: capacityInfoView.leadingAnchor),
             capacityIcon.bottomAnchor.constraint(equalTo: capacityInfoView.bottomAnchor),
             capacityIcon.widthAnchor.constraint(equalToConstant: 20.0),
             capacityIcon.heightAnchor.constraint(equalToConstant: 14.0)].map { $0.isActive = true }

        _ = [passengerCapacityLabel.centerYAnchor.constraint(equalTo: capacityIcon.centerYAnchor),
             passengerCapacityLabel.leadingAnchor.constraint(equalTo: capacityIcon.trailingAnchor, constant: 4.0),
             passengerCapacityLabel.trailingAnchor.constraint(equalTo: capacityInfoView.trailingAnchor)]
            .map { $0.isActive = true }
    }
    
    public func setBaggageCapacity(_ value: String) {
        baggageCapacityLabel.text = "x" + value
    }
    
    public func setPassengerCapacity(_ value: String) {
        passengerCapacityLabel.text = "x" + value
    }
}
