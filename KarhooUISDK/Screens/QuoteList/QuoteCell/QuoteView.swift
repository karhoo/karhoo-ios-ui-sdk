//
//  QuoteView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHQuoteViewID {
    public static let quoteView = "quote_view"
    public static let containerStackView = "container_stack_view"
    public static let carInfoStackView = "car_info_stack_view"
    public static let logoImage = "logo_image"
    public static let rideDetailsStackView = "ride_details_stack_view"
    public static let name = "name_label"
    public static let capacityStackView = "capacity_stack_view"
    public static let detailsButton = "details_button"
    public static let middleStackView = "middle_stack_view"
    public static let etaStackView = "eta_stack_view"
    public static let eta = "eta_label"
    public static let etaDescription = "eta_description"
    public static let priceStackView = "price_details_stack_view"
    public static let fare = "fare_label"
    public static let fareType = "fareType_label"
    public static let lineSeparator = "line_separator"
    public static let bottomStack = "bottom_stack"
    public static let bottomStackContainer = "bottom_stack_container"
    public static let bottomImage = "bottom_image"
    public static let fleetName = "fleet_name"
}

class QuoteView: UIView {
    private var didSetupConstraints: Bool = false

    private var containerStack: UIStackView!
    private var viewWithBorder: UIView!
    private var carInfoView: UIView!
    private var logoLoadingImageView: LoadingImageView!
    private var name: UILabel!
    private var rideDetailStackView: UIStackView!
    private var vehicleCapacityView: VehicleCapacityView!
    private var capacityAndPickupTypeContainer: UIStackView!
    private var detailsButton: UIButton!
    private var middleStack: UIStackView!
    private var etaStack: UIStackView!
    private var eta: UILabel!
    private var etaDescription: UILabel!
    private var priceDetailsStack: UIStackView!
    private var fare: UILabel!
    private var fareType: UILabel!
    private var lineSeparator: LineView!
    private var bottomStack: UIStackView!
    private var bottomStackContainer: UIView!
    private var bottomImage: LoadingImageView!
    private var fleetName: UILabel!

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(viewModel: QuoteViewModel) {
        self.init()
        self.set(viewModel: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    private func setUpView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        setupCellProperties()
        setupFooterProperties()
    }

    private func setupCellProperties() {
        backgroundColor = KarhooUI.colors.white
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHQuoteViewID.quoteView

        containerStack = UIStackView().then { stack in
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.accessibilityIdentifier = KHQuoteViewID.containerStackView
            stack.axis = .vertical
            stack.alignment = .fill
            stack.clipsToBounds = true
            stack.layer.cornerRadius = UIConstants.CornerRadius.large
        }

        viewWithBorder = UIView().then { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = UIConstants.CornerRadius.large
            view.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
            view.layer.borderColor = KarhooUI.colors.border.cgColor
        }

        carInfoView = UIView().then { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.accessibilityIdentifier = KHQuoteViewID.carInfoStackView
            view.clipsToBounds = true
        }

        logoLoadingImageView = LoadingImageView().then { logo in
            logo.accessibilityIdentifier = KHQuoteViewID.logoImage
            logo.layer.masksToBounds = true
        }

        rideDetailStackView = UIStackView()
        rideDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        rideDetailStackView.accessibilityIdentifier = KHQuoteViewID.rideDetailsStackView
        rideDetailStackView.axis = .vertical
        rideDetailStackView.alignment = .leading
        rideDetailStackView.spacing = UIConstants.Spacing.xSmall

        name = UILabel().then { name in
            name.translatesAutoresizingMaskIntoConstraints = false
            name.accessibilityIdentifier = KHQuoteViewID.name
            name.textColor = KarhooUI.colors.text
            name.font = KarhooUI.fonts.bodyBold()
            name.numberOfLines = 0
            name.lineBreakMode = .byWordWrapping
        }

        capacityAndPickupTypeContainer = UIStackView().then { stack in
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.accessibilityIdentifier = KHQuoteViewID.capacityStackView
            stack.axis = .horizontal
            stack.alignment = .leading
            stack.spacing = 10.0
        }

        vehicleCapacityView = VehicleCapacityView()

        detailsButton = UIButton().then { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.accessibilityIdentifier = KHQuoteViewID.detailsButton
            button.backgroundColor = KarhooUI.colors.accent
            button.setTitleColor(KarhooUI.colors.white, for: .normal)
            button.titleLabel?.font = KarhooUI.fonts.footnoteRegular()
            button.setTitle(UITexts.QuoteCell.details, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = UIConstants.CornerRadius.large
            button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }

        middleStack = UIStackView().then { stack in
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.accessibilityIdentifier = KHQuoteViewID.middleStackView
            stack.axis = .horizontal
            stack.alignment = .center
        }

        // ETA stack
        etaStack = UIStackView().then { stack in
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.accessibilityIdentifier = KHQuoteViewID.etaStackView
            stack.axis = .vertical
            stack.alignment = .leading
        }
        eta = UILabel().then { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.accessibilityIdentifier = KHQuoteViewID.eta
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.textAlignment = .right
            label.font = KarhooUI.fonts.headerBold()
            label.textColor = KarhooUI.colors.black
        }
        etaDescription = UILabel().then { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.accessibilityIdentifier = KHQuoteViewID.etaDescription
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.textAlignment = .right
            label.font = KarhooUI.fonts.footnoteRegular()
            label.textColor = KarhooUI.colors.text
            label.text = UITexts.QuoteCell.driverArrival
        }

        // Price details stack
        priceDetailsStack = UIStackView()
        priceDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        priceDetailsStack.accessibilityIdentifier = KHQuoteViewID.priceStackView
        priceDetailsStack.axis = .vertical

        fare = UILabel()
        fare.translatesAutoresizingMaskIntoConstraints = false
        fare.setContentCompressionResistancePriority(.required, for: .horizontal)
        fare.accessibilityIdentifier = KHQuoteViewID.fare
        fare.textAlignment = .right
        fare.font = KarhooUI.fonts.headerBold()
        fare.textColor = KarhooUI.colors.black

        fareType = UILabel()
        fareType.translatesAutoresizingMaskIntoConstraints = false
        fareType.accessibilityIdentifier = KHQuoteViewID.fareType
        fareType.setContentCompressionResistancePriority(.required, for: .horizontal)
        fareType.textAlignment = .right
        fareType.font = KarhooUI.fonts.footnoteRegular()
        fareType.textColor = KarhooUI.colors.text
    }

    private func setupFooterProperties() {
        lineSeparator = LineView(
            color: KarhooUI.colors.border,
            accessibilityIdentifier: KHQuoteViewID.lineSeparator
        )

        bottomStackContainer = UIView().then { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.accessibilityIdentifier = KHQuoteViewID.bottomStackContainer
            view.backgroundColor = KarhooUI.colors.background1
        }

        bottomStack = UIStackView().then {stack in
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.accessibilityIdentifier = KHQuoteViewID.bottomStack
            stack.alignment = .leading
            stack.axis = .horizontal
            stack.spacing = UIConstants.Spacing.xSmall
        }

        bottomImage = LoadingImageView().then { logo in
            logo.accessibilityIdentifier = KHQuoteViewID.logoImage
            logo.layer.masksToBounds = true
        }

        fleetName = UILabel().then { fleetName in
            fleetName.translatesAutoresizingMaskIntoConstraints = false
            fleetName.accessibilityIdentifier = KHQuoteViewID.fleetName
            fleetName.textColor = KarhooUI.colors.text
            fleetName.font = KarhooUI.fonts.footnoteBold()
            fleetName.numberOfLines = 0
            fleetName.lineBreakMode = .byWordWrapping
        }
    }

    private func setupHierarchy() {
        addSubview(viewWithBorder)
        viewWithBorder.addSubview(containerStack)
        containerStack.addArrangedSubview(carInfoView)
        carInfoView.addSubview(logoLoadingImageView)
        carInfoView.addSubview(rideDetailStackView)
        carInfoView.addSubview(detailsButton)
        rideDetailStackView.addArrangedSubview(name)
        rideDetailStackView.addArrangedSubview(vehicleCapacityView)

        containerStack.addArrangedSubview(middleStack)
        middleStack.addArrangedSubview(etaStack)
        middleStack.addArrangedSubview(priceDetailsStack)
        etaStack.addArrangedSubview(eta)
        etaStack.addArrangedSubview(etaDescription)
        priceDetailsStack.addArrangedSubview(fare)
        priceDetailsStack.addArrangedSubview(fareType)

        containerStack.addArrangedSubview(lineSeparator)
        containerStack.addArrangedSubview(bottomStackContainer)
        bottomStackContainer.addSubview(bottomStack)
        bottomStack.addArrangedSubview(bottomImage)
        bottomStack.addArrangedSubview(fleetName)
    }

    private func setupLayout() {
        containerStack.anchorToSuperview()
        viewWithBorder.anchorToSuperview(

            paddingTop: UIConstants.Spacing.small,
            paddingLeading: UIConstants.Spacing.standard,
            paddingTrailing: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.small
        )
        logoLoadingImageView.anchor(
            top: carInfoView.topAnchor,
            left: carInfoView.leftAnchor,
            bottom: carInfoView.bottomAnchor,
            right: rideDetailStackView.leftAnchor,
            paddingTop: UIConstants.Spacing.small,
            paddingLeft: UIConstants.Spacing.small,
            paddingBottom: UIConstants.Spacing.small,
            paddingRight: UIConstants.Spacing.small,
            width: UIConstants.Dimension.Icon.xLarge,
            height: UIConstants.Dimension.Icon.xLarge
        )
        rideDetailStackView.anchor(
            top: carInfoView.topAnchor,
            bottom: carInfoView.bottomAnchor,
            right: detailsButton.leftAnchor,
            paddingTop: UIConstants.Spacing.small,
            paddingRight: UIConstants.Spacing.small
        )
        middleStack.isLayoutMarginsRelativeArrangement = true
        middleStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: UIConstants.Spacing.small,
            bottom: UIConstants.Spacing.small,
            trailing: UIConstants.Spacing.small
        )
        lineSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomStack.anchorToSuperview()
        bottomStack.isLayoutMarginsRelativeArrangement = true
        bottomStack.alignment = .center
        bottomStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.small,
            leading: UIConstants.Spacing.small,
            bottom: UIConstants.Spacing.small,
            trailing: UIConstants.Spacing.small
        )
        detailsButton.anchor(top: carInfoView.topAnchor, right: carInfoView.rightAnchor)
        detailsButton.contentEdgeInsets = UIEdgeInsets(
            top: UIConstants.Spacing.small,
            left: UIConstants.Spacing.standard,
            bottom: UIConstants.Spacing.small,
            right: UIConstants.Spacing.standard
        )
        bottomImage.anchor(width: UIConstants.Dimension.Icon.medium, height: UIConstants.Dimension.Icon.medium)
    }
    
    func set(viewModel: QuoteViewModel) {
        name.text = viewModel.vehicleType
        eta.text = viewModel.scheduleMainValue
        fare.text = viewModel.fare
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "supplier_logo_placeholder")
        fareType.text = viewModel.fareType
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        bottomImage.load(imageURL: viewModel.logoImageURL,
            placeholderImageName: "supplier_logo_placeholder")
        fleetName.text = viewModel.fleetName
    }
    
    func resetView() {
        name.text = nil
        eta.text = nil
        fare.text = nil
        fareType.text = nil
        logoLoadingImageView.cancel()
    }
}
