//
//  ConfirmButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class MainActionButton: UIButton {

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
        backgroundColor = KarhooUI.colors.secondary
        layer.cornerRadius = UIConstants.CornerRadius.xLarge

        titleLabel?.font = KarhooUI.fonts.subtitleBold()
        setTitleColor(KarhooUI.colors.white, for: .normal)
        
        addTouchAnimation()
//        addTarget(self, action: #selector(pressed), for: .touchDown)
//        addTarget(self, action: #selector(touchCancelled), for: .touchCancel)
//        addTarget(self, action: #selector(released), for: .touchUpOutside)
//        addTarget(self, action: #selector(released), for: .touchUpInside)
    }

    private func setupLayout() {
        heightAnchor.constraint(
            equalToConstant: UIConstants.Dimension.View.mainActionButtonHeight
        ).then {
            $0.priority = .defaultLow
        }.isActive = true
    }

//    @objc
//    private func pressed() {
//        UIView.animate(
//            withDuration: UIConstants.Duration.xShort,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: { [weak self] in
//                self?.transform = UIConstants.Dimension.View.mainActionButtonPressedAffineTransform
//            }
//        )
//    }

//    @objc
//    private func released() {
//        animateToDefaultState()
//    }
//
//    @objc private func touchCancelled() {
//        animateToDefaultState()
//    }

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

extension UIControl {
    func addTouchAnimation() {
        addTarget(self, action: #selector(pressed), for: .touchDown)
        addTarget(self, action: #selector(touchCancelled), for: .touchCancel)
        addTarget(self, action: #selector(released), for: .touchUpOutside)
        addTarget(self, action: #selector(released), for: .touchUpInside)
    }

    @objc
    private func released() {
        animateToDefaultState()
    }

    @objc
    private func touchCancelled() {
        animateToDefaultState()
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

    @objc
    private func pressed() {
        UIView.animate(
            withDuration: UIConstants.Duration.xShort,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.transform = UIConstants.Dimension.View.mainActionButtonPressedAffineTransform
            }
        )
    }
}
