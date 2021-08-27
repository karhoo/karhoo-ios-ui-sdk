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

final class FormCheckoutHeaderView: UIView {
    
    private var didSetupConstraints: Bool = false
    
    private var topStackView: UIStackView = {
        let topStackView = UIStackView()
        topStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.topInfoContainer
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.alignment = .center
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10
        
        return topStackView
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
    
    private lazy var rideDetailStackView: UIStackView = {
        let rideDetailStackView = UIStackView()
        rideDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        rideDetailStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideDetailsContainer
        rideDetailStackView.axis = .vertical
        rideDetailStackView.spacing = 4.0
        
        return rideDetailStackView
    }()
    
    private lazy var logoLoadingImageView: LoadingImageView = {
        let logoLoadingImageView = LoadingImageView()
        logoLoadingImageView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.logo
        logoLoadingImageView.layer.cornerRadius = 5.0
        logoLoadingImageView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        logoLoadingImageView.layer.borderWidth = 0.5
        logoLoadingImageView.layer.masksToBounds = true
        
        return logoLoadingImageView
    }()
    
    private lazy var name: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.accessibilityIdentifier = KHFormCheckoutHeaderViewID.name
        name.textColor = KarhooUI.colors.infoColor
        name.font = KarhooUI.fonts.getBoldFont(withSize: 16.0)
        name.numberOfLines = 0
        
        return name
    }()
    
    private lazy var carType: UILabel = {
        let carType = UILabel()
        carType.translatesAutoresizingMaskIntoConstraints = false
        carType.accessibilityIdentifier = KHFormCheckoutHeaderViewID.carType
        carType.font = KarhooUI.fonts.getBoldFont(withSize: 14.0)
        carType.textColor = KarhooUI.colors.guestCheckoutLightGrey
        
        return carType
    }()
    
    private var vehicleCapacityView: VehicleCapacityView!
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(viewModel: QuoteViewModel) {
        self.init()
        self.set(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHFormCheckoutHeaderViewID.view
        
        addSubview(topStackView)
        
        topStackView.addArrangedSubview(logoLoadingImageView)
        topStackView.addArrangedSubview(rideDetailStackView)
        
        vehicleCapacityView = VehicleCapacityView()
        topStackView.addArrangedSubview(vehicleCapacityView)
        
        rideDetailStackView.addArrangedSubview(name)
        rideDetailStackView.addArrangedSubview(carType)
        rideDetailStackView.addArrangedSubview(fleetCapabilitiesStackView)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            let logoSize: CGFloat = 60.0
            logoLoadingImageView.anchor(width: logoSize,
                                        height: logoSize)
            
            topStackView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                paddingTop: 20.0,
                                paddingLeft: 10.0,
                                paddingRight: 10.0)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func setVehicleTags(viewModel: QuoteViewModel) {
        if viewModel.vehicleTags.count >= 2 {
            let firstTwoCarTags = viewModel.vehicleTags.prefix(2)
            firstTwoCarTags.forEach {
                setupView(for: $0)
            }
            if viewModel.vehicleTags.count > 2 {
                let label = UILabel()
                label.text = "+\(viewModel.vehicleTags.count - 2)"
                label.font = KarhooUI.fonts.getRegularFont(withSize: 9.0)
                label.textColor = KarhooUI.colors.darkGrey
                fleetCapabilitiesStackView.addArrangedSubview(label)
            }
        } else {
            viewModel.vehicleTags.forEach {
                setupView(for: $0)
            }
        }
    }
    
    private func setupView(for vehicleTag: VehicleTag) {
        let image = UIImageView()
        image.image = vehicleTag.image
        image.contentMode = .scaleAspectFit
        image.anchor(width: 12.0, height: 12.0)
        image.tintColor = KarhooUI.colors.guestCheckoutLightGrey
        
        let label = UILabel()
        label.text = vehicleTag.title
        label.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        label.textColor = KarhooUI.colors.guestCheckoutLightGrey
        fleetCapabilitiesStackView.addArrangedSubview(image)
        fleetCapabilitiesStackView.addArrangedSubview(label)
    }
    
    func set(viewModel: QuoteViewModel) {
        name.text = viewModel.fleetName
        carType.text = viewModel.carType
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "supplier_logo_placeholder")
        logoLoadingImageView.setStandardBorder()
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        vehicleCapacityView.setAdditionalFleetCapabilities(viewModel.fleetCapabilities.count)
        setVehicleTags(viewModel: viewModel)
        
        updateConstraints()
    }
    
    func hideVehicleCapacityView() {
        vehicleCapacityView.alpha = 0.0
    }
    
    func displayVehicleCapacityView() {
        vehicleCapacityView.alpha = 1.0
    }
}
