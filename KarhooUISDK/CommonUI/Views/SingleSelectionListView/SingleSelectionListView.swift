//
//  SingleSelectionListView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 24/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class SingleSelectionListView<T: UserSelectable>: UIView {
    
    // MARK: - Properties

    private let options: [T]
    private(set) var selectedOption: T?

    // MARK: - Views

    private lazy var stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = UIConstants.Spacing.large
    }

    private lazy var selectionRows: [SelectionRowView<T>] = {
        options.map { option in
            buildOptionRow(for: option)
        }
    }()

    // MARK: - Initialization

    init(options: [T], selectedOption: T? = nil) {
        self.options = options
        super.init(frame: .zero)
        self.selectedOption = selectedOption
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.options = []
        super.init(coder: coder)
        self.setup()
    }

    // MARK: - Setup

    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews(selectionRows)
    }

    private func setupLayout() {
        stackView.anchorToSuperview(
            paddingTop: UIConstants.Spacing.small,
            paddingBottom: UIConstants.Spacing.small
        )
    }

    // MARK: - Helpers

    private func buildOptionRow(for option: T) -> SelectionRowView<T> {
        SelectionRowView(
            value: option,
            onSelected: { [weak self] in
                self?.optionSelected($0)
            }
        ).then {
            if option == selectedOption {
                $0.setSelected(true)
            }
        }
    }

    private func optionSelected(_ selectedOption: T) {
        selectionRows
            .filter { $0.value != selectedOption }
            .forEach {
                $0.setSelected(false)
            }
        self.selectedOption = selectedOption
    }
}

// MARK: - SelectionRowView
private class SelectionRowView<T: UserSelectable>: UIView {

    // MARK: - Properties

    let value: T
    let onSelected: (T) -> Void

    // MARK: - Views

    private lazy var selectControl = RadioControl().then {
        $0.addTarget(self, action: #selector(selectPressed), for: .touchUpInside)
    }
    private lazy var stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = UIConstants.Spacing.small
    }
    private lazy var valueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        $0.text = value.localizedString
        $0.font = KarhooUI.fonts.bodyRegular()
        $0.textColor = KarhooUI.colors.text
    }

    init(
        value: T,
        onSelected: @escaping (T) -> Void = { _ in }
    ) {
        self.value = value
        self.onSelected = onSelected
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectPressed))
        )
    }

    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews([selectControl, valueLabel])
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: UIConstants.Dimension.Button.small).then {
            $0.priority = .defaultLow
        }.isActive = true
        stackView.anchorToSuperview()
    }

    /// Use to set value of select control. This method will not trigger `onSelected` completion.
    func setSelected(_ isSelected: Bool) {
        selectControl.isSelected = isSelected
    }

    // MARK: - UI Actions
    
    @objc
    private func selectPressed() {
        onSelected(value)
        selectControl.isSelected = true
    }
}
