//
// Created by Bartlomiej Sopala on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

public struct KHNewVehicleCapacityViewID {
    public static let capacityView = "vehicle_capacity_view"
    public static let passengerCapacityView = "passenger_capacity_view"
    public static let baggageCapacityView = "baggage_capacity_view"
}

final class NewVehicleCapacityView: UIStackView {

    private var passengerCapacityView: IconPlusTextHorizontalView?
    private var baggageCapacityView: IconPlusTextHorizontalView?

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupProperties()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHNewVehicleCapacityViewID.capacityView
        backgroundColor = .clear
        axis = .horizontal
        spacing = UIConstants.Spacing.small
        alignment = .center
        distribution = .fillProportionally
    }

    // MARK: - Public
    func setBaggageCapacity(_ value: Int) {
        guard value > 0 else { return }
        baggageCapacityView = IconPlusTextHorizontalView(
            icon: UIImage.uisdkImage("luggage_icon"),
            text: "\(value)",
            accessibilityIdentifier: KHNewVehicleCapacityViewID.baggageCapacityView)
        addArrangedSubview(baggageCapacityView!)
    }

    func setPassengerCapacity(_ value: Int) {
        guard value > 0 else { return }
        passengerCapacityView = IconPlusTextHorizontalView(
            icon: UIImage.uisdkImage("passenger_capacity_icon"),
            text: "\(value)",
            accessibilityIdentifier: KHNewVehicleCapacityViewID.passengerCapacityView)
        addArrangedSubview(passengerCapacityView!)
    }
}
