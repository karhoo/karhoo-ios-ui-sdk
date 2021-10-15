//
//  GuestCheckoutHeaderView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHFormCheckoutHeaderViewID {
    public static let topInfoContainer = "ride_top_info_container"
    public static let view = "guest_checkout_header_view"
    public static let logo = "logo_image"
    public static let rideDetailsContainer = "ride_details_stack_view"
    public static let name = "name_label"
    public static let rideInfoView = "ride_info_view"
    public static let etaTitle = "eta_title_label"
    public static let etaText = "eta_text_label"
    public static let rideType = "ride_type_label"
    public static let estimatedPrice = "estimated_price_title_label"
    public static let priceText = "price_text_label"
    public static let ridePriceType = "ride_price_type_label"
    public static let ridePriceTypeIcon = "ride_price_type_icon"
    public static let carType = "car_type_label"
    public static let fleetCapabilities = "fleet_capabilties_stack_view"
    public static let cancellationInfo = "cancellationInfo_label"
}

final class FormCheckoutHeaderView: UIStackView {
    //MARK: - UI
    private lazy var logoLoadingImageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.logo
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var rideDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideDetailsContainer
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHFormCheckoutHeaderViewID.name
        label.textColor = KarhooUI.colors.infoColor
        label.font = KarhooUI.fonts.getBoldFont(withSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var carTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHFormCheckoutHeaderViewID.carType
        label.font = KarhooUI.fonts.getBoldFont(withSize: 14.0)
        label.textColor = KarhooUI.colors.guestCheckoutLightGrey
        return label
    }()
    
    private var fleetCapabilitiesStackView: UIStackView = {
        let fleetCapabilitiesStackView = UIStackView()
        fleetCapabilitiesStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.fleetCapabilities
        fleetCapabilitiesStackView.translatesAutoresizingMaskIntoConstraints = false
        fleetCapabilitiesStackView.alignment = .leading
        fleetCapabilitiesStackView.distribution = .fillProportionally
        fleetCapabilitiesStackView.spacing = 5
        return fleetCapabilitiesStackView
    }()
    
    private lazy var vehicleCapacityView: VehicleCapacityView = {
        let view =  VehicleCapacityView()
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
        accessibilityIdentifier = KHFormCheckoutHeaderViewID.topInfoContainer
        translatesAutoresizingMaskIntoConstraints = false
        alignment = .center
        distribution = .fillProportionally
        spacing = 10
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(logoLoadingImageView)
        addArrangedSubview(rideDetailStackView)
        addArrangedSubview(vehicleCapacityView)
        
        rideDetailStackView.addArrangedSubview(nameLabel)
        rideDetailStackView.addArrangedSubview(carTypeLabel)
        rideDetailStackView.addArrangedSubview(fleetCapabilitiesStackView)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            let logoSize: CGFloat = 60.0
            logoLoadingImageView.anchor(width: logoSize,
                                        height: logoSize)
            
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        nameLabel.text = viewModel.fleetName
        carTypeLabel.text = viewModel.carType
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "supplier_logo_placeholder")
        logoLoadingImageView.setStandardBorder()
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        vehicleCapacityView.setAdditionalFleetCapabilities(viewModel.fleetCapabilities.count)
        setVehicleTags(viewModel: viewModel)
        
        updateConstraints()
    }
    
    private func setVehicleTags(viewModel: QuoteViewModel) {
        if viewModel.vehicleTags.count > 0 {
            let firstTag = viewModel.vehicleTags[0]
            setupView(for: firstTag)
            
            if viewModel.vehicleTags.count > 1 {
                let label = UILabel()
                label.text = "+\(viewModel.vehicleTags.count - 1)"
                label.font = KarhooUI.fonts.getRegularFont(withSize: 9.0)
                label.textColor = KarhooUI.colors.darkGrey
                fleetCapabilitiesStackView.addArrangedSubview(label)
            }
        }
    }
    
    private func setupView(for vehicleTag: VehicleTag) {
        let imageView = UIImageView()
        imageView.image = vehicleTag.image
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: 12.0, height: 12.0)
        imageView.tintColor = KarhooUI.colors.guestCheckoutLightGrey
        
        let label = UILabel()
        label.text = vehicleTag.title
        label.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        label.textColor = KarhooUI.colors.guestCheckoutLightGrey
        fleetCapabilitiesStackView.addArrangedSubview(imageView)
        fleetCapabilitiesStackView.addArrangedSubview(label)
    }
    
    //MARK: - Utils
    func hideVehicleCapacityView() {
        vehicleCapacityView.alpha = 0.0
    }
    
    func displayVehicleCapacityView() {
        vehicleCapacityView.alpha = 1.0
    }
}
