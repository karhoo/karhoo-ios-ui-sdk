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

    var onFilterChanged: (([QuoteListFilter], QuoteListFilters.Category) -> Void)?
    private var numericFilter: QuoteListNumericFilter
    var category: QuoteListFilters.Category { numericFilter.filterCategory }
    var filter: [QuoteListFilter] { [numericFilter]  }

    // MARK: Views

    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    private lazy var iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = numericFilter.icon
        $0.contentMode = .scaleAspectFit
    }
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = numericFilter.filterCategory.localized
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.bodySemibold()
    }
    private lazy var decreaseCountButton = CounterButton(variation: .decrease).then {
        $0.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
    }
    private lazy var increaseCountButton = CounterButton(variation: .increase).then {
        $0.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
    }
    private lazy var currentFilterValueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = numericFilter.value.description
        $0.font = KarhooUI.fonts.headerSemibold()
        $0.textColor = KarhooUI.colors.text
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
        updateCounterState()
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
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
        setDimensions(height: UIConstants.Dimension.Button.large, priority: .defaultLow)
        stackView.anchorToSuperview(
            paddingLeading: UIConstants.Spacing.standard,
            paddingTrailing: UIConstants.Spacing.standard
        )
        iconImageView.setDimensions(width: UIConstants.Dimension.Icon.standard)
        currentFilterValueLabel.setDimensions(width: UIConstants.Dimension.Icon.xLarge)
    }

    // MARK: - Private methods

    private func updateCounterState() {
        increaseCountButton.isEnabled = numericFilter.value < numericFilter.maxValue
        decreaseCountButton.isEnabled = numericFilter.value > numericFilter.minValue
        currentFilterValueLabel.text = numericFilter.value.description
    }

    // MARK: - API

    func reset() {
        numericFilter.value = numericFilter.defaultValue
        updateCounterState()
    }

    func configure(using filter: [QuoteListFilter]) {
        guard let filter = filter.first as? QuoteListNumericFilter else {
            return
        }
        numericFilter = filter
        updateCounterState()
    }

    // MARK: - UI Actions

    @objc
    private func decreaseTapped(_ sender: UIButton) {
        numericFilter.value = max(numericFilter.minValue, numericFilter.value - 1)
        updateCounterState()
        onFilterChanged?(filter, numericFilter.filterCategory)
    }

    @objc
    private func increaseTapped(_ sender: UIButton) {
        numericFilter.value = min(numericFilter.maxValue, numericFilter.value + 1)
        updateCounterState()
        onFilterChanged?(filter, numericFilter.filterCategory)
    }
}
