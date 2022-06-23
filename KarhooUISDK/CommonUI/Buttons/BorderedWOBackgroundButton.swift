//
//  BorderedWOBackgroundButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 27/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class BorderedWOBackgroundButton: UIButton {

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            updateSelectedDesign()
        }
    }
    private var defaultTitle: String = ""

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
//        if #available(iOS 15.0, *) {
//            setupButtonConfiguration()
//        } else {
        imageEdgeInsets.right = UIConstants.Spacing.xSmall
        titleLabel?.font = KarhooUI.fonts.bodySemibold()
        setTitleColor(KarhooUI.colors.text, for: .normal)
        imageView?.tintColor = KarhooUI.colors.text
//        }
        setTitleColor(KarhooUI.colors.accent, for: .selected)
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

    // MARK: - Private methods

    private func updateSelectedDesign() {
        switch isSelected {
        case true:
            layer.borderColor = KarhooUI.colors.accent.cgColor
            imageView?.tintColor = KarhooUI.colors.accent
            setTitleColor(KarhooUI.colors.accent, for: .selected)
        case false:
            layer.borderColor = KarhooUI.colors.border.cgColor
            imageView?.tintColor = KarhooUI.colors.text
            setTitleColor(KarhooUI.colors.text, for: .normal)
        }
        
    }

    // MARK: - Endpoint methods

    func setSelected(withNumber numberToShow: Int) {
        let newTitle = (title(for: .normal) ?? "") + " " + numberToShow.description
        setTitle(newTitle, for: .selected)
        isSelected = true
    }
}
