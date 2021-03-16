//
//  SupplierView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHSupplierViewID {
    public static let supplierImage = "supplier_image"
    public static let supplierName = "supplier_name_label"
    public static let vehicleType = "vehicle_type_label"
}

final class SupplierView: UIView {

    private var supplierImage: LoadingImageView!
    private var supplierName: UILabel!
    private var vehicleType: UILabel!
    private var cancellationInfo: UILabel!
    private var vehicleCapacityView: VehicleCapacityView!

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        accessibilityIdentifier = "supplier_view"
        isAccessibilityElement = true
        
        supplierImage = LoadingImageView()
        supplierImage.accessibilityIdentifier = KHSupplierViewID.supplierImage
        supplierImage.isAccessibilityElement = true
        supplierImage.layer.cornerRadius = 5.0
        supplierImage.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        supplierImage.layer.borderWidth = 0.5
        supplierImage.layer.masksToBounds = true
        addSubview(supplierImage)
        
        supplierName = UILabel()
        supplierName.translatesAutoresizingMaskIntoConstraints = false
        supplierName.accessibilityIdentifier = KHSupplierViewID.supplierName
        supplierName.textColor = KarhooUI.colors.darkGrey
        supplierName.font = KarhooUI.fonts.headerRegular()
        supplierName.numberOfLines = 2
        supplierName.lineBreakMode = .byWordWrapping
        addSubview(supplierName)
        
        vehicleType = UILabel()
        vehicleType.translatesAutoresizingMaskIntoConstraints = false
        vehicleType.accessibilityIdentifier = KHSupplierViewID.vehicleType
        vehicleType.textColor = KarhooUI.colors.darkGrey
        vehicleType.font = KarhooUI.fonts.bodyRegular()
        addSubview(vehicleType)

        vehicleCapacityView = VehicleCapacityView()
        addSubview(vehicleCapacityView)

        cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = KHQuoteViewID.cancellationInfo
        cancellationInfo.font = KarhooUI.fonts.captionRegular()
        cancellationInfo.textColor = KarhooUI.colors.brightGreen
        cancellationInfo.numberOfLines = 0
        addSubview(cancellationInfo)

        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [supplierImage.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
             supplierImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
             supplierImage.heightAnchor.constraint(equalToConstant: 32.0),
             supplierImage.widthAnchor.constraint(equalToConstant: 32.0)].map { $0.isActive = true }
        
        _ = [supplierName.leadingAnchor.constraint(equalTo: supplierImage.trailingAnchor, constant: 17.0),
             supplierName.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
             supplierName.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: 0)].map { $0.isActive = true }
        
        _ = [vehicleType.leadingAnchor.constraint(equalTo: supplierName.leadingAnchor),
             vehicleType.topAnchor.constraint(equalTo: supplierName.bottomAnchor, constant: 3.0)].map { $0.isActive = true }
        
        _ = [vehicleCapacityView.centerYAnchor.constraint(equalTo: vehicleType.centerYAnchor),
             vehicleCapacityView.leadingAnchor.constraint(equalTo: vehicleType.trailingAnchor,
                                                          constant: 13.0)].map { $0.isActive = true }

        cancellationInfo.topAnchor.constraint(equalTo: vehicleType.bottomAnchor, constant: 3.0).isActive = true
        cancellationInfo.leadingAnchor.constraint(equalTo: vehicleType.leadingAnchor).isActive = true
        cancellationInfo.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cancellationInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5.0).isActive = true
    }
    
    func set(viewModel: QuoteViewModel) {
        supplierName.text = viewModel.fleetName
        let vehicleTypeText = viewModel.showPickUpLabel ? viewModel.carType + " | " + viewModel.pickUpType :
                              viewModel.carType
        vehicleType.text = vehicleTypeText
        cancellationInfo.text = viewModel.freeCancellationMessage
        cancellationInfo.isHidden = viewModel.freeCancellationMessage == nil
        supplierImage.load(imageURL: viewModel.logoImageURL,
                            placeholderImageName: "supplier_logo_placeholder")
        vehicleCapacityView.setBaggageCapacity(viewModel.baggageCapacity)
        vehicleCapacityView.setPassengerCapacity(viewModel.passengerCapacity)
    }
}
