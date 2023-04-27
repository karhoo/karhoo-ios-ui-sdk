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

    // MARK: - Nested types
    
    private enum CustomConstants {
        static let logoImageViewHieght: CGFloat = 60
        static let logoImageViewWidth: CGFloat = 64
        static let badgeWidth: CGFloat = 24
        static let badgeHeight: CGFloat = 22.6
    }

    // MARK: - Properties

    private var viewModel: QuoteViewModel?
    // Constraints for both ASAP and Scheduled states. ASAP layout as default.
    private lazy var constraintsForScheduledQuote: [NSLayoutConstraint] = [priceDetailsStack.centerYAnchor.constraint(equalTo: vehicleContainerView.centerYAnchor)]
    private lazy var constraintsForASAPQuote: [NSLayoutConstraint] = [fareLabel.lastBaselineAnchor.constraint(equalTo: etaLabel.lastBaselineAnchor)]

    // MARK: - Views

    private lazy var viewWithBorder = UIView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.CornerRadius.large
        view.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        view.layer.borderColor = KarhooUI.colors.border.cgColor
        view.backgroundColor = KarhooUI.colors.white
    }
    private lazy var containerStack = UIStackView().then { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = KHQuoteViewID.containerStackView
        stack.axis = .vertical
        stack.alignment = .fill
        stack.clipsToBounds = true
        stack.layer.cornerRadius = UIConstants.CornerRadius.large
    }
    private lazy var topContentContainer = UIView()
    private lazy var topContentStack = UIStackView().then { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = UIConstants.Spacing.medium
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.clipsToBounds = true
    }
    private lazy var leftContentStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
    }
    private lazy var rightContentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var vehicleContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var logoLoadingImageView = LoadingImageView().then { logo in
        logo.accessibilityIdentifier = KHQuoteViewID.logoImage
        logo.contentMode = .scaleAspectFill
        logo.layer.masksToBounds = true
    }
    private lazy var badgeImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.layer.masksToBounds = true
    }

    private lazy var vehicleTypeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHQuoteViewID.name
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.bodySemibold()
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private lazy var rideDetailStackView = UIStackView().then { rideDetailStackView in
        rideDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        rideDetailStackView.accessibilityIdentifier = KHQuoteViewID.rideDetailsStackView
        rideDetailStackView.axis = .vertical
        rideDetailStackView.alignment = .leading
        rideDetailStackView.spacing = UIConstants.Spacing.xSmall
    }
    private lazy var vehicleCapacityView = QuoteVehicleCapacityView()
    private lazy var capacityAndPickupTypeContainer = UIStackView().then { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = KHQuoteViewID.capacityStackView
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 10.0
    }
    private lazy var detailsButton = UIButton().then { button in
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHQuoteViewID.detailsButton
        button.backgroundColor = KarhooUI.colors.accent
        button.setTitleColor(KarhooUI.colors.white, for: .normal)
        button.titleLabel?.font = KarhooUI.fonts.footnoteRegular()
        button.setTitle(UITexts.QuoteCell.details, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = UIConstants.CornerRadius.large
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        // button temporary hidden, uncomment when Qoute details page will be implemented
        button.isHidden = true
    }
    private lazy var etaStack = UIStackView().then { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = KHQuoteViewID.etaStackView
        stack.axis = .vertical
        stack.alignment = .leading
    }
    private lazy var etaLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHQuoteViewID.eta
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .right
        label.font = KarhooUI.fonts.headerBold()
        label.textColor = KarhooUI.colors.text
    }
    private lazy var etaDescriptionLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHQuoteViewID.etaDescription
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .right
        label.font = KarhooUI.fonts.footnoteRegular()
        label.textColor = KarhooUI.colors.text
        label.text = UITexts.QuoteCell.driverArrival
    }
    private lazy var priceDetailsStack = UIStackView().then { priceDetailsStack in
        priceDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        priceDetailsStack.accessibilityIdentifier = KHQuoteViewID.priceStackView
        priceDetailsStack.axis = .vertical
    }
    
    private lazy var fareLabel = UILabel().then { fareLabel in
        fareLabel.translatesAutoresizingMaskIntoConstraints = false
        fareLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        fareLabel.accessibilityIdentifier = KHQuoteViewID.fare
        fareLabel.textAlignment = .right
        fareLabel.font = KarhooUI.fonts.headerBold()
        fareLabel.textColor = KarhooUI.colors.text
    }
    
    private lazy var fareTypeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHQuoteViewID.fareType
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.textAlignment = .right
        $0.font = KarhooUI.fonts.footnoteRegular()
        $0.textColor = KarhooUI.colors.text
    }
    
    private lazy var lineSeparator = LineView(
        color: KarhooUI.colors.border,
        accessibilityIdentifier: KHQuoteViewID.lineSeparator
    )
    private lazy var bottomStack = UIStackView().then { stack in
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = KHQuoteViewID.bottomStack
        stack.alignment = .leading
        stack.axis = .horizontal
        stack.spacing = UIConstants.Spacing.xSmall
    }
    private lazy var bottomStackContainer = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHQuoteViewID.bottomStackContainer
        view.backgroundColor = KarhooUI.colors.background1
    }
    private lazy var bottomImage = LoadingImageView().then { logo in
        logo.accessibilityIdentifier = KHQuoteViewID.logoImage
        logo.layer.masksToBounds = true
    }
    private lazy var fleetNameLabel = UILabel().then { fleetName in
        fleetName.translatesAutoresizingMaskIntoConstraints = false
        fleetName.accessibilityIdentifier = KHQuoteViewID.fleetName
        fleetName.textColor = KarhooUI.colors.text
        fleetName.font = KarhooUI.fonts.footnoteBold()
        fleetName.numberOfLines = 0
        fleetName.lineBreakMode = .byWordWrapping
    }

    // MARK: - Lifecycle

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
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHQuoteViewID.quoteView
    }

    private func setupHierarchy() {
        addSubview(viewWithBorder)
        viewWithBorder.addSubview(containerStack)
        containerStack.addArrangedSubview(topContentContainer)
        topContentContainer.addSubview(topContentStack)
        topContentStack.addArrangedSubview(leftContentStack)
        topContentStack.addArrangedSubview(rightContentView)
        leftContentStack.addArrangedSubview(vehicleContainerView)
        vehicleContainerView.addSubview(logoLoadingImageView)
        vehicleContainerView.addSubview(badgeImageView)
        vehicleContainerView.addSubview(rideDetailStackView)
        rideDetailStackView.addArrangedSubview(vehicleTypeLabel)
        rideDetailStackView.addArrangedSubview(vehicleCapacityView)

        leftContentStack.addArrangedSubview(etaStack)
        rightContentView.addSubview(priceDetailsStack)

        etaStack.addArrangedSubview(etaLabel)
        etaStack.addArrangedSubview(etaDescriptionLabel)
        priceDetailsStack.addArrangedSubview(fareLabel)
        priceDetailsStack.addArrangedSubview(fareTypeLabel)

        containerStack.addArrangedSubview(lineSeparator)
        containerStack.addArrangedSubview(bottomStackContainer)
        bottomStackContainer.addSubview(bottomStack)
        bottomStack.addArrangedSubview(bottomImage)
        bottomStack.addArrangedSubview(fleetNameLabel)
    }
    
    private func setupLayout() {
        containerStack.anchorToSuperview()
        viewWithBorder.anchorToSuperview(
            paddingTop: UIConstants.Spacing.small,
            paddingLeading: UIConstants.Spacing.medium,
            paddingTrailing: UIConstants.Spacing.medium,
            paddingBottom: UIConstants.Spacing.small
        )
        topContentStack.anchorToSuperview(padding: UIConstants.Spacing.small)
        
        logoLoadingImageView.anchor(
            top: vehicleContainerView.topAnchor,
            left: vehicleContainerView.leftAnchor,
            right: rideDetailStackView.leftAnchor,
            bottom: vehicleContainerView.bottomAnchor,
            paddingRight: UIConstants.Spacing.small,
            width: CustomConstants.logoImageViewWidth,
            height: CustomConstants.logoImageViewHieght
        )
        badgeImageView.anchor(
            top: logoLoadingImageView.topAnchor,
            trailing: logoLoadingImageView.trailingAnchor,
            width: CustomConstants.badgeWidth,
            height: CustomConstants.badgeHeight
        )
        rideDetailStackView.anchor(
            top: vehicleContainerView.topAnchor,
            right: vehicleContainerView.rightAnchor,
            bottom: vehicleContainerView.bottomAnchor,
            paddingTop: UIConstants.Spacing.xSmall,
            paddingRight: UIConstants.Spacing.small
        )
        priceDetailsStack.anchor(
            left: rightContentView.leftAnchor,
            right: viewWithBorder.rightAnchor,
            paddingRight: UIConstants.Spacing.medium
        )
        constraintsForASAPQuote.forEach { $0.isActive = true }

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
        bottomImage.anchor(width: UIConstants.Dimension.Icon.medium, height: UIConstants.Dimension.Icon.medium)
    }

    private func setScheduledDesign() {
        constraintsForASAPQuote.forEach { $0.isActive = false }
        constraintsForScheduledQuote.forEach { $0.isActive = true }
        etaStack.isHidden = true
    }

    private func setASAPDesign() {
        constraintsForASAPQuote.forEach { $0.isActive = true }
        constraintsForScheduledQuote.forEach { $0.isActive = false }
        etaStack.isHidden = false
    }

    // MARK: - Endpoints
    
    func set(viewModel: QuoteViewModel) {
        self.viewModel = viewModel
        vehicleTypeLabel.text = viewModel.vehicleType
        etaLabel.text = viewModel.scheduleMainValue
        fareLabel.text = viewModel.fare
        logoLoadingImageView.load(
            imageURL: viewModel.vehicleImageURL ?? viewModel.logoImageURL,
            placeholderImageName: "kh_uisdk_supplier_logo_placeholder",
            completion: { [weak self] _ in
                self?.badgeImageView.isHidden = false
            }
        )
        // remove comment to enable showing vehicle badge
//        badgeImageView.image = viewModel.vehicleBadgeImage
        fareTypeLabel.text = viewModel.fareType
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.luggageCapacity)
        bottomImage.load(imageURL: viewModel.logoImageURL,
            placeholderImageName: "kh_uisdk_supplier_logo_placeholder")
        fleetNameLabel.text = viewModel.fleetName
        
        viewModel.isScheduled ? setScheduledDesign() : setASAPDesign()
    }

    func resetView() {
        vehicleTypeLabel.text = nil
        etaLabel.text = nil
        fareLabel.text = nil
        fareTypeLabel.text = nil
        logoLoadingImageView.cancel()
    }
}
