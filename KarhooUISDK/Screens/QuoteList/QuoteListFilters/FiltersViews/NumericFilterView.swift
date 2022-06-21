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
    }
    private lazy var iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = filter.icon
        $0.contentMode = .scaleAspectFit
    }
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = filter.filterCategory.localized
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.bodySemibold()
    }
    private lazy var decreaseCountButton = UIButton().then {
        $0.layer.borderColor = KarhooUI.colors.accent.cgColor
        $0.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        $0.layer.cornerRadius = UIConstants.CornerRadius.medium
        $0.layer.masksToBounds = true
        $0.backgroundColor = KarhooUI.colors.lightAccent
        $0.setImage(.uisdkImage("quantity_minus"), for: .normal)
        $0.imageView?.tintColor = KarhooUI.colors.accent
        $0.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        $0.addTouchAnimation()
    }
    private lazy var increaseCountButton = UIButton().then {
        $0.layer.borderColor = KarhooUI.colors.accent.cgColor
        $0.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        $0.layer.cornerRadius = UIConstants.CornerRadius.medium
        $0.layer.masksToBounds = true
        $0.backgroundColor = KarhooUI.colors.lightAccent
        $0.setImage(.uisdkImage("quantity_plus"), for: .normal)
        $0.imageView?.tintColor = KarhooUI.colors.accent
        $0.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        $0.addTouchAnimation()
    }
    private lazy var currentFilterValueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = numericFilter.value.description
        $0.font = KarhooUI.fonts.headerSemibold()
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

    // MARK: - Private methods

    private func updateCounterButtonsState() {
        increaseCountButton.isEnabled = numericFilter.value <= numericFilter.maxValue
        decreaseCountButton.isEnabled = numericFilter.value >= numericFilter.minValue
    }

    // MARK: - API

    func reset() {
        
    }

    // MARK: - UI Actions

    @objc
    private func decreaseTapped(_ sender: UIButton) {
        numericFilter.value = max(numericFilter.minValue, numericFilter.value - 1)
        updateCounterButtonsState()
        
    }

    @objc
    private func increaseTapped(_ sender: UIButton) {
        numericFilter.value = min(numericFilter.maxValue, numericFilter.value + 1)
        updateCounterButtonsState()
        
    }
}
