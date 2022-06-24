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
    
    let title: String
    var onFilterChanged: (([QuoteListFilter]) -> Void)?
    var filter: [QuoteListFilter]
    private var selectableFilters: [QuoteListFilter]

    // MARK: Views
    
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = title
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.subtitleSemibold()
    }
    
    private lazy var itemsMainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = UIConstants.Spacing.small
        $0.alignment = .leading
    }

    private var itemsHorizontalStackViews: [UIStackView] = []
    
    // MARK: - Lifecycle
    
    init(
        title: String,
        selectableFilters: [QuoteListFilter],
        selectedFilters: [QuoteListFilter]
    ) {
        self.title = title
        self.selectableFilters = selectableFilters
        self.filter = selectedFilters
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupItems()
    }

    // MARK: - Setup
    
    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
        
//        itemsMainStackView.addArrangedSubviews(
//            selectableFilters.map {
//                let button = ItemFilterButton(filter: $0)
//                button.addTarget(
//                    self,
//                    action: #selector(itemButtonTapped),
//                    for: .touchUpInside
//                )
//                return button
//            }
//        )

        
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
        itemsHorizontalStackViews = []

        selectableFilters.forEach { selectableFilter in
            let itemView = ItemFilterButton(filter: selectableFilter)
            var horizontalStackView: UIStackView
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
        itemView.layoutIfNeeded()
        return self.frame.width >= stackView.frame.size.width + Constants.spacingBetweenItemViews + itemView.frame.width
    }

    // MARK: - API
    
    func reset() {
        filter = []
        // TODO: deselect all ItemFilterButtons
    }
    
    // MARK: - UI Actions
    
    @objc private func itemButtonTapped(_ sender: ItemFilterButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true: didSelect(sender.filter)
        case false: didDeselect(sender.filter)
        onFilterChanged?(filter)
        }
    }
}
