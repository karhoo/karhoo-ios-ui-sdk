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
    public static let carType = "car_type_label"
    public static let cancellationInfo = "cancellationInfo_label"
}

final class FormCheckoutHeaderView: UIView {
    
    private var didSetupConstraints: Bool = false
    
    private var verticalTopStackView: UIStackView!
    private var middleStackView: UIStackView!
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
    private var rideTypeLabel: UILabel!
    private var priceTitle: UILabel!
    private var priceText: UILabel!
    private var ridePriceType: UILabel!
    
    private lazy var learnMoreButton: UIButton = {
        let learnMoreButton = UIButton(frame: .zero)
        learnMoreButton.translatesAutoresizingMaskIntoConstraints = false
        learnMoreButton.setTitle("Learn more", for: .normal)
        learnMoreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        learnMoreButton.setTitleColor(KarhooUI.colors.accent, for: .normal)
        learnMoreButton.anchor(width: 80)
        return learnMoreButton
    }()
    
    private lazy var dropdownIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.uisdkImage("dropdownIcon")
        imageView.tintColor = KarhooUI.colors.accent
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: 16)
        return imageView
    }()
    
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

        verticalTopStackView = UIStackView()
        verticalTopStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalTopStackView.alignment = .center
        verticalTopStackView.axis = .vertical
        verticalTopStackView.distribution = .equalSpacing
        verticalTopStackView.spacing = 10
        addSubview(verticalTopStackView)
        
        topStackView = UIStackView()
        topStackView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.topInfoContainer
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.alignment = .center
        topStackView.distribution = .fill
        topStackView.spacing = 10
        verticalTopStackView.addArrangedSubview(topStackView)
        
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
        name.textColor = KarhooUI.colors.infoColor
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
        
        middleStackView = UIStackView()
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        middleStackView.axis = .horizontal
        middleStackView.spacing = 8
        middleStackView.distribution = .fillProportionally
        
        middleStackView.addArrangedSubview(cancellationInfo)
        middleStackView.addArrangedSubview(learnMoreButton)
        middleStackView.addArrangedSubview(dropdownIconImage)
        
        verticalTopStackView.addArrangedSubview(middleStackView)
        
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
        scheduleCaption.textColor = KarhooUI.colors.infoColor
        scheduleCaption.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        scheduleCaption.text = UITexts.Generic.etaLong
        rideInfoView.addSubview(scheduleCaption)
        
        scheduleMainValue = UILabel()
        scheduleMainValue.translatesAutoresizingMaskIntoConstraints = false
        scheduleMainValue.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaText
        scheduleMainValue.textColor = KarhooUI.colors.infoColor
        scheduleMainValue.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        rideInfoView.addSubview(scheduleMainValue)
        
        rideTypeLabel = UILabel()
        rideTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        rideTypeLabel.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideType
        rideTypeLabel.textColor = KarhooUI.colors.infoColor
        rideTypeLabel.text = UITexts.Generic.meetGreet
        rideTypeLabel.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        rideInfoView.addSubview(rideTypeLabel)

        priceTitle = UILabel()
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.accessibilityIdentifier = KHFormCheckoutHeaderViewID.estimatedPrice
        priceTitle.textColor = KarhooUI.colors.infoColor
        priceTitle.textAlignment = .right
        priceTitle.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        priceTitle.text = UITexts.Generic.estimatedPrice.uppercased()
        rideInfoView.addSubview(priceTitle)
        
        priceText = UILabel()
        priceText.translatesAutoresizingMaskIntoConstraints = false
        priceText.accessibilityIdentifier = KHFormCheckoutHeaderViewID.priceText
        priceText.textColor = KarhooUI.colors.infoColor
        priceText.textAlignment = .right
        priceText.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        rideInfoView.addSubview(priceText)
        
        ridePriceType = UILabel()
        ridePriceType.translatesAutoresizingMaskIntoConstraints = false
        ridePriceType.accessibilityIdentifier = KHFormCheckoutHeaderViewID.ridePriceType
        ridePriceType.textColor = KarhooUI.colors.accent
        ridePriceType.textAlignment = .right
        ridePriceType.text = "Metered"
        ridePriceType.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        rideInfoView.addSubview(ridePriceType)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            let logoSize: CGFloat = 60.0
            logoLoadingImageView.anchor(width: logoSize, height: logoSize)

            verticalTopStackView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 20.0)

            middleStackView.anchor(leading: verticalTopStackView.leadingAnchor, trailing: verticalTopStackView.trailingAnchor)
            
            topStackView.anchor(top: verticalTopStackView.topAnchor, leading: verticalTopStackView.leadingAnchor, trailing: verticalTopStackView.trailingAnchor)

            vehicleCapacityView.setContentHuggingPriority(.required, for: .horizontal)
            
            rideInfoView.anchor(top: verticalTopStackView.bottomAnchor, leading: verticalTopStackView.leadingAnchor, bottom: bottomAnchor, trailing: verticalTopStackView.trailingAnchor, paddingTop: 15.0, paddingLeft: 10.0, paddingRight: 10.0)
            
            [scheduleCaption.leadingAnchor.constraint(equalTo: rideInfoView.leadingAnchor, constant: 10.0),
             scheduleCaption.topAnchor.constraint(equalTo: rideInfoView.topAnchor, constant: 10.0),
             scheduleCaption.trailingAnchor.constraint(lessThanOrEqualTo: priceTitle.leadingAnchor,
                                                constant: 20.0)].forEach { $0.isActive = true }
            
            rideTypeLabel.anchor(leading: rideInfoView.leadingAnchor, bottom: rideInfoView.bottomAnchor, trailing: rideInfoView.trailingAnchor, paddingTop: 10.0, paddingLeft: 10.0, paddingBottom: 10.0)
            
            [scheduleMainValue.leadingAnchor.constraint(equalTo: scheduleCaption.leadingAnchor),
             scheduleMainValue.topAnchor.constraint(equalTo: scheduleCaption.bottomAnchor, constant: 5.0),
             scheduleMainValue.trailingAnchor.constraint(lessThanOrEqualTo: priceText.leadingAnchor, constant: 20.0),
             scheduleMainValue.bottomAnchor.constraint(equalTo: rideTypeLabel.topAnchor, constant: -10.0)]
                .forEach { $0.isActive = true }
            
            priceTitle.anchor(top: rideInfoView.topAnchor, trailing: rideInfoView.trailingAnchor, paddingTop: 10.0, paddingRight: 10.0)
            
            priceText.anchor(top: priceTitle.bottomAnchor, bottom: ridePriceType.topAnchor, trailing: priceTitle.trailingAnchor, paddingTop: 5.0, paddingBottom: 10.0)
            
            ridePriceType.anchor(bottom: rideInfoView.bottomAnchor, trailing: rideInfoView.trailingAnchor, paddingBottom: 10.0, paddingRight: 10.0)
            
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
