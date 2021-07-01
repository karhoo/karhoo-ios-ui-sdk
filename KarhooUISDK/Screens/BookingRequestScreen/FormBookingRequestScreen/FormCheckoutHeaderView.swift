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
    public static let estimatedPrice = "estimated_price_title_label"
    public static let priceText = "price_text_label"
    public static let carType = "car_type_label"
    public static let cancellationInfo = "cancellationInfo_label"
}

final class FormCheckoutHeaderView: UIView {
    
    private var didSetupConstraints: Bool = false
    
    private var topStackView: UIStackView!
    private var logoLoadingImageView: LoadingImageView!
    private var rideDetailStackView: UIStackView!
    private var name: UILabel!
    private var carType: UILabel!
    private var cancellationInfo: UILabel!
    private var vehicleCapacityView: VehicleCapacityView!
    
    private var rideInfoView: UIView!
    private var scheduleCaption: UILabel!
    private var scheduleMainValue: UILabel!
    private var priceTitle: UILabel!
    private var priceText: UILabel!
    
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

        topStackView = UIStackView()
        topStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.topInfoContainer
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topStackView.spacing = 10
        addSubview(topStackView)
        
        logoLoadingImageView = LoadingImageView()
        logoLoadingImageView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.logo
        logoLoadingImageView.layer.cornerRadius = 5.0
        logoLoadingImageView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        logoLoadingImageView.layer.borderWidth = 0.5
        logoLoadingImageView.layer.masksToBounds = true
        topStackView.addArrangedSubview(logoLoadingImageView)
        
        rideDetailStackView = UIStackView()
        rideDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        rideDetailStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideDetailsContainer
        rideDetailStackView.axis = .vertical
        rideDetailStackView.spacing = 8.0
        topStackView.addArrangedSubview(rideDetailStackView)
        
        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.accessibilityIdentifier = KHFormCheckoutHeaderViewID.name
        name.textColor = KarhooUI.colors.black
        name.font = KarhooUI.fonts.getBoldFont(withSize: 16.0)
        name.numberOfLines = 0
        rideDetailStackView.addArrangedSubview(name)
        
        carType = UILabel()
        carType.translatesAutoresizingMaskIntoConstraints = false
        carType.accessibilityIdentifier = KHFormCheckoutHeaderViewID.carType
        carType.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        carType.textColor = KarhooUI.colors.guestCheckoutLightGrey
        rideDetailStackView.addArrangedSubview(carType)

        cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = KHFormCheckoutHeaderViewID.cancellationInfo
        cancellationInfo.font = KarhooUI.fonts.captionRegular()
        cancellationInfo.textColor = KarhooUI.colors.accent
        cancellationInfo.numberOfLines = 0
        rideDetailStackView.addArrangedSubview(cancellationInfo)
        
        vehicleCapacityView = VehicleCapacityView()
        topStackView.addArrangedSubview(vehicleCapacityView)
        
        rideInfoView = UIView()
        rideInfoView.translatesAutoresizingMaskIntoConstraints = false
        rideInfoView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideInfoView
        rideInfoView.backgroundColor = KarhooUI.colors.guestCheckoutLightGrey
        rideInfoView.layer.masksToBounds = true
        rideInfoView.layer.cornerRadius = 8.0
        addSubview(rideInfoView)
        
        scheduleCaption = UILabel()
        scheduleCaption.translatesAutoresizingMaskIntoConstraints = false
        scheduleCaption.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaTitle
        scheduleCaption.textColor = KarhooUI.colors.white
        scheduleCaption.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        scheduleCaption.text = UITexts.Generic.etaLong.uppercased()
        rideInfoView.addSubview(scheduleCaption)
        
        scheduleMainValue = UILabel()
        scheduleMainValue.translatesAutoresizingMaskIntoConstraints = false
        scheduleMainValue.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaText
        scheduleMainValue.textColor = KarhooUI.colors.white
        scheduleMainValue.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        rideInfoView.addSubview(scheduleMainValue)

        priceTitle = UILabel()
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.accessibilityIdentifier = KHFormCheckoutHeaderViewID.estimatedPrice
        priceTitle.textColor = KarhooUI.colors.white
        priceTitle.textAlignment = .right
        priceTitle.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        priceTitle.text = UITexts.Generic.estimatedPrice.uppercased()
        rideInfoView.addSubview(priceTitle)
        
        priceText = UILabel()
        priceText.translatesAutoresizingMaskIntoConstraints = false
        priceText.accessibilityIdentifier = KHFormCheckoutHeaderViewID.priceText
        priceText.textColor = KarhooUI.colors.white
        priceText.textAlignment = .right
        priceText.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        rideInfoView.addSubview(priceText)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            let logoSize: CGFloat = 60.0
            [logoLoadingImageView.widthAnchor.constraint(equalToConstant: logoSize),
             logoLoadingImageView.heightAnchor.constraint(equalToConstant: logoSize)]
                .forEach { $0.isActive = true }
            
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0).isActive = true
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

            vehicleCapacityView.setContentHuggingPriority(.required, for: .horizontal)
            
            [rideInfoView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 15.0),
             rideInfoView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10.0),
             rideInfoView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -10.0),
             rideInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)].forEach { $0.isActive = true }
            
            [scheduleCaption.leadingAnchor.constraint(equalTo: rideInfoView.leadingAnchor, constant: 10.0),
             scheduleCaption.topAnchor.constraint(equalTo: rideInfoView.topAnchor, constant: 10.0),
             scheduleCaption.trailingAnchor.constraint(lessThanOrEqualTo: priceTitle.leadingAnchor,
                                                constant: 20.0)].forEach { $0.isActive = true }
            
            [scheduleMainValue.leadingAnchor.constraint(equalTo: scheduleCaption.leadingAnchor),
             scheduleMainValue.topAnchor.constraint(equalTo: scheduleCaption.bottomAnchor, constant: 5.0),
             scheduleMainValue.trailingAnchor.constraint(lessThanOrEqualTo: priceText.leadingAnchor, constant: 20.0),
             scheduleMainValue.bottomAnchor.constraint(equalTo: rideInfoView.bottomAnchor, constant: -10.0)]
                .forEach { $0.isActive = true }
            
            [priceTitle.trailingAnchor.constraint(equalTo: rideInfoView.trailingAnchor, constant: -10.0),
             priceTitle.topAnchor.constraint(equalTo: rideInfoView.topAnchor,
                                             constant: 10.0)].forEach { $0.isActive = true }
            
            [priceText.trailingAnchor.constraint(equalTo: priceTitle.trailingAnchor),
             priceText.topAnchor.constraint(equalTo: priceTitle.bottomAnchor, constant: 5.0),
             priceText.bottomAnchor.constraint(equalTo: rideInfoView.bottomAnchor,
                                               constant: -10.0)].forEach { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        name.text = viewModel.fleetName
        scheduleCaption.text = viewModel.scheduleCaption
        scheduleMainValue.text = viewModel.scheduleMainValue
        carType.text = viewModel.carType
        cancellationInfo.text = viewModel.freeCancellationMessage
        cancellationInfo.isHidden = viewModel.freeCancellationMessage == nil
        priceText.text = viewModel.fare
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "supplier_logo_placeholder")
        logoLoadingImageView.setStandardBorder()
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        
        updateConstraints()
    }
}
