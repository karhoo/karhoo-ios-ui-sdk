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
    public static let additionalCarTags = "additional_car_tags"
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
        baggageInfoView.backgroundColor = KarhooUI.colors.paymentLightGrey
        baggageInfoView.layer.cornerRadius = 10.0
        baggageInfoView.layer.masksToBounds = true
        
        return baggageInfoView
    }()
    
    private lazy var passengerBackgroundView: UIView = {
        let capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.backgroundColor = .clear
        
        return capacityInfoView
    }()
    
    private lazy var baggageBackgroundView: UIView = {
        let capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.backgroundColor = .clear
        
        return capacityInfoView
    }()
    
    private lazy var passengerCapacityInfoView: UIView = {
        let capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.capacityInfoView
        capacityInfoView.backgroundColor = KarhooUI.colors.paymentLightGrey
        capacityInfoView.layer.cornerRadius = 10.0
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
        baggageCapacityLabel.textColor = KarhooUI.colors.primaryTextColor
        baggageCapacityLabel.font = KarhooUI.fonts.footnoteBold()
        
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
        passengerCapacityLabel.textColor = KarhooUI.colors.primaryTextColor
        passengerCapacityLabel.font = KarhooUI.fonts.footnoteBold()
        
        return passengerCapacityLabel
    }()
    
    private lazy var baggageCapacityNumberCircleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = KarhooUI.colors.white
        circleView.anchor(width: 14.0, height: 14.0)
        circleView.layer.cornerRadius = 7.0

        return circleView
    }()

    private lazy var passengerCapacityCircleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = KarhooUI.colors.white
        circleView.anchor(width: 14.0, height: 14.0)
        circleView.layer.cornerRadius = 7.0
        circleView.layer.masksToBounds = true

        return circleView
    }()
    
    private lazy var additionalCarTagsView: UIView = {
        let capacityInfoView = UIView()
        capacityInfoView.translatesAutoresizingMaskIntoConstraints = false
        capacityInfoView.accessibilityIdentifier = KHVehicleCapacityViewID.additionalCarTags
        capacityInfoView.backgroundColor = KarhooUI.colors.lightGrey
        capacityInfoView.layer.cornerRadius = 10.0
        capacityInfoView.layer.masksToBounds = true
        
        return capacityInfoView
    }()
    
    private lazy var additionalFleetCapabiliesLabel: UILabel = {
        let additionalFleetCapabilitiesLabel = UILabel()
        additionalFleetCapabilitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalFleetCapabilitiesLabel.accessibilityIdentifier = KHVehicleCapacityViewID.passengerCapacityLabel
        additionalFleetCapabilitiesLabel.textColor = KarhooUI.colors.primaryTextColor
        additionalFleetCapabilitiesLabel.font = KarhooUI.fonts.bodyBold()
        
        return additionalFleetCapabilitiesLabel
    }()
    
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
        
        baggageBackgroundView.addSubview(baggageInfoView)
        baggageInfoView.addSubview(baggageIcon)
        baggageBackgroundView.addSubview(baggageCapacityNumberCircleView)
        baggageCapacityNumberCircleView.addSubview(baggageCapacityLabel)
        stackContainer.addArrangedSubview(baggageBackgroundView)
        
        passengerBackgroundView.addSubview(passengerCapacityInfoView)
        passengerCapacityInfoView.addSubview(passengerCapacityIcon)
        passengerBackgroundView.addSubview(passengerCapacityCircleView)
        passengerCapacityCircleView.addSubview(passengerCapacityLabel)
        stackContainer.addArrangedSubview(passengerBackgroundView)
        
        setUpConstraints()
        
        layoutIfNeeded()
    }
    
    private func setUpConstraints() {
        stackContainer.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
        
        baggageBackgroundView.anchor(width: 33.0,
                                     height: 33.0)
        baggageInfoView.anchor(width: 20.0,
                               height: 20.0)
        baggageInfoView.centerX(inView: baggageBackgroundView)
        baggageInfoView.centerY(inView: baggageBackgroundView)
        baggageIcon.centerX(inView: baggageInfoView)
        baggageIcon.centerY(inView: baggageInfoView)
        baggageCapacityNumberCircleView.anchor(top: baggageBackgroundView.topAnchor,
                                               trailing: baggageBackgroundView.trailingAnchor)

        baggageCapacityLabel.centerX(inView: baggageCapacityNumberCircleView)
        baggageCapacityLabel.centerY(inView: baggageCapacityNumberCircleView)
        baggageCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        passengerBackgroundView.anchor(width: 33.0,
                                       height: 33.0)
        passengerCapacityInfoView.anchor(width: 20.0,
                                         height: 20.0)
        passengerCapacityInfoView.centerX(inView: passengerBackgroundView)
        passengerCapacityInfoView.centerY(inView: passengerBackgroundView)
        passengerCapacityIcon.centerX(inView: passengerCapacityInfoView)
        passengerCapacityIcon.centerY(inView: passengerCapacityInfoView)
        passengerCapacityCircleView.anchor(top: passengerBackgroundView.topAnchor,
                                           trailing: passengerBackgroundView.trailingAnchor)
        
        passengerCapacityLabel.centerX(inView: passengerCapacityCircleView)
        passengerCapacityLabel.centerY(inView: passengerCapacityCircleView)
        passengerCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    public func setBaggageCapacity(_ value: Int) {
        guard value > 0 else {
            baggageBackgroundView.removeFromSuperview()
            return
        }
        baggageCapacityLabel.text = "\(value)"
    }
    
    public func setPassengerCapacity(_ value: Int) {
        guard value > 0 else {
            passengerBackgroundView.removeFromSuperview()
            return
        }
        passengerCapacityLabel.text = "\(value)"
    }
    
    public func setAdditionalFleetCapabilities(_ value: Int) {
        guard value > 0 else { return }
        additionalFleetCapabiliesLabel.text = "+ \(value)"
        stackContainer.addArrangedSubview(additionalCarTagsView)
        additionalCarTagsView.addSubview(additionalFleetCapabiliesLabel)

    }
}
