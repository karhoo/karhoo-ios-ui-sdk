//
//  KarhooQuoteVehicleCapacityView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHVehicleCapacityViewID {
    public static let capacityView = "vehicle_capacity_view"
    public static let baggageContentView = "baggage_content_view"
    public static let passengerCapacityContentView = "passenger_capacity_content_view"
    public static let baggageInfoView = "baggage_info_view"
    public static let baggageIcon = "baggage_image"
    public static let baggageCapacityLabel = "baggage_capacity_label"
    public static let capacityInfoView = "capacity_info_view"
    public static let capacityIcon = "passenger_capacity_image"
    public static let passengerCapacityLabel = "passenger_capacity_label"
    public static let additionalCapacityContentView = "additional_capabilities_content_view"
    public static let additionalFleetCapabilitiesView = "additional_capabilities_view"
    public static let additionalFleetCapabilitiesLabel = "additional_capabilities_label"
    public static let passengerCapacityView = "passenger_capacity_view"
    public static let baggageCapacityView = "baggage_capacity_view"
}

/// NOTE: New layout created in NewVehicleCapacityView.swift
/// Remove this file and use new one for Checkout View

final class QuoteVehicleCapacityView: UIStackView {

    // MARK: - UI
    private lazy var baggageContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.baggageContentView
        view.backgroundColor = .clear
        view.anchor(width: 33.0, height: 33.0)
        return view
    }()

    // Note: Needed to provide the background color for the baggageImageView
    private lazy var baggageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.baggageInfoView
        view.backgroundColor = KarhooUI.colors.infoBackgroundColor
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.anchor(width: 20.0, height: 20.0)
        return view
    }()

    private var baggageImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.uisdkImage("kh_uisdk_luggage_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = KHVehicleCapacityViewID.baggageIcon
        imageView.anchor(width: 14.0, height: 14.0)
        return imageView
    }()

    private lazy var baggageCapacityNumberCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = KarhooUI.colors.white
        view.anchor(width: 14.0, height: 14.0)
        view.layer.cornerRadius = 7.0
        return view
    }()

    private lazy var baggageCapacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHVehicleCapacityViewID.baggageCapacityLabel
        label.textColor = KarhooUI.colors.primaryTextColor
        label.font = KarhooUI.fonts.footnoteBold()
        return label
    }()

    private lazy var passengerCapacityContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.passengerCapacityContentView
        view.backgroundColor = .clear
        view.anchor(width: 33.0, height: 33.0)
        return view
    }()

    // Note: Needed to provide the background color for the passengerCapacityImageView
    private lazy var passengerCapacityBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.capacityInfoView
        view.backgroundColor = KarhooUI.colors.infoBackgroundColor
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.anchor(width: 20.0, height: 20.0)
        return view
    }()

    private lazy var passengerCapacityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.uisdkImage("kh_uisdk_passenger_capacity_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = KHVehicleCapacityViewID.capacityIcon
        imageView.anchor(width: 14.0, height: 14.0)
        return imageView
    }()

    private lazy var passengerCapacityCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = KarhooUI.colors.white
        view.anchor(width: 14.0, height: 14.0)
        view.layer.cornerRadius = 7.0
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var passengerCapacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHVehicleCapacityViewID.passengerCapacityLabel
        label.textColor = KarhooUI.colors.primaryTextColor
        label.font = KarhooUI.fonts.footnoteBold()
        return label
    }()

    // Note: Added this view to preserve the size (and spacing respectably) between all 3 possible logical areas of the VehicleCapacityView
    private lazy var additionalFleetCapabilitiesContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.additionalCapacityContentView
        view.backgroundColor = .clear
        view.anchor(width: 33.0, height: 33.0)
        return view
    }()

    private lazy var additionalFleetCapabilitiesBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHVehicleCapacityViewID.additionalFleetCapabilitiesView
        view.backgroundColor = KarhooUI.colors.infoBackgroundColor
        view.layer.cornerRadius = 10.0
        view.anchor(width: 20.0, height: 20.0)
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var additionalFleetCapabiliesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHVehicleCapacityViewID.additionalFleetCapabilitiesLabel
        label.textColor = KarhooUI.colors.infoColor
        label.font = KarhooUI.fonts.captionBold()
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
        accessibilityIdentifier = KHVehicleCapacityViewID.capacityView
        backgroundColor = .clear
        axis = .horizontal
        spacing = 5.0
        alignment = .center
        distribution = .fillProportionally

        passengerCapacityContentView.addSubview(passengerCapacityBackgroundView)
        passengerCapacityBackgroundView.addSubview(passengerCapacityImageView)
        passengerCapacityContentView.addSubview(passengerCapacityCircleView)
        passengerCapacityCircleView.addSubview(passengerCapacityLabel)
        addArrangedSubview(passengerCapacityContentView)

        baggageContentView.addSubview(baggageBackgroundView)
        baggageBackgroundView.addSubview(baggageImageView)
        baggageContentView.addSubview(baggageCapacityNumberCircleView)
        baggageCapacityNumberCircleView.addSubview(baggageCapacityLabel)
        addArrangedSubview(baggageContentView)

        setUpConstraints()

        layoutIfNeeded()
    }

    private func setUpConstraints() {
        baggageBackgroundView.centerX(inView: baggageContentView)
        baggageBackgroundView.centerY(inView: baggageContentView)
        baggageImageView.centerX(inView: baggageBackgroundView)
        baggageImageView.centerY(inView: baggageBackgroundView)
        baggageCapacityNumberCircleView.anchor(top: baggageContentView.topAnchor,
                                               trailing: baggageContentView.trailingAnchor)

        baggageCapacityLabel.centerX(inView: baggageCapacityNumberCircleView)
        baggageCapacityLabel.centerY(inView: baggageCapacityNumberCircleView)
        baggageCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        passengerCapacityBackgroundView.centerX(inView: passengerCapacityContentView)
        passengerCapacityBackgroundView.centerY(inView: passengerCapacityContentView)
        passengerCapacityImageView.centerX(inView: passengerCapacityBackgroundView)
        passengerCapacityImageView.centerY(inView: passengerCapacityBackgroundView)
        passengerCapacityCircleView.anchor(top: passengerCapacityContentView.topAnchor,
                                           trailing: passengerCapacityContentView.trailingAnchor)

        passengerCapacityLabel.centerX(inView: passengerCapacityCircleView)
        passengerCapacityLabel.centerY(inView: passengerCapacityCircleView)
        passengerCapacityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    // MARK: - Public
    public func setBaggageCapacity(_ value: Int) {
        guard value > 0 else {
            baggageContentView.isHidden = true
            return
        }
        baggageContentView.isHidden = false
        baggageCapacityLabel.text = "\(value)"
    }

    public func setPassengerCapacity(_ value: Int) {
        guard value > 0 else {
            passengerCapacityContentView.isHidden = true
            return
        }
        passengerCapacityContentView.isHidden = false
        passengerCapacityLabel.text = "\(value)"
    }

    public func setAdditionalFleetCapabilities(_ value: Int) {
        guard value > 0 else { return }
        additionalFleetCapabiliesLabel.text = "+\(value)"

        addArrangedSubview(additionalFleetCapabilitiesContentView)
        additionalFleetCapabilitiesContentView.addSubview(additionalFleetCapabilitiesBackgroundView)
        additionalFleetCapabilitiesBackgroundView.addSubview(additionalFleetCapabiliesLabel)
        setAdditionalConstraints()

        needsUpdateConstraints()
    }

    private func setAdditionalConstraints() {
        additionalFleetCapabilitiesBackgroundView.centerX(inView: additionalFleetCapabilitiesContentView)
        additionalFleetCapabilitiesBackgroundView.centerY(inView: additionalFleetCapabilitiesContentView)

        additionalFleetCapabiliesLabel.centerX(inView: additionalFleetCapabilitiesBackgroundView)
        additionalFleetCapabiliesLabel.centerY(inView: additionalFleetCapabilitiesBackgroundView)
    }
}
