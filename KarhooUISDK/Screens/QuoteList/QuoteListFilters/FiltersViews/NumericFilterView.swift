//
//  NumericFilterView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class NumericFilterView: UIView, FilterView {
    
    // MARK: - Propterties

    private var numericFilter: QuoteListNumericFilter
    var filter: QuoteListFilter { numericFilter  }

    // MARK: Views

    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
//        $0.distribution = .
    }
    private lazy var iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = filter.icon
    }
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = filter.filterCategory.localized
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.bodySemibold()
    }
    private lazy var decreaseCountButton = UIButton().then {
        $0.layer.borderColor = KarhooUI.colors.accent.cgColor
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.medium
        layer.masksToBounds = true
        $0.backgroundColor = KarhooUI.colors.lightAccent
        $0.setTitleColor(KarhooUI.colors.accent, for: .normal)
        $0.setTitle("-", for: .normal)
        $0.addTouchAnimation()
    }
    private lazy var increaseCountButton = UIButton().then {
        $0.layer.borderColor = KarhooUI.colors.accent.cgColor
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.medium
        layer.masksToBounds = true
        $0.backgroundColor = KarhooUI.colors.lightAccent
        $0.setTitleColor(KarhooUI.colors.accent, for: .normal)
        $0.setTitle("+", for: .normal)
        $0.addTouchAnimation()
    }
    private lazy var currentFilterValueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = numericFilter.value.description
        $0.font = KarhooUI.fonts.titleBold()
        $0.textAlignment = .center
    }

    // MARK: - Lifecycle

    init(filter: QuoteListNumericFilter) {
        self.numericFilter = filter
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        backgroundColor = KarhooUI.colors.background1
        layer.borderColor = KarhooUI.colors.border.cgColor
        layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        layer.cornerRadius = UIConstants.CornerRadius.large
        layer.masksToBounds = true
    }

    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews([
            iconImageView,
            SeparatorView(fixedWidth: UIConstants.Spacing.small),
            titleLabel,
            SeparatorView(),
            decreaseCountButton,
            currentFilterValueLabel,
            increaseCountButton
        ])
    }
    
    private func setupLayout() {
        stackView.anchorToSuperview(
            paddingTop: UIConstants.Spacing.medium,
            paddingLeading: UIConstants.Spacing.standard,
            paddingTrailing: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.medium
        )
//        heightAnchor.constraint(equalToConstant: 52).do {
//            $0.priority = .defaultHigh
//            $0.isActive = true
//        }
        iconImageView.setDimensions(width: UIConstants.Dimension.Icon.standard)
        currentFilterValueLabel.setDimensions(width: UIConstants.Dimension.Icon.xLarge)
        decreaseCountButton.setDimensions(
            height: UIConstants.Dimension.Button.medium,
            width: UIConstants.Dimension.Button.medium
        )
        increaseCountButton.setDimensions(
            height: UIConstants.Dimension.Button.medium,
            width: UIConstants.Dimension.Button.medium
        )

    }

    // MARK: - API

    func reset() {
        
    }

}
