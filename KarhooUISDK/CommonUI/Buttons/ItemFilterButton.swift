//
//  ItemFilterButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class ItemFilterButton: UIButton {
    
    let filter: QuoteListFilter
    
    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            updateSelectedDesign()
        }
    }

    /// Value needs to be overrides due to `titleEdgeInsets` usage
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: super.intrinsicContentSize.width + 2 * UIConstants.Spacing.medium,
            height: super.intrinsicContentSize.height + 2 * UIConstants.Spacing.small
        )
    }
    
    init(filter: QuoteListFilter) {
        self.filter = filter
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setImage(filter.icon, for: .normal)
        setTitle(filter.localizedString, for: .normal)
        setTitleColor(KarhooUI.colors.text, for: .normal)
        setTitleColor(KarhooUI.colors.accent, for: .selected)
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.large
        titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        adjustsImageWhenHighlighted = false
        titleLabel?.font = KarhooUI.fonts.bodySemibold()
        titleEdgeInsets = UIEdgeInsets(
            top: UIConstants.Spacing.small,
            left: UIConstants.Spacing.medium,
            bottom: UIConstants.Spacing.small,
            right: UIConstants.Spacing.medium
        )
        updateSelectedDesign()
        addTouchAnimation()
    }
    
    private func updateSelectedDesign() {
        let borderColor = isSelected ? KarhooUI.colors.accent.cgColor : UIColor.clear.cgColor
        let color = isSelected ? KarhooUI.colors.lightAccent : KarhooUI.colors.background2
        let tint = isSelected ? KarhooUI.colors.accent : KarhooUI.colors.text
        layer.borderColor = borderColor
        backgroundColor = color
        imageView?.tintColor = tint
    }
}
