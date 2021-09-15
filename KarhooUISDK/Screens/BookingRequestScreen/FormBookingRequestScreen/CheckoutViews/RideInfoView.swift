//
//  RideInfoView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

protocol InfoButtonActions: AnyObject {
    func infoButtonPressed()
}

final class RideInfoView: UIView {
    private weak var actions: InfoButtonActions?
    private var didSetupConstraints: Bool = false
    
    private lazy var scheduleCaption: UILabel = {
        let scheduleCaption = UILabel()
        scheduleCaption.translatesAutoresizingMaskIntoConstraints = false
        scheduleCaption.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaTitle
        scheduleCaption.textColor = KarhooUI.colors.infoColor
        scheduleCaption.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        scheduleCaption.text = UITexts.Generic.etaLong
        
        return scheduleCaption
    }()
    
    private lazy var scheduleMainValue: UILabel = {
        let scheduleMainValue = UILabel()
        scheduleMainValue.translatesAutoresizingMaskIntoConstraints = false
        scheduleMainValue.accessibilityIdentifier = KHFormCheckoutHeaderViewID.etaText
        scheduleMainValue.textColor = KarhooUI.colors.infoColor
        scheduleMainValue.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        
        return scheduleMainValue
    }()
    
    private lazy var rideTypeLabel: UILabel = {
        let rideTypeLabel = UILabel()
        rideTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        rideTypeLabel.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideType
        rideTypeLabel.textColor = KarhooUI.colors.infoColor
        rideTypeLabel.text = UITexts.Generic.meetGreet
        rideTypeLabel.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        
        return rideTypeLabel
    }()
    
    private lazy var priceTitle: UILabel = {
        let priceTitle = UILabel()
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.accessibilityIdentifier = KHFormCheckoutHeaderViewID.estimatedPrice
        priceTitle.textColor = KarhooUI.colors.infoColor
        priceTitle.textAlignment = .right
        priceTitle.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        priceTitle.text = UITexts.Generic.estimatedPrice.uppercased()
        
        return priceTitle
    }()
    
    private lazy var priceText: UILabel = {
        let priceText = UILabel()
        priceText.translatesAutoresizingMaskIntoConstraints = false
        priceText.accessibilityIdentifier = KHFormCheckoutHeaderViewID.priceText
        priceText.textColor = KarhooUI.colors.infoColor
        priceText.textAlignment = .right
        priceText.font = KarhooUI.fonts.getBoldFont(withSize: 24.0)
        
        return priceText
    }()
    
    private lazy var ridePriceType: UIButton = {
        let ridePriceType = UIButton()
        ridePriceType.translatesAutoresizingMaskIntoConstraints = false
        ridePriceType.accessibilityIdentifier = KHFormCheckoutHeaderViewID.ridePriceType
        ridePriceType.setTitleColor(KarhooUI.colors.infoColor, for: .normal)
        ridePriceType.titleLabel?.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        ridePriceType.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        
        return ridePriceType
    }()
    
    private lazy var rideTypeInfoButton: UIButton = {
        let infoButton = UIButton(type: .custom)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.accessibilityIdentifier = KHFormCheckoutHeaderViewID.ridePriceTypeIcon
        infoButton.setImage(UIImage.uisdkImage("info_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        infoButton.contentVerticalAlignment = .fill
        infoButton.contentHorizontalAlignment = .fill
        infoButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        infoButton.tintColor = KarhooUI.colors.infoColor
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        
        return infoButton
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    convenience init(viewModel: QuoteViewModel) {
        self.init()
        self.setDetails(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHMoreDetailsViewID.container
        
        addSubview(scheduleCaption)
        addSubview(scheduleMainValue)
        addSubview(rideTypeLabel)
        addSubview(priceTitle)
        addSubview(priceText)
        addSubview(rideTypeInfoButton)
        addSubview(ridePriceType)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            [scheduleCaption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
             scheduleCaption.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
             scheduleCaption.trailingAnchor.constraint(lessThanOrEqualTo: priceTitle.leadingAnchor,
                                                constant: 20.0)].forEach { $0.isActive = true }
            
            rideTypeLabel.anchor(leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 paddingTop: 10.0,
                                 paddingLeft: 10.0,
                                 paddingBottom: 10.0)
            
            [scheduleMainValue.leadingAnchor.constraint(equalTo: scheduleCaption.leadingAnchor),
             scheduleMainValue.topAnchor.constraint(equalTo: scheduleCaption.bottomAnchor, constant: 5.0),
             scheduleMainValue.trailingAnchor.constraint(lessThanOrEqualTo: priceText.leadingAnchor, constant: 20.0)]
                .forEach { $0.isActive = true }
            
            priceTitle.anchor(top: scheduleCaption.topAnchor,
                              trailing: trailingAnchor,
                              paddingRight: 10.0)
            
            priceText.anchor(top: priceTitle.bottomAnchor,
                             bottom: ridePriceType.topAnchor,
                             trailing: priceTitle.trailingAnchor,
                             paddingTop: 5.0,
                             paddingBottom: 10.0)
            
            ridePriceType.anchor(bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 paddingBottom: 10.0,
                                 paddingRight: 10.0)
            rideTypeInfoButton.centerYAnchor.constraint(equalTo: ridePriceType.centerYAnchor).isActive = true
            rideTypeInfoButton.anchor(trailing: ridePriceType.leadingAnchor,
                                     paddingRight: 3.0,
                                     width: 24.0,
                                     height: 24.0)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    public func setDetails(viewModel: QuoteViewModel) {
        scheduleCaption.text = viewModel.scheduleCaption
        scheduleMainValue.text = viewModel.scheduleMainValue
        ridePriceType.setTitle(viewModel.fareType, for: .normal) 
        priceText.text = viewModel.fare
        rideTypeLabel.text = viewModel.pickUpType
    }
     
    public func setActions(_ actions: InfoButtonActions) {
        self.actions = actions
    }
    
    @objc private func infoButtonPressed() {
        actions?.infoButtonPressed()
    }
}
