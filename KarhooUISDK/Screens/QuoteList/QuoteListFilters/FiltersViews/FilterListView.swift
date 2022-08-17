//
//  FilterListView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 29/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class FilterListView: UIView, FilterView {

    // MARK: - Propterties

    var onFilterChanged: (([QuoteListFilter], QuoteListFilters.Category) -> Void)?
    var category: QuoteListFilters.Category
    var filter: [QuoteListFilter]
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
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }

    private var filterItems: [FilterListItem] = []

    // MARK: - Lifecycle

    init(
        category: QuoteListFilters.Category,
        selectableFilters: [QuoteListFilter],
        selectedFilters: [QuoteListFilter]
    ) {
        self.category = category
        self.selectableFilters = selectableFilters
        self.filter = selectedFilters
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
        setupItems()
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
        itemsMainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        filterItems = []

        selectableFilters.forEach { selectableFilter in
            let itemView = buildFilterListItem(for: selectableFilter)
            itemsMainStackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Private

    private func didSelect(_ filter: QuoteListFilter) {
        self.filter.append(filter)
    }
    
    private func didDeselect(_ filter: QuoteListFilter) {
        self.filter.removeAll {
            $0.localizedString == filter.localizedString &&
            $0.filterCategory == filter.filterCategory
        }
    }

    private func buildFilterListItem(for filter: QuoteListFilter) -> FilterListItem {
        let itemView = FilterListItem(filter: filter)
        itemView.isSelected = self.filter.contains { $0.localizedString == filter.localizedString }
        filterItems.append(itemView)
        itemView.addTarget(self, action: #selector(itemViewValueChanged), for: .valueChanged)
        return itemView
    }

    // MARK: - API

    func reset() {
        filter = []
        setupItems()
    }
    
    func configure(using filter: [QuoteListFilter]) {
        self.filter = filter
        setupItems()
    }

    @objc
    private func itemViewValueChanged(_ sender: FilterListItem) {
        switch sender.isSelected {
        case true:
            filter.append(sender.filter)
        case false:
            filter.removeAll {
                $0.localizedString == sender.filter.localizedString &&
                $0.filterCategory == sender.filter.filterCategory
            }
        }
        onFilterChanged?(filter, category)
    }

}
