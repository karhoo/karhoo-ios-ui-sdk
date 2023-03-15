//
//  ConfirmButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class MainActionButton: UIButton {

    enum Design {
        case primary
        case secondary

        var borderColor: UIColor {
            switch self {
            case .primary: return .clear
            case .secondary: return KarhooUI.colors.secondary
            }
        }

        var fontColor: UIColor {
            switch self {
            case .primary: return KarhooUI.colors.white
            case .secondary: return KarhooUI.colors.secondary
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .primary: return KarhooUI.colors.secondary
            case .secondary: return KarhooUI.colors.white
            }
        }
    }

    private let design: Design

    // MARK: - Initialization

    init(design: Design = .primary) {
        self.design = design
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.design = .primary
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
        backgroundColor = design.backgroundColor
        layer.cornerRadius = UIConstants.CornerRadius.xLarge
        layer.borderWidth = 1
        layer.borderColor = design.borderColor.cgColor
        titleLabel?.font = KarhooUI.fonts.subtitleBold()
        setTitleColor(design.fontColor, for: .normal)

        addTouchAnimation()
    }

    private func setupLayout() {
        heightAnchor.constraint(
            equalToConstant: UIConstants.Dimension.Button.mainActionButtonHeight
        ).then {
            $0.priority = .defaultHigh
        }.isActive = true
    }

    private func animateToDefaultState() {
        UIView.animate(
            withDuration: UIConstants.Duration.xShort,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.transform = .identity
            }
        )
    }
}
