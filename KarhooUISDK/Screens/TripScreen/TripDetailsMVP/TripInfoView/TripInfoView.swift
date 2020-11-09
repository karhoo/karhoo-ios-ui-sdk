//
//  TripInfoView.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHTripInfoViewID {
    public static let driverImage = "driver_image"
    public static let driverName = "driver_name_label"
    public static let vehicleDetails = "vehicle_details_label"
    public static let driverLicenseNumber = "driver_license_label"
    public static let vehicleLicense = "vehicle_license_view"
}

public protocol TripInfoViewDelegate: class {
    func rideOptionsTapped(_ value: Bool)
    func driverImageTapped(_ image: UIImage)
}

final class TripInfoView: UIView {
    
    private var container: UIView!
    private var driverImage: LoadingImageView!
    private var driverName: UILabel!
    private var vehicleDetails: UILabel!
    private var driverLicenseNumber: UILabel!
    private var vehicleLicense: BordedLabel!
    private var dropDownButton: DropDownButton!
    private var isActionViewVisible: Bool!
    
    public weak var delegate: TripInfoViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
           super.draw(rect)
            addOuterShadow(opacity: 0.5,
                           radious: 5,
                           rasterize: true,
                           color: .black)
       }
    
    private func setUpView() {
        accessibilityIdentifier = "journey_info_view"
        translatesAutoresizingMaskIntoConstraints = false
        
        container = UIView()
        container.accessibilityIdentifier = "view_container"
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        addSubview(container)
        
        driverImage = LoadingImageView()
        driverImage.isAccessibilityElement = true
        driverImage.accessibilityIdentifier = KHTripInfoViewID.driverImage
        driverImage.translatesAutoresizingMaskIntoConstraints = false
        let imageTapGesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(driverImageTapped))
        driverImage.addGestureRecognizer(imageTapGesture)
        driverImage.isUserInteractionEnabled = true
        container.addSubview(driverImage)
        
        vehicleLicense = BordedLabel(title: "")
        vehicleLicense.accessibilityIdentifier = KHTripInfoViewID.vehicleLicense
        container.addSubview(vehicleLicense)
        
        dropDownButton = DropDownButton()
        dropDownButton.delegate = self
        isActionViewVisible = dropDownButton.getButtonState()
        container.addSubview(dropDownButton)
        
        driverName = UILabel()
        driverName.accessibilityIdentifier = KHTripInfoViewID.driverName
        driverName.isAccessibilityElement = true
        driverName.translatesAutoresizingMaskIntoConstraints = false
        driverName.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        driverName.textColor = .black
        driverName.numberOfLines = 0
        driverName.text = "Driver name not available" // localise default text
        
        container.addSubview(driverName)

        vehicleDetails = UILabel()
        vehicleDetails.accessibilityIdentifier = KHTripInfoViewID.vehicleDetails
        vehicleDetails.isAccessibilityElement = true
        vehicleDetails.translatesAutoresizingMaskIntoConstraints = false
        vehicleDetails.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        vehicleDetails.numberOfLines = 0
        vehicleDetails.textColor = .black
        vehicleDetails.text = "Vehicle details not available" // localise default text
        container.addSubview(vehicleDetails)
        
        driverLicenseNumber = UILabel()
        driverLicenseNumber.accessibilityIdentifier = KHTripInfoViewID.driverLicenseNumber
        driverLicenseNumber.isAccessibilityElement = true
        driverLicenseNumber.translatesAutoresizingMaskIntoConstraints = false
        driverLicenseNumber.font = UIFont.systemFont(ofSize: 10.0)
        driverLicenseNumber.numberOfLines = 0
        driverLicenseNumber.textColor = .black
        driverLicenseNumber.text = "Driver license not available" // localise default text
        container.addSubview(driverLicenseNumber)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [container.topAnchor.constraint(equalTo: self.topAnchor),
             container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             container.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        let imageSize: CGFloat = 48.0
        _ = [driverImage.heightAnchor.constraint(equalToConstant: imageSize),
             driverImage.widthAnchor.constraint(equalToConstant: imageSize),
             driverImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.0),
             driverImage.leadingAnchor.constraint(equalTo: container.leadingAnchor,
                                                  constant: 10.0)].map { $0.isActive = true }
        
        _ = [vehicleLicense.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.0),
             vehicleLicense.trailingAnchor.constraint(equalTo: container.trailingAnchor,
                                                      constant: -10.0)].map { $0.isActive = true }
        
        _ = [dropDownButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5.0),
             dropDownButton.trailingAnchor.constraint(equalTo: vehicleLicense.trailingAnchor)]
            .map { $0.isActive = true }
        
        _ = [driverName.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.0),
             driverName.leadingAnchor.constraint(equalTo: driverImage.trailingAnchor,
                                                 constant: 10.0)].map { $0.isActive = true }
        
        _ = [vehicleDetails.topAnchor.constraint(equalTo: driverName.bottomAnchor, constant: 3.0),
             vehicleDetails.leadingAnchor.constraint(equalTo: driverImage.trailingAnchor, constant: 10.0),
             vehicleDetails.widthAnchor.constraint(equalToConstant: 200.0)].map { $0.isActive = true }
        
        _ = [driverLicenseNumber.topAnchor.constraint(equalTo: vehicleDetails.bottomAnchor, constant: 3.0),
             driverLicenseNumber.leadingAnchor.constraint(equalTo: driverImage.trailingAnchor, constant: 10.0),
             driverLicenseNumber.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10.0),
             driverLicenseNumber.widthAnchor.constraint(equalToConstant: 200.0)].map { $0.isActive = true }
    }
}

// MARK: Setters
extension TripInfoView {
    
    public func setDriverName(_ name: String) {
        driverName.text = name
    }
    
    public func setVehicleDetails(_ details: String) {
        vehicleDetails.text = details
    }
    
    public func setDriverLicenseNumber(_ license: String) {
        driverLicenseNumber.text = license
    }
    
    public func setLicensePlateNumber(_ licensePlate: String) {
        print("\(licensePlate)")
        vehicleLicense.setTitle(licensePlate)
    }
    
    public func setDriverImage(_ imageUrl: String,
                               placeholder: String) {
        driverImage.load(imageURL: imageUrl,
                         placeholderImageName: placeholder)
    }
    
    @objc
    private func driverImageTapped() {
        delegate?.driverImageTapped(driverImage.image ?? UIImage()  )
    }
}

// MARK: Getters
extension TripInfoView {
    
    public func getDriverImage() -> UIImage? {
        return driverImage.image
    }
    
    public func getDriverImageObject() -> LoadingImageView {
           return driverImage
       }
}

extension TripInfoView: DropDownButtonDelegate {
    func buttonTapped(_ value: Bool) {
        delegate?.rideOptionsTapped(value)
    }
}
