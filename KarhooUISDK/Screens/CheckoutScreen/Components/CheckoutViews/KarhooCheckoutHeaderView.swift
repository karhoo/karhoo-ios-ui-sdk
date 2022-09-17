//
//  KarhooCheckoutHeaderView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHCheckoutHeaderViewID {
    public static let topContainer = "top_container"
    public static let fleetInfoContainer = "fleet_info_container"
    public static let logoContainer = "logo_container"
    public static let logoImageView = "logo_image_view"
    public static let rideDetailsContainer = "ride_details_stack_view"
    public static let nameLabel = "name_label"
    public static let rideInfoView = "ride_info_view"
    public static let etaTitle = "eta_title_label"
    public static let etaText = "eta_text_label"
    public static let rideType = "ride_type_label"
    public static let estimatedPrice = "estimated_price_title_label"
    public static let priceText = "price_text_label"
    public static let ridePriceType = "ride_price_type_label"
    public static let ridePriceTypeIcon = "ride_price_type_icon"
    public static let carType = "car_type_label"
    public static let capabilitiesContentView = "capabilities_content_view"
    public static let fleetCapabilities = "fleet_capabilties_stack_view"
    public static let cancellationInfo = "cancellationInfo_label"
    public static let fleetCapabilitiesLabel = "fleetCapabilities_label"
    public static let learnMoreButton = "learn_more_button"
    public static let capabilitiesDetailsView = "capabilities_details_view"
    public static let vehicleCapacityView = "vehicle_capacity_view"
}

final class KarhooCheckoutHeaderView: UIStackView {
    // MARK: - UI
    private lazy var fleetInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHCheckoutHeaderViewID.fleetInfoContainer
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // Note: This view was added so thet the fleetInfoStackView could have it's children properly aligned on the vertical axis, yet not stretch the logoLoadingImageView to fit the height
    // Because the image is loaded from a URL, and not from xcassets, it doesn't scale properly, so setting the content mode to .scaleAspectFit doesn't help
    private lazy var logoContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHCheckoutHeaderViewID.logoContainer
        return view
    }()
    
    private lazy var logoLoadingImageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = UITexts.TripSummary.fleet
        imageView.accessibilityIdentifier = KHCheckoutHeaderViewID.logoImageView
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderColor = KarhooUI.colors.border.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var rideDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHCheckoutHeaderViewID.rideDetailsContainer
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHCheckoutHeaderViewID.nameLabel
        label.textColor = KarhooUI.colors.text
        label.font = KarhooUI.fonts.getBoldFont(withSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var carTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHCheckoutHeaderViewID.carType
        label.font = KarhooUI.fonts.getBoldFont(withSize: 14.0)
        label.textColor = KarhooUI.colors.textLabel
        return label
    }()
    
    private var vehicleTagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHCheckoutHeaderViewID.fleetCapabilities
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var capacityContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHCheckoutHeaderViewID.capabilitiesContentView
        return view
    }()
    
    private lazy var vehicleCapacityView: VehicleCapacityView = {
        let view =  VehicleCapacityView()
        view.accessibilityIdentifier = KHCheckoutHeaderViewID.vehicleCapacityView
        return view
    }()

    lazy var capacityDetailsView: KarhooFleetCapabilitiesDetailsView = {
        let view = KarhooFleetCapabilitiesDetailsView()
        view.accessibilityIdentifier = KHCheckoutHeaderViewID.capabilitiesDetailsView
        return view
    }()

    //MARK: - Variables
    private var didSetupConstraints: Bool = false
    
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(viewModel: QuoteViewModel) {
        self.init()
        self.set(viewModel: viewModel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setUpView() {
        accessibilityIdentifier = KHCheckoutHeaderViewID.topContainer
        translatesAutoresizingMaskIntoConstraints = false
        alignment = .fill
        distribution = .fill
        axis = .vertical
        spacing = 10
        
        // TODO: Move this line along with the directionalLayoutMargins line to CheckoutViewController
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(fleetInfoStackView)
        fleetInfoStackView.addArrangedSubview(logoContentView)
        fleetInfoStackView.addArrangedSubview(rideDetailStackView)
        fleetInfoStackView.addArrangedSubview(capacityContentView)
        
        logoContentView.addSubview(logoLoadingImageView)
        
        rideDetailStackView.addArrangedSubview(nameLabel)
        rideDetailStackView.addArrangedSubview(carTypeLabel)
        rideDetailStackView.addArrangedSubview(vehicleTagsStackView)
        capacityContentView.addSubview(vehicleCapacityView)

        addArrangedSubview(capacityDetailsView)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            // TODO: move the padding to the CheckoutViewController when applying the standardization to the CheckoutViewController
            // The controls inside the header view should be glued to the edges. The parent decides how much margin to add to it
            // This is a good practice to make the header view reusable in other contexts that may not need the values set below.
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
            
            logoLoadingImageView.anchor(
                    top: logoContentView.topAnchor,
                    leading: logoContentView.leadingAnchor,
                    trailing: logoContentView.trailingAnchor,
                    width: 60.0,
                    height: 60.0
            )
            logoLoadingImageView.bottomAnchor.constraint(
                lessThanOrEqualTo: logoContentView.bottomAnchor,
                constant: UIConstants.Spacing.small
            ).isActive = true

            vehicleCapacityView.anchor(
                    top: capacityContentView.topAnchor,
                    leading: capacityContentView.leadingAnchor,
                    trailing: capacityContentView.trailingAnchor
            )

            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        nameLabel.text = viewModel.fleetName
        carTypeLabel.text = viewModel.vehicleType.capitalized
        
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "kh_supplier_logo_placeholder")
        logoLoadingImageView.setStandardBorder()
        
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        setVehicleTags(viewModel: viewModel)
        capacityDetailsView.set(viewModel: viewModel)
        updateConstraints()
    }
    
    private func setVehicleTags(viewModel: QuoteViewModel) {
        if viewModel.vehicleTags.count > 0 {
            let firstTag = viewModel.vehicleTags[0]
            setupView(for: firstTag)
        } else {
            vehicleTagsStackView.isHidden = true
        }
    }
    
    private func setupView(for vehicleTag: VehicleTag) {
        let imageView = UIImageView()
        imageView.image = vehicleTag.image
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: 12.0, height: 12.0)
        imageView.tintColor = KarhooUI.colors.text
        
        let label = UILabel()
        label.text = vehicleTag.title
        label.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        label.textColor = KarhooUI.colors.text
        vehicleTagsStackView.addArrangedSubview(imageView)
        vehicleTagsStackView.addArrangedSubview(label)
    }
}
