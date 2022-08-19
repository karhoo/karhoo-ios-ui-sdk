//
// Created by Bartlomiej Sopala on 22/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

public struct KHIconPlusTextHorizontalViewID {
    public static let stack = "icon_plus_label_stack"
    public static let image = "icon_plus_label_image"
    public static let label = "icon_plus_label_label"

}
class IconPlusTextHorizontalView: UIView {
    private let icon: UIImage
    private let text: String
    private let background: UIColor
    private let cornerRadius: CGFloat
    private let iconRectSide: CGFloat

    // MARK: view elements
    private var stack: UIStackView!
    private var imageView: UIImageView!
    private var label: UILabel!

    init(
        icon: UIImage,
        text: String,
        accessibilityIdentifier: String,
        background: UIColor = KarhooUI.colors.background1,
        cornerRadius: CGFloat = 0,
        iconSize: CGFloat = UIConstants.Dimension.Icon.small
    ) {
        self.icon = icon
        self.text = text
        self.background = background
        self.cornerRadius = cornerRadius
        self.iconRectSide = iconSize
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        backgroundColor =  background
        accessibilityIdentifier = accessibilityIdentifier
        clipsToBounds = true
        layer.cornerRadius = cornerRadius

        stack = UIStackView().then {stack in
            stack.accessibilityIdentifier = KHIconPlusTextHorizontalViewID.stack
            stack.spacing = UIConstants.Spacing.xxSmall
        }

        imageView = UIImageView().then { image in
            image.image = icon
            image.translatesAutoresizingMaskIntoConstraints = false
            image.accessibilityIdentifier = KHIconPlusTextHorizontalViewID.image
            image.contentMode = .scaleAspectFill
        }

        label = UILabel().then { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.accessibilityIdentifier = KHIconPlusTextHorizontalViewID.label
            label.textColor = KarhooUI.colors.primary
            label.font = KarhooUI.fonts.footnoteRegular()
            label.text = text
        }
    }

    private func setupHierarchy() {
        addSubview(stack)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
    }

    private func setupLayout() {
        stack.anchorToSuperview()
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.xxSmall,
            leading: UIConstants.Spacing.xSmall,
            bottom: UIConstants.Spacing.xxSmall,
            trailing: UIConstants.Spacing.xSmall
        )
        imageView.anchor(
            width: iconRectSide,
            height: iconRectSide
        )
    }
}
