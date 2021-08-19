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

    private lazy var stackContainer: UIStackView = {
        let stackContainer = UIStackView()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.axis = .horizontal
        stackContainer.spacing = 5.0
        stackContainer.alignment = .center
        stackContainer.distribution = .fillProportionally
        
        return stackContainer
    }()
    
    private lazy var baggageInfoView: UIView = {
        let baggageInfoView = UIView()
        baggageInfoView.translatesAutoresizingMaskIntoConstraints = false
        baggageInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.baggageInfoView
        baggageInfoView.backgroundColor = KarhooUI.colors.lightGrey
        baggageInfoView.layer.cornerRadius = 13.0
        baggageInfoView.layer.masksToBounds = true
        
        return baggageInfoView
    }()
    
    private lazy var passengerCapacityInfoView: UIView = {
        let capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.capacityInfoView
        capacityInfoView.backgroundColor = KarhooUI.colors.lightGrey
        capacityInfoView.layer.cornerRadius = 13.0
        capacityInfoView.layer.masksToBounds = true
        
        return capacityInfoView
    }()
    
    private var baggageIcon: UIImageView = {
        let baggageIcon = UIImageView(image: UIImage.uisdkImage("luggage_icon"))
        baggageIcon.translatesAutoresizingMaskIntoConstraints = false
        baggageIcon.contentMode = .scaleAspectFill
        baggageIcon.accessibilityIdentifier = KHVehicleCapacityViewID.baggageIcon
        baggageIcon.anchor(width: 14.0,
                           height: 14.0)
        
        return baggageIcon
    }()
    
    private lazy var baggageCapacityLabel: UILabel = {
        let baggageCapacityLabel = UILabel()
        baggageCapacityLabel.translatesAutoresizingMaskIntoConstraints = false
        baggageCapacityLabel.accessibilityIdentifier = KHVehicleCapacityViewID.baggageCapacityLabel
        baggageCapacityLabel.textColor = KarhooUI.colors.guestCheckoutLightGrey
        baggageCapacityLabel.font = UIFont.systemFont(ofSize: 9.0)
        
        return baggageCapacityLabel
    }()
    
    private lazy var passengerCapacityIcon: UIImageView = {
        let capacityIcon = UIImageView(image: UIImage.uisdkImage("passenger_capacity_icon"))
        capacityIcon.translatesAutoresizingMaskIntoConstraints = false
        capacityIcon.contentMode = .scaleAspectFill
        capacityIcon.accessibilityIdentifier = KHVehicleCapacityViewID.capacityIcon
        capacityIcon.anchor(width: 14.0,
                            height: 14.0)
        
        return capacityIcon
    }()
    
    private lazy var passengerCapacityLabel: UILabel = {
        let passengerCapacityLabel = UILabel()
        passengerCapacityLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerCapacityLabel.accessibilityIdentifier = KHVehicleCapacityViewID.passengerCapacityLabel
        passengerCapacityLabel.textColor = KarhooUI.colors.guestCheckoutLightGrey
        passengerCapacityLabel.font = UIFont.systemFont(ofSize: 9.0)
//        passengerCapacityLabel.text = "0"
        
        return passengerCapacityLabel
    }()
    
//    private lazy var baggageCapacityNumberCircleView: UIView = {
//        let circleView = UIView()
//        circleView.backgroundColor = .systemRed
//        circleView.anchor(width: 14.0, height: 14.0)
//        circleView.layer.cornerRadius = circleView.frame.width / 2
//
//        return circleView
//    }()
//
//    private lazy var passengerCapacityCircleView: UIView = {
//        let circleView = UIView()
//        circleView.backgroundColor = .systemRed
//        circleView.anchor(width: 14.0, height: 14.0)
//        circleView.layer.cornerRadius = circleView.frame.width / 2
//        circleView.layer.masksToBounds = true
//
//        return circleView
//    }()
    
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
        
        addSubview(stackContainer)
        baggageInfoView.addSubview(baggageIcon)
        stackContainer.addArrangedSubview(baggageInfoView)
//        baggageInfoView.addSubview(baggageCapacityNumberCircleView)
//        baggageCapacityNumberCircleView.addSubview(baggageCapacityLabel)
        
        passengerCapacityInfoView.addSubview(passengerCapacityIcon)
        stackContainer.addArrangedSubview(passengerCapacityInfoView)
//        capacityInfoView.addSubview(passengerCapacityCircleView)
//        passengerCapacityCircleView.addSubview(passengerCapacityLabel)
        
        setUpConstraints()
        
        layoutIfNeeded()
    }
    
    private func setUpConstraints() {
        stackContainer.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
        
        baggageIcon.centerX(inView: baggageInfoView)
        baggageIcon.centerY(inView: baggageInfoView)
        baggageInfoView.anchor(width: 26.0,
                               height: 26.0)
//        baggageCapacityNumberCircleView.anchor(top: baggageInfoView.topAnchor, trailing: baggageInfoView.trailingAnchor)
//        baggageCapacityLabel.centerY(inView: baggageCapacityNumberCircleView)
//        baggageCapacityLabel.anchor(leading: baggageCapacityNumberCircleView.trailingAnchor, trailing: baggageCapacityNumberCircleView.trailingAnchor)
        baggageCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        passengerCapacityIcon.centerX(inView: passengerCapacityInfoView)
        passengerCapacityIcon.centerY(inView: passengerCapacityInfoView)
        passengerCapacityInfoView.anchor(width: 26.0,
                                         height: 26.0)
//        passengerCapacityCircleView.anchor(top: capacityInfoView.topAnchor, trailing: capacityInfoView.trailingAnchor)
//        passengerCapacityCircleView.centerX(inView: capacityInfoView, constant: 5.0)
//        passengerCapacityLabel.centerY(inView: passengerCapacityCircleView)
//        passengerCapacityLabel.anchor(leading: passengerCapacityCircleView.trailingAnchor, trailing: passengerCapacityCircleView.trailingAnchor)
        passengerCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    public func setBaggageCapacity(_ value: String) {
        baggageCapacityLabel.text = value
    }
    
    public func setPassengerCapacity(_ value: String) {
        passengerCapacityLabel.text = value
    }
}
