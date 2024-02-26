//
// Created by Bartlomiej Sopala on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

final class VehicleCapacityView: UIStackView {

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
        accessibilityIdentifier = KHVehicleCapacityViewID.capacityView
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
            icon: UIImage.uisdkImage("kh_uisdk_luggage_icon"),
            text: "\(value)",
            accessibilityIdentifier: KHVehicleCapacityViewID.baggageCapacityView)
        addArrangedSubview(baggageCapacityView!)
    }

    func setPassengerCapacity(_ value: Int) {
        guard value > 0 else { return }
        passengerCapacityView = IconPlusTextHorizontalView(
            icon: UIImage.uisdkImage("kh_uisdk_passenger_capacity_icon"),
            text: "\(value)",
            accessibilityIdentifier: KHVehicleCapacityViewID.passengerCapacityView)
        addArrangedSubview(passengerCapacityView!)
    }
}
