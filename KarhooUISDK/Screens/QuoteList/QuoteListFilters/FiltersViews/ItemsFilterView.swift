//
//  ItemsFilterView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

/// View designed to show filters within one category
class ItemsFilterView: UIView, FilterView {
    
    private enum Constants {
        static let spacingBetweenItemViews: CGFloat = UIConstants.Spacing.small
    }
    // MARK: - Propterties

    let category: QuoteListFilters.Category
    var onFilterChanged: (([QuoteListFilter], QuoteListFilters.Category) -> Void)?
    var filter: [QuoteListFilter]
    /// set `true` if `All` item should be added as first button.
    let allOptionEnabled: Bool
    private var selectableFilters: [QuoteListFilter]

    // MARK: Views
    
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = category.localized
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.subtitleSemibold()
    }
    
    private lazy var itemsMainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = UIConstants.Spacing.small
        $0.alignment = .leading
    }

    private var itemButtons: [UIButton] = []

    // MARK: - Lifecycle
    
    init(
        category: QuoteListFilters.Category,
        allOptionEnabled: Bool = true,
        selectableFilters: [QuoteListFilter],
        selectedFilters: [QuoteListFilter]
    ) {
        self.category = category
        self.allOptionEnabled = allOptionEnabled
        self.selectableFilters = selectableFilters
        self.filter = selectedFilters
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupItems()
    }

    // MARK: - Setup
    
    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        backgroundColor = KarhooUI.colors.background1
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(itemsMainStackView)
    }
    
    private func setupLayout() {
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
        itemsMainStackView.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            bottom: bottomAnchor,
            paddingTop: UIConstants.Spacing.standard
        )
    }

    private func setupItems() {
        layoutIfNeeded()
        itemsMainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemButtons = []

        if allOptionEnabled {
            let horizontalStackView = buildHorizontalStackViewForItems()
            itemsMainStackView.addArrangedSubview(horizontalStackView)
            let allItem = ItemButton(title: UITexts.Generic.all)
            itemButtons.append(allItem)
            allItem.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
            horizontalStackView.addArrangedSubview(allItem)
        }
        selectableFilters.forEach { selectableFilter in
            var horizontalStackView: UIStackView
            let itemView = ItemFilterButton(filter: selectableFilter)
            itemButtons.append(itemView)
            itemView.addTarget(self, action: #selector(itemButtonTapped), for: .touchUpInside)
            if let stackView = itemsMainStackView.subviews.last as? UIStackView {
                horizontalStackView = stackView
                if isThereSpaceForNextItem(
                    in: horizontalStackView,
                    itemView: itemView
                ) == false {
                    horizontalStackView = buildHorizontalStackViewForItems()
                    itemsMainStackView.addArrangedSubview(horizontalStackView)
                }
            } else {
                horizontalStackView = buildHorizontalStackViewForItems()
                itemsMainStackView.addArrangedSubview(horizontalStackView)
            }
            horizontalStackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Private methods

    private func didSelect(_ filter: QuoteListFilter) {
        self.filter.append(filter)
    }
    
    private func didDeselect(_ filter: QuoteListFilter) {
        self.filter.removeAll {
            $0.localizedString == filter.localizedString &&
            $0.filterCategory == filter.filterCategory
        }
    }

    private func buildHorizontalStackViewForItems() -> UIStackView {
        UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = Constants.spacingBetweenItemViews
        }
    }

    private func isThereSpaceForNextItem(in stackView: UIStackView, itemView: ItemFilterButton) -> Bool {
        stackView.layoutIfNeeded()
        let widthOfStackViewWithNewItem = stackView.frame.size.width + itemView.intrinsicContentSize.width
        return self.frame.width >= widthOfStackViewWithNewItem
    }

    // MARK: - API
    
    func reset() {
        filter = []
        itemButtons.forEach { $0.isSelected = false }
    }
    
    // MARK: - UI Actions

    @objc private func allButtonTapped(_ sender: ItemButton) {
        sender.isSelected = !sender.isSelected
        
        switch sender.isSelected {
        case true:
            selectableFilters.forEach { didSelect($0) }
            itemButtons
                .filter { $0 is ItemFilterButton } // Only `all` item is ItemButton, rest of them are instances of ItemFilterButton type.
                .forEach { $0.isSelected = false }
        case false:
            selectableFilters.forEach { didDeselect($0) }
        }
        onFilterChanged?(filter, category)
    }

    @objc private func itemButtonTapped(_ sender: ItemFilterButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true: didSelect(sender.filter)
        case false: didDeselect(sender.filter)
        }
        onFilterChanged?(filter, category)
    }
}
