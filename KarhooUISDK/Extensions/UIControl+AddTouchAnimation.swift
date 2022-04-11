//
//  UIControl+addTouchAnimation.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

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
