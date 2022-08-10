//
//  CounterButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class CounterButton: UIButton {
    
    // MARK: - Nested types

    enum Variation {
        case increase
        case decrease

        fileprivate var image: UIImage? {
            switch self {
            case .decrease: return .uisdkImage("quantity_minus")
            case .increase: return .uisdkImage("quantity_plus")
            }
        }
    }

    // MARK: - Properties

    override var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            setEnabled(newValue)
            super.isEnabled = newValue
        }
    }

    let variation: Variation

    // MARK: - Lifecycle

    init(variation: Variation) {
        self.variation = variation
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setup() {
        setupProperties()
        setupLayout()
    }

    private func setupProperties() {
        layer.borderColor = KarhooUI.colors.accent.cgColor
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.medium
        layer.masksToBounds = true
        backgroundColor = KarhooUI.colors.lightAccent
        setImage(variation.image, for: .normal)
        imageView?.tintColor = KarhooUI.colors.accent
        adjustsImageWhenHighlighted = false
        addTouchAnimation()
    }

    private func setupLayout() {
        setDimensions(
            height: UIConstants.Dimension.Button.medium,
            width: UIConstants.Dimension.Button.medium
        )
    }

    // MARK: - Private

    private func setEnabled(_ enabled: Bool) {
        let borderColor = enabled ? KarhooUI.colors.accent.cgColor : UIColor.clear.cgColor
        let backgroundColor = enabled ? KarhooUI.colors.lightAccent : KarhooUI.colors.inactive
        let imageColor = enabled ? KarhooUI.colors.accent : KarhooUI.colors.textLabel
        layer.borderColor = borderColor
        self.backgroundColor = backgroundColor
        imageView?.tintColor = imageColor
        isUserInteractionEnabled = enabled
    }
}
