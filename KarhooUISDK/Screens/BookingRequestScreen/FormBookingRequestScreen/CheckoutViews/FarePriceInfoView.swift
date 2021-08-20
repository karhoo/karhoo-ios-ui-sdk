//
//  FarePriceInfoView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 20.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

enum FareTypeInfo: String {
    
}

final class FarePriceInfoView: UIView {
    private lazy var fareTypeInfoLabel: UILabel = {
        let scheduleCaption = UILabel()
        scheduleCaption.translatesAutoresizingMaskIntoConstraints = false
        scheduleCaption.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaTitle
        scheduleCaption.textColor = KarhooUI.colors.infoColor
        scheduleCaption.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        scheduleCaption.text = "This fleet charges a flat fare. The final fare may be affected by extras (tolls, delay, etc), please refer to the fleet's Terms and Conditions."
        
        return scheduleCaption
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
    
    convenience init(fareTypeInfo: String) {
        self.init()
        fareTypeInfoLabel.text = fareTypeInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
    }
}
    
