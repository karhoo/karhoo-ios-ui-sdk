//
//  AddressGoogleLogoView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHAddressGoogleLogoViewID {
    public static let footerImage = "footer_image"
}

class AddressGoogleLogoView: UIView {

    private var footerImage: UIImageView!
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        accessibilityIdentifier = "Address_table_footer"
        translatesAutoresizingMaskIntoConstraints = false
        
        footerImage = UIImageView(frame: .zero)
        footerImage.accessibilityIdentifier = KHAddressGoogleLogoViewID.footerImage
        footerImage.translatesAutoresizingMaskIntoConstraints = false
        footerImage.image = UIImage.uisdkImage("kh_uisdk_powered_by_google_on_white")
        footerImage.contentMode = .scaleAspectFit
        addSubview(footerImage)
        
        _ = [footerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             footerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0),
             footerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                 constant: -15.0)].map { $0.isActive = true }
    }
}
