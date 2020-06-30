//
//  QuoteView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHQuoteViewID {
    public static let quoteView = "quote_view"
    public static let logoImage = "logo_image"
    public static let rideDetailsContainer = "ride_details_stack_view"
    public static let name = "name_label"
    public static let pickUpType = "pickUp_type_label"
    public static let eta = "eta_label"
    public static let carType = "car_type_label"
    public static let fare = "fare_label"
    public static let fareType = "fareType_label"
}

class QuoteView: UIView {
    private var didSetupConstraints: Bool = false
    private var logoLoadingImageView: LoadingImageView!
    
    private var rideDetailStackView: UIStackView!
    private var name: UILabel!
    private var carType: UILabel!
    private var pickUpType: RoundedLabel!
    private var pickUpTypeContainer: UIView!
    private var vehicleCapacityView: VehicleCapacityView!
    private var capacityContainer: UIView!
    
    private var priceDetailsStack: UIStackView!
    private var eta: UILabel!
    private var fare: UILabel!
    private var fareType: UILabel!
    
    private var bottomLine: LineView!
    
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
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        pickUpType.cornerRadious = true
    }
    
    private func setUpView() {
        backgroundColor = KarhooUI.colors.white
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHQuoteViewID.quoteView
        
        logoLoadingImageView = LoadingImageView()
        logoLoadingImageView.accessibilityIdentifier = KHQuoteViewID.logoImage
        logoLoadingImageView.layer.cornerRadius = 5.0
        logoLoadingImageView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        logoLoadingImageView.layer.borderWidth = 0.5
        logoLoadingImageView.layer.masksToBounds = true
        addSubview(logoLoadingImageView)
        
        rideDetailStackView = UIStackView()
        rideDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        rideDetailStackView.accessibilityIdentifier = KHQuoteViewID.rideDetailsContainer
        rideDetailStackView.axis = .vertical
        rideDetailStackView.spacing = 8.0
        addSubview(rideDetailStackView)
        
        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.accessibilityIdentifier = KHQuoteViewID.name
        name.textColor = KarhooUI.colors.darkGrey
        name.font = KarhooUI.fonts.bodyBold()
        name.numberOfLines = 0
        rideDetailStackView.addArrangedSubview(name)
        
        carType = UILabel()
        carType.translatesAutoresizingMaskIntoConstraints = false
        carType.accessibilityIdentifier = KHQuoteViewID.carType
        carType.font = KarhooUI.fonts.captionRegular()
        carType.textColor = KarhooUI.colors.darkGrey
        rideDetailStackView.addArrangedSubview(carType)
        
        capacityContainer = UIView()
        capacityContainer.translatesAutoresizingMaskIntoConstraints = false
        capacityContainer.accessibilityIdentifier = "capacity_container_view"
        rideDetailStackView.addArrangedSubview(capacityContainer)
        
        vehicleCapacityView = VehicleCapacityView()
        capacityContainer.addSubview(vehicleCapacityView)
        
        pickUpTypeContainer = UIView()
        pickUpTypeContainer.translatesAutoresizingMaskIntoConstraints = false
        pickUpTypeContainer.accessibilityIdentifier = "pickUpType_container_view"
        rideDetailStackView.addArrangedSubview(pickUpTypeContainer)
        
        pickUpType = RoundedLabel()
        pickUpType.textInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        pickUpType.translatesAutoresizingMaskIntoConstraints = false
        pickUpType.accessibilityIdentifier = KHQuoteViewID.pickUpType
        pickUpType.maskToBounds = true
        pickUpType.textColor = KarhooUI.colors.white
        pickUpType.font = KarhooUI.fonts.captionRegular()
        pickUpType.backgroundColor = KarhooUI.colors.darkGrey
        pickUpType.isHidden = true
        pickUpTypeContainer.addSubview(pickUpType)
        
        priceDetailsStack = UIStackView()
        priceDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        priceDetailsStack.accessibilityIdentifier = "price_details_stack_view"
        priceDetailsStack.axis = .vertical
        priceDetailsStack.spacing = 8.0
        addSubview(priceDetailsStack)
        
        eta = UILabel()
        eta.translatesAutoresizingMaskIntoConstraints = false
        eta.accessibilityIdentifier = KHQuoteViewID.eta
        eta.textAlignment = .right
        eta.font = KarhooUI.fonts.bodyBold()
        eta.textColor = KarhooUI.colors.darkGrey
        priceDetailsStack.addArrangedSubview(eta)
        
        fare = UILabel()
        fare.translatesAutoresizingMaskIntoConstraints = false
        fare.accessibilityIdentifier = KHQuoteViewID.fare
        fare.textAlignment = .right
        fare.font = KarhooUI.fonts.bodyBold()
        fare.textColor = KarhooUI.colors.darkGrey
        priceDetailsStack.addArrangedSubview(fare)
        
        fareType = UILabel()
        fareType.translatesAutoresizingMaskIntoConstraints = false
        fareType.accessibilityIdentifier = KHQuoteViewID.fareType
        fareType.textAlignment = .right
        fareType.font = KarhooUI.fonts.captionRegular()
        fareType.textColor = KarhooUI.colors.darkGrey
        priceDetailsStack.addArrangedSubview(fareType)
        
        bottomLine = LineView(color: KarhooUI.colors.lightGrey, accessibilityIdentifier: "bottom_line")
        addSubview(bottomLine)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            _ = [logoLoadingImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
                 logoLoadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
                 logoLoadingImageView.heightAnchor.constraint(equalToConstant: 35.0),
                 logoLoadingImageView.widthAnchor.constraint(equalToConstant: 35.0)].map { $0.isActive = true }
            
            _ = [rideDetailStackView.topAnchor.constraint(equalTo: logoLoadingImageView.topAnchor),
                 rideDetailStackView.leadingAnchor.constraint(equalTo: logoLoadingImageView.trailingAnchor,
                                                              constant: 10.0),
                 rideDetailStackView.trailingAnchor.constraint(equalTo: priceDetailsStack.leadingAnchor,
                                                               constant: -10.0),
                 rideDetailStackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor,
                                                             constant: -20.0)].map { $0.isActive = true }
            
            _ = [priceDetailsStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                 priceDetailsStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                             constant: -10.0)].map { $0.isActive = true }
            
            _ = [bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
                 bottomLine.leadingAnchor.constraint(equalTo: logoLoadingImageView.trailingAnchor),
                 bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
                 bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func set(viewModel: QuoteViewModel) {
        
        name.text = viewModel.fleetName
        eta.text = viewModel.eta
        carType.text = viewModel.carType
        fare.text = viewModel.fare
        logoLoadingImageView.load(imageURL: viewModel.logoImageURL,
                                  placeholderImageName: "supplier_logo_placeholder")
        logoLoadingImageView.setStandardBorder()
        fareType.text = viewModel.fareType
        pickUpType.isHidden = !viewModel.showPickUpLabel
        pickUpType.text = viewModel.pickUpType
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
    }
    
    func resetView() {
        name.text = nil
        eta.text = nil
        carType.text = nil
        fare.text = nil
        fareType.text = nil
        pickUpType.text = nil
        logoLoadingImageView.cancel()
    }
}
