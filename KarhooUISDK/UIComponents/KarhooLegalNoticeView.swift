//
//  KarhooLegalNoticeView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation


public struct KHLegalNoticeViewID {
    public static let view = "legal_notice_view"
    public static let button = "legal_notice_button"
    public static let text = "legal_notice_text"
}

final class KarhooLegalNoticeView: UIView {
    
    let isAvailable: Bool = UITexts.Booking.learnMore.isNotEmpty
    
    private var didSetUpConstraints: Bool = false
    
        private lazy var legalNoticeButton: KarhooExpandViewButton = {
            let button = KarhooExpandViewButton(title: UITexts.Booking.learnMore, onExpand: showLegalNoticePressed, onCollapce: hideLegalNoticePressed)
            button.accessibilityIdentifier = KHLegalNoticeViewID.button
            button.anchor(height: 44.0)
            return button
        }()
    
    private var legalNoticeLabel: UILabel = {
        let legalNoticeLabel = UILabel()
        legalNoticeLabel.translatesAutoresizingMaskIntoConstraints = false
        legalNoticeLabel.accessibilityIdentifier = KHCheckoutHeaderViewID.cancellationInfo
        legalNoticeLabel.font = KarhooUI.fonts.captionRegular()
        legalNoticeLabel.textColor = KarhooUI.colors.text
        legalNoticeLabel.textAlignment = .justified
        legalNoticeLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        legalNoticeLabel.numberOfLines = 0
        return legalNoticeLabel
    }()
    
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setUpView() {
        accessibilityIdentifier = KHLegalNoticeViewID.view
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(legalNoticeButton)
        addSubview(legalNoticeLabel)
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            legalNoticeButton.anchor( top: topAnchor,
                                    trailing: trailingAnchor)
            
            legalNoticeLabel.anchor(top: legalNoticeButton.bottomAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor,
                                    paddingBottom: 16)
            
            didSetUpConstraints.toggle()
        }
        super.updateConstraints()
    }
    
    func showLegalNoticePressed(){
        UIView.animate(withDuration: 0.45) { [unowned self] in
            self.legalNoticeLabel.alpha = 1.0
            self.legalNoticeLabel.isHidden = false

        }
    }
    
    func hideLegalNoticePressed(){
        UIView.animate(withDuration: 0.45) {
            self.legalNoticeLabel.alpha = 0.0
            self.legalNoticeLabel.isHidden = true
        }
    }
}
