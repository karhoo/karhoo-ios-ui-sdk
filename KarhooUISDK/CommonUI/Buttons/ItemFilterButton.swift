//
//  ItemFilterButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class ItemFilterButton: ItemButton {
    
    let filter: QuoteListFilter

    init(filter: QuoteListFilter) {
        self.filter = filter
        super.init(title: filter.localizedString, icon: filter.icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ItemButton: UIButton {

    let itemTitle: String
    let itemIcon: UIImage?

    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            updateSelectedDesign()
        }
    }

    // Value overriden due to `titleEdgeInsets` usage
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: super.intrinsicContentSize.width + 2 * UIConstants.Spacing.medium,
            height: super.intrinsicContentSize.height + 2 * UIConstants.Spacing.xSmall
        )
    }
    
    init(title: String, icon: UIImage? = nil) {
        self.itemTitle = title
        self.itemIcon = icon
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setTitle(itemTitle, for: .normal)
        setImage(itemIcon, for: .normal)
        setTitleColor(KarhooUI.colors.text, for: .normal)
        setTitleColor(KarhooUI.colors.accent, for: .selected)
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.large
        titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        adjustsImageWhenHighlighted = false
        titleLabel?.font = KarhooUI.fonts.bodySemibold()
        imageEdgeInsets.right = UIConstants.Spacing.small
        titleEdgeInsets = UIEdgeInsets(
            top: UIConstants.Spacing.xSmall,
            left: UIConstants.Spacing.small,
            bottom: UIConstants.Spacing.xSmall,
            right: UIConstants.Spacing.small
        )
        setNeedsLayout()
        updateSelectedDesign()
        addTouchAnimation()
    }
    
    private func updateSelectedDesign() {
        let borderColor = isSelected ? KarhooUI.colors.accent.cgColor : UIColor.clear.cgColor
        let color = isSelected ? KarhooUI.colors.lightAccent : KarhooUI.colors.background2
        let tint = isSelected ? KarhooUI.colors.accent : KarhooUI.colors.text
        UIView.animate(
            withDuration: UIConstants.Duration.xShort,
            animations: { [weak self] in
                self?.layer.borderColor = borderColor
                self?.backgroundColor = color
                self?.imageView?.tintColor = tint
            }
        )
    }
}
