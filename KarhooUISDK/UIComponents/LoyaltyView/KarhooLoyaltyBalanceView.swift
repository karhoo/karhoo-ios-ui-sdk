//
//  KarhooLoyaltyBalanceView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 17.01.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class KarhooLoyaltyBalanceView: UIView {
    private var balance: Int = 0
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.balanceLabel
        label.text = getTitle()
        label.textAlignment = .center
        label.font = KarhooUI.fonts.captionBold()
        label.accessibilityLabel = getTitle()
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHLoyaltyViewID.balanceView
        layer.cornerRadius = UIConstants.CornerRadius.medium
        anchor(height: UIConstants.Dimension.View.largeTagHeight)
        addSubview(titleLabel)
        
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor,
                          paddingTop: UIConstants.Spacing.xxSmall, paddingLeft: UIConstants.Spacing.medium, paddingBottom: UIConstants.Spacing.xxSmall, paddingRight: UIConstants.Spacing.medium)
        
        set(mode: .success)
    }
    
    // MARK: - Utils
    private func getTitle() -> String {
        let text = String(format: NSLocalizedString(UITexts.Loyalty.balanceTitle, comment: ""), "\(balance)")
        return text
    }
}

// MARK: - LoyaltyBalanceView
extension KarhooLoyaltyBalanceView: LoyaltyBalanceView {
    func set(balance: Int) {
        self.balance = balance
        titleLabel.text = getTitle()
    }
    
    func set(mode: LoyaltyBalanceMode) {
        backgroundColor = mode.backgroundColor
        titleLabel.textColor = mode.textColor
    }
}
