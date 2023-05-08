//
//  KarhooAddressDisplayView.swift
//  KarhooUISDK
//
//  Created by Nurseda Balcioglu on 08/06/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class KarhooAddressDisplayView: UIView {

    private var stackContainer: UIStackView!
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

        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stackView"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .horizontal
        stackContainer.distribution = .fillProportionally
        addSubview(stackContainer)

        stackContainer.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            paddingLeft: UIConstants.Spacing.small,
            paddingRight: UIConstants.Spacing.small
        )
        stackContainer.centerY(inView: self)

        addressTypeImage = UIImageView()
        addressTypeImage.translatesAutoresizingMaskIntoConstraints = false
        addressTypeImage.accessibilityIdentifier = "address_display_dot"
        addressTypeImage.isAccessibilityElement = true
        stackContainer.addSubview(addressTypeImage)

        addressDisplayLabel = UILabel()
        addressDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        addressDisplayLabel.accessibilityIdentifier = "addressDisplayLabel"
        addressDisplayLabel.numberOfLines = 3
        addressDisplayLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addressDisplayLabel.font = KarhooUI.fonts.bodyRegular()
        addressDisplayLabel.textColor = KarhooUI.colors.text
        stackContainer.addSubview(addressDisplayLabel)

        addressTypeImage.anchor(leading: stackContainer.leadingAnchor, paddingLeft: 8, width: 15, height: 15)
        addressTypeImage.centerY(inView: stackContainer)

        addressDisplayLabel.anchor(
            leading: addressTypeImage.trailingAnchor,
            trailing: stackContainer.trailingAnchor,
            paddingTop: UIConstants.Spacing.small,
            paddingLeft: 10,
            paddingRight: UIConstants.Spacing.xSmall,
            paddingBottom: UIConstants.Spacing.small
        )
        addressDisplayLabel.centerY(inView: stackContainer)
    }
    
    func set(addressType: AddressType) {
        switch addressType {
        case .pickup:
            addressTypeImage.image = UIImage.uisdkImage("kh_uisdk_pickup_icon").coloured(withTint: KarhooUI.colors.primary)
        case .destination:
            addressTypeImage.image = UIImage.uisdkImage("kh_uisdk_drop_off_icon").coloured(withTint: KarhooUI.colors.secondary)
        }
    }
    
    func set(address: String) {
        addressDisplayLabel.text = address
    }
    
}
