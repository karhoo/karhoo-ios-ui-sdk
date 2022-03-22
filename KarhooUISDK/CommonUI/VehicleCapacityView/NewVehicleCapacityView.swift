//
// Created by Bartlomiej Sopala on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

public struct KHNewVehicleCapacityViewID {
    public static let capacityView = "vehicle_capacity_view"
    public static let passengerContainerView = "passenger_stack_container"
    public static let passengerStack = "passenger_stack"
    public static let baggageContainerView = "baggage_stack_container"
    public static let baggageStack = "baggage_stack"
    public static let baggageIcon = "baggage_image"
    public static let baggageCapacityLabel = "baggage_capacity_label"
    public static let capacityIcon = "passenger_capacity_image"
    public static let passengerCapacityLabel = "passenger_capacity_label"
}

final class NewVehicleCapacityView: UIStackView {

    private lazy var passengerContainerView = UIView().then { view in
        view.backgroundColor =  KarhooUI.colors.background1
        view.accessibilityIdentifier = KHNewVehicleCapacityViewID.passengerContainerView
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.CornerRadius.xSmall
    }

    private lazy var passengerStack = UIStackView().then {stack in
        stack.accessibilityIdentifier = KHNewVehicleCapacityViewID.passengerStack
        stack.spacing = UIConstants.Spacing.xxSmall
    }

    private lazy var baggageContainerView = UIView().then { view in
        view.backgroundColor =  KarhooUI.colors.background1
        view.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageContainerView
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.CornerRadius.xSmall
    }

    private lazy var baggageStack = UIStackView().then {stack in
        stack.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageStack
        stack.spacing = UIConstants.Spacing.xxSmall
    }

    private lazy var baggageImageView = UIImageView().then { image in
        image.image = UIImage.uisdkImage("luggage_icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageIcon
    }

    private lazy var baggageCapacityLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHNewVehicleCapacityViewID.baggageCapacityLabel
        label.textColor = KarhooUI.colors.primary
        label.font = KarhooUI.fonts.footnoteRegular()
    }

    private lazy var passengerCapacityImageView = UIImageView().then { image in
        image.image = UIImage.uisdkImage("passenger_capacity_icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.accessibilityIdentifier = KHNewVehicleCapacityViewID.capacityIcon
        image.contentMode = .scaleAspectFill
    }

    private lazy var passengerCapacityLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHNewVehicleCapacityViewID.passengerCapacityLabel
        label.textColor = KarhooUI.colors.primary
        label.font = KarhooUI.fonts.footnoteRegular()
    }

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHNewVehicleCapacityViewID.capacityView
        backgroundColor = .clear
        axis = .horizontal
        spacing = UIConstants.Spacing.small
        alignment = .center
        distribution = .fillProportionally
    }

    private func setupHierarchy(){
        addArrangedSubview(baggageContainerView)
        baggageContainerView.addSubview(baggageStack)
        baggageStack.addArrangedSubview(baggageImageView)
        baggageStack.addArrangedSubview(baggageCapacityLabel)
        addArrangedSubview(passengerContainerView)
        passengerContainerView.addSubview(passengerStack)
        passengerStack.addArrangedSubview(passengerCapacityImageView)
        passengerStack.addArrangedSubview(passengerCapacityLabel)
    }

    private func setupLayout(){
        passengerStack.anchorToSuperview()
        passengerStack.isLayoutMarginsRelativeArrangement = true
        passengerStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.xxSmall,
            leading: UIConstants.Spacing.xSmall,
            bottom: UIConstants.Spacing.xxSmall,
            trailing: UIConstants.Spacing.xSmall
        )
        baggageStack.anchorToSuperview()
        baggageStack.isLayoutMarginsRelativeArrangement = true
        baggageStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.xxSmall,
            leading: UIConstants.Spacing.xSmall,
            bottom: UIConstants.Spacing.xxSmall,
            trailing: UIConstants.Spacing.xSmall
        )
        baggageImageView.anchor(
            width: UIConstants.Dimension.Icon.small,
            height: UIConstants.Dimension.Icon.small
        )
        passengerCapacityImageView.anchor(
            width: UIConstants.Dimension.Icon.small,
            height: UIConstants.Dimension.Icon.small
        )
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
