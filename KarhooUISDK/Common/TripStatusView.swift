//
//  TripStatusView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHTripStatusViewID {
    public static let tripStatusImage = "trip_status_image"
    public static let tripStatusTitle = "trip_status_title"
    public static let tripStatusPrice = "trip_status_price"
}

class TripStatusView: UIView {
    
    var tripStatusImage: UIImageView!
    var tripStatusTitle: UILabel!
    var tripStatusContainer: UIStackView!
    var tripStatusPrice: UILabel!
    
    public init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    // MARK: View setup
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "trip_status_view"
        
        tripStatusPrice = UILabel()
        tripStatusPrice.accessibilityIdentifier = KHTripStatusViewID.tripStatusPrice
        tripStatusPrice.translatesAutoresizingMaskIntoConstraints = false
        tripStatusPrice.font = KarhooUI.fonts.bodyBold()
        tripStatusPrice.text = "£0.00"
        addSubview(tripStatusPrice)
        
        _ = [tripStatusPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0),
             tripStatusPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0),
             tripStatusPrice.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                     constant: -15.0)].map { $0.isActive = true }
    
        tripStatusContainer = UIStackView()
        tripStatusContainer.accessibilityIdentifier = "trip_status_stack"
        tripStatusContainer.axis = .horizontal
        tripStatusContainer.spacing = 5.0
        tripStatusContainer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tripStatusContainer)
        _ = [tripStatusContainer.centerYAnchor.constraint(equalTo: tripStatusPrice.centerYAnchor),
             tripStatusContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                          constant: 15.0)].map { $0.isActive = true }
        
        tripStatusImage = UIImageView()
        tripStatusImage.accessibilityIdentifier = KHTripStatusViewID.tripStatusImage
        tripStatusImage.translatesAutoresizingMaskIntoConstraints = false
        let iconSize: CGFloat = 15.0
        _ = [tripStatusImage.widthAnchor.constraint(equalToConstant: iconSize),
             tripStatusImage.heightAnchor.constraint(equalToConstant: iconSize)].map { $0.isActive = true }
        
        tripStatusContainer.addArrangedSubview(tripStatusImage)
        
        tripStatusTitle = UILabel()
        tripStatusTitle.accessibilityIdentifier = KHTripStatusViewID.tripStatusTitle
        tripStatusTitle.translatesAutoresizingMaskIntoConstraints = false
        tripStatusTitle.font = KarhooUI.fonts.bodyRegular()
        tripStatusContainer.addArrangedSubview(tripStatusTitle)
    }
    
    public func setPrice(_ price: String) {
        tripStatusPrice.text = price
    }
    
    public func setStatusTitle(_ title: String) {
        tripStatusTitle.text = title
    }
    
    public func setStatusTitleColor(_ color: UIColor) {
        tripStatusTitle.textColor = color
    }
    
    public func setStatusIcon(_ icon: UIImage?) {
        tripStatusImage.image = icon
    }
    
    public func setStatusIconTintColor(_ color: UIColor) {
        tripStatusImage.tintColor = color
    }
}
