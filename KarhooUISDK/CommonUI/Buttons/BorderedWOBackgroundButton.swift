//
//  BorderedWOBackgroundButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 27/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class BorderedWOBackgroundButton: UIButton {
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupProperties()
        setupLayout()
    }
    
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = KarhooUI.colors.border.cgColor
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.large
        clipsToBounds = true
        if #available(iOS 15.0, *) {
            setupButtonConfiguration()
        } else {
            titleLabel?.font = KarhooUI.fonts.bodySemibold()
            setTitleColor(KarhooUI.colors.text, for: .normal)
            tintColor = KarhooUI.colors.text
        }
        addTouchAnimation()
    }
    
    private func setupLayout() {
        heightAnchor.constraint(
            equalToConstant: UIConstants.Dimension.Button.medium
        ).then {
            $0.priority = .defaultHigh
        }.isActive = true
    }
    
    @available(iOS 15.0, *)
    private func setupButtonConfiguration() {
        configuration = UIButton.Configuration.plain()
        configuration?.imagePadding = UIConstants.Spacing.xSmall
        configuration?.baseForegroundColor = KarhooUI.colors.text
        configuration?.baseBackgroundColor = .clear
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = KarhooUI.fonts.bodySemibold()
            outgoing.foregroundColor = KarhooUI.colors.text
            return outgoing
        }
    }
}
