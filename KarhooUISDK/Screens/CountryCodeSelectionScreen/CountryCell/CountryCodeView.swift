//
//  CountryCodeView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

public struct KHCountryCodeViewID {
    public static let contentView = "content_view"
    public static let flagImageView = "flag_image_view"
    public static let countryLabel = "country_label"
    public static let isSelectedImageView = "is_selected_image_view"
}

class CountryCodeView: UIView {
    private let standardIconSize: CGFloat = 22.0
    private let standardSpacing: CGFloat = 20.0
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(width: standardIconSize, height: standardIconSize)
        return imageView
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = KarhooUI.fonts.bodyRegular()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var isSelectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.uisdkImage("kh_uisdk_circle")
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: standardIconSize, height: standardIconSize)
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(viewModel: CountryCodeViewModel) {
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
    
    private func setUpView() {
        backgroundColor = KarhooUI.colors.white
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHCountryCodeViewID.contentView
        
        addSubview(flagImageView)
        flagImageView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
                             paddingTop: standardSpacing,
                             paddingLeft: standardSpacing)
        
        addSubview(isSelectedImageView)
        isSelectedImageView.anchor(trailing: trailingAnchor,
                                   paddingRight: standardSpacing)
        isSelectedImageView.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor).isActive = true
        
        addSubview(countryLabel)
        countryLabel.anchor(leading: flagImageView.trailingAnchor,
                            trailing: isSelectedImageView.leadingAnchor,
                            paddingLeft: standardSpacing,
                            paddingRight: standardSpacing)
        countryLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor).isActive = true
    }
    
    func set(viewModel: CountryCodeViewModel) {
        flagImageView.image = viewModel.flagImage
        countryLabel.text = viewModel.printedCountryInfo
        isSelectedImageView.image = viewModel.isSelectedImage
    }
    
    func resetView() {
        flagImageView.image = nil
        countryLabel.text = nil
        isSelectedImageView.image = nil
    }
}
