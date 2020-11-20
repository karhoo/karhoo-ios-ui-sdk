//
//  KarhooAddressDisplayView.swift
//  KarhooUISDK
//
//  Created by Nurseda Balcioglu on 08/06/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAddressDisplayView: UIView {

    private var addressTypeImage: UIImageView!
    private var addressDisplayLabel: UILabel!

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    private func setUpView() {
        backgroundColor = .white

        addressTypeImage = UIImageView()
        addressTypeImage.translatesAutoresizingMaskIntoConstraints = false
        addressTypeImage.accessibilityIdentifier = "address_display_dot"
        addressTypeImage.isAccessibilityElement = true
        addSubview(addressTypeImage)
        
        NSLayoutConstraint.activate([
            addressTypeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addressTypeImage.heightAnchor.constraint(equalToConstant: 15),
            addressTypeImage.widthAnchor.constraint(equalToConstant: 15),
            addressTypeImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addressDisplayLabel = UILabel()
        addressDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        addressDisplayLabel.accessibilityIdentifier = "addressDisplayLabel"
        addressDisplayLabel.numberOfLines = 2
        addressDisplayLabel.font = KarhooUI.fonts.bodyRegular()
        addressDisplayLabel.textColor = KarhooUI.colors.darkGrey
        addSubview(addressDisplayLabel)
        
        NSLayoutConstraint.activate([
            addressDisplayLabel.leadingAnchor.constraint(equalTo: addressTypeImage.trailingAnchor, constant: 8),
            addressDisplayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            addressDisplayLabel.centerYAnchor.constraint(equalTo: addressTypeImage.centerYAnchor),
            addressDisplayLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 15),
            addressDisplayLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15)
        ])
    }
    
    func set(addressType: AddressType) {
        switch addressType {
        case .pickup: addressTypeImage.image = UIImage.uisdkImage("pickup_icon")
        case .destination: addressTypeImage.image = UIImage.uisdkImage("drop_off_icon")
        }
    }
    
    func set(address: String) {
        addressDisplayLabel.text = address
    }
    
}
