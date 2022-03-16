//
// Created by Bartlomiej Sopala on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

//
//  VehicleCapacityView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHNewVehicleCapacityViewID {
    public static let capacityView = "vehicle_capacity_view"
    public static let passengerStack = "passenger_stack"
    public static let baggageStack = "baggage_stack"
    public static let baggageIcon = "baggage_image"
    public static let baggageCapacityLabel = "baggage_capacity_label"
    public static let capacityIcon = "passenger_capacity_image"
    public static let passengerCapacityLabel = "passenger_capacity_label"
}

final class NewVehicleCapacityView: UIStackView {

    private lazy var passengerStack = UIStackView().then {stack in
        stack.backgroundColor = KarhooUI.colors.background1
        stack.accessibilityIdentifier = KHNewVehicleCapacityViewID.passengerStack
        stack.clipsToBounds = true
        stack.layer.cornerRadius = UIConstants.CornerRadius.xSmall
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.xxSmall,
            leading: UIConstants.Spacing.xSmall,
            bottom: UIConstants.Spacing.xxSmall,
            trailing: UIConstants.Spacing.xSmall
        )
        stack.spacing = UIConstants.Spacing.xxSmall
    }

    private lazy var baggageStack = UIStackView().then {stack in
        stack.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageStack
        stack.backgroundColor = KarhooUI.colors.background1
        stack.clipsToBounds = true
        stack.layer.cornerRadius = UIConstants.CornerRadius.xSmall
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.xxSmall,
            leading: UIConstants.Spacing.xSmall,
            bottom: UIConstants.Spacing.xxSmall,
            trailing: UIConstants.Spacing.xSmall
        )
        stack.spacing = UIConstants.Spacing.xxSmall
    }

    private var baggageImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.uisdkImage("luggage_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageIcon
        imageView.anchor(width: 14.0, height: 14.0)
        return imageView
    }()

    private lazy var baggageCapacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageCapacityLabel
        label.textColor = KarhooUI.colors.primaryTextColor
        label.font = KarhooUI.fonts.footnoteRegular()
        return label
    }()

    private lazy var passengerCapacityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.uisdkImage("passenger_capacity_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = KHNewVehicleCapacityViewID.capacityIcon
        imageView.anchor(width: 14.0, height: 14.0)
        return imageView
    }()

    private lazy var passengerCapacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHNewVehicleCapacityViewID.passengerCapacityLabel
        label.textColor = KarhooUI.colors.primaryTextColor
        label.font = KarhooUI.fonts.footnoteRegular()
        return label
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHNewVehicleCapacityViewID.capacityView
        backgroundColor = .clear
        axis = .horizontal
        spacing = 5.0
        alignment = .center
        distribution = .fillProportionally

        addArrangedSubview(baggageStack)
        baggageStack.addArrangedSubview(baggageImageView)
        baggageStack.addArrangedSubview(baggageCapacityLabel)
        addArrangedSubview(passengerStack)
        passengerStack.addArrangedSubview(passengerCapacityImageView)
        passengerStack.addArrangedSubview(passengerCapacityLabel)
        layoutIfNeeded()
    }

    // MARK: - Public
    public func setBaggageCapacity(_ value: Int) {
        guard value > 0 else {
            baggageStack.removeFromSuperview()
            return
        }
        baggageCapacityLabel.text = "\(value)"
    }

    public func setPassengerCapacity(_ value: Int) {
        guard value > 0 else {
            passengerStack.removeFromSuperview()
            return
        }
        passengerCapacityLabel.text = "\(value)"
    }
}
