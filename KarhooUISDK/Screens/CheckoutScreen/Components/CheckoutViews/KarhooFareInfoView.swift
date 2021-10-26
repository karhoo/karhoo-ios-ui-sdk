//
//  KarhooFareInfoView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 20.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooFareInfoView: UIView {
    private lazy var fareTypeInfoLabel: UILabel = {
        let fareTypeInfo = UILabel()
        fareTypeInfo.translatesAutoresizingMaskIntoConstraints = false
        fareTypeInfo.accessibilityIdentifier = "fare_type_info_label"
        fareTypeInfo.textColor = KarhooUI.colors.white
        fareTypeInfo.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        fareTypeInfo.text = "This fleet is a non-regulated taxi."
        fareTypeInfo.numberOfLines = 0
        
        return fareTypeInfo
    }()

    private lazy var infoIcon: UIImageView = {
        let iconImage = UIImageView()
        iconImage.image = UIImage.uisdkImage("info_icon")
        iconImage.tintColor = KarhooUI.colors.white
        iconImage.contentMode = .scaleAspectFit
        iconImage.setDimensions(height: 12.0,
                                width: 12.0)
        
        return iconImage
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(infoIcon)
        addSubview(fareTypeInfoLabel)
    }
    
    private func setupConstraints() {
        infoIcon.centerY(inView: self)
        infoIcon.anchor(leading: leadingAnchor,
                        trailing: fareTypeInfoLabel.leadingAnchor,
                        paddingLeft: 10.0,
                        paddingRight: 10.0)
        fareTypeInfoLabel.centerY(inView: self)
        fareTypeInfoLabel.anchor(top: topAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 paddingTop: 5.0,
                                 paddingBottom: 5.0,
                                 paddingRight: 10.0)
    }
    
    private func retrieveTextBasedOn(fareType: QuoteType) -> String {
        switch fareType {
        case .estimated:
            return UITexts.Booking.estimatedInfoBox
        case .fixed:
            return UITexts.Booking.fixedInfoBox
        case .metered:
            return UITexts.Booking.meteredInfoBox
        @unknown default:
            fatalError()
        }
    }
    
    func setInfoText(for fareType: QuoteType) {
        fareTypeInfoLabel.text = retrieveTextBasedOn(fareType: fareType)
        setupConstraints()
    }

}
    
