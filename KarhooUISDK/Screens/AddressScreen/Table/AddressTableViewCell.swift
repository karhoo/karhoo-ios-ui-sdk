//
//  AddressTableViewCell.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHAddressTableViewCellID {
    public static let icon = "icon_image"
    public static let stackView = "stack_view"
    public static let addressOne = "address_one"
    public static let addressTwo = "address_two"
}

class AddressTableViewCell: UITableViewCell {

    private var icon: UIImageView!
    private var stackView: UIStackView!
    private var addressLineOne: UILabel!
    private var addressLineTwo: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func setUpView() {
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        icon = UIImageView(image: UIImage.uisdkImage("kh_uisdk_search_result"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.accessibilityLabel = KHAddressTableViewCellID.icon
        icon.tintColor = KarhooUI.colors.infoColor
        contentView.addSubview(icon)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHAddressTableViewCellID.stackView
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        let iconSize: CGFloat = 19.0
        _ = [icon.widthAnchor.constraint(equalToConstant: iconSize),
             icon.heightAnchor.constraint(equalToConstant: iconSize),
             icon.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
             icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 10.0)].map {  $0.isActive = true }
        
        _ = [stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
             stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
             stackView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10.0),
             stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -5.0)].map {  $0.isActive = true }
        
        addressLineOne = UILabel()
        addressLineOne.translatesAutoresizingMaskIntoConstraints = false
        addressLineOne.accessibilityLabel = KHAddressTableViewCellID.addressOne
        addressLineOne.numberOfLines = 0
        addressLineOne.font = KarhooUI.fonts.bodyRegular()
        addressLineOne.textColor = KarhooUI.colors.darkGrey
        stackView.addArrangedSubview(addressLineOne)
        
        addressLineTwo = UILabel()
        addressLineTwo.translatesAutoresizingMaskIntoConstraints = false
        addressLineTwo.accessibilityLabel = KHAddressTableViewCellID.addressTwo
        addressLineTwo.numberOfLines = 0
        addressLineTwo.font = KarhooUI.fonts.captionRegular()
        addressLineTwo.textColor = KarhooUI.colors.medGrey
        stackView.addArrangedSubview(addressLineTwo)
    }

    override func prepareForReuse() {
        icon.image = nil
        addressLineOne.text = nil
        addressLineTwo?.text = nil
    }
    
    func set(address: AddressCellViewModel) {
        addressLineOne.text = address.displayAddress
        addressLineTwo.text = address.subtitleAddress
        icon.image = UIImage.uisdkImage(address.iconImageName)
    }
}
