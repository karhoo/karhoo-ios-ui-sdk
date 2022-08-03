//
//  FilterListItem.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 29/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class FilterListItem: UIControl {

    // MARK: - Properties

    var filter: QuoteListFilter

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            checkboxView.isSelected = newValue
            super.isSelected = newValue
        }
    }

    // MARK: Views

    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = filter.localizedString
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.bodyRegular()
    }

    private lazy var checkboxView = CheckboxView().then {
        $0.addTarget(self, action: #selector(checkboxTapped), for: .valueChanged)
    }

    // MARK: - Lifecycle

    init(filter: QuoteListFilter) {
        self.filter = filter
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
    }

    private func setupProperties() {
        backgroundColor = KarhooUI.colors.background1
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(checkboxView)
    }
    
    private func setupLayout() {
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: checkboxView.leadingAnchor,
            bottom: bottomAnchor
        )
        checkboxView.anchor(
            top: topAnchor,
            right: rightAnchor,
            bottom: bottomAnchor,
            paddingTop: -UIConstants.Spacing.xxSmall,
            paddingRight: UIConstants.Spacing.large,
            paddingBottom: -UIConstants.Spacing.xxSmall
        )
        setDimensions(height: UIConstants.Dimension.Button.medium)
    }

    // MARK: - UI Actions
    
    @objc
    private func checkboxTapped(_ sender: CheckboxView) {
        isSelected = sender.isSelected
        sendActions(for: .valueChanged)
    }
    
}
