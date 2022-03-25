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

    private(set) var options: [T] = []
    private var selectedOption: T?

    // MARK: - Views

    private lazy var stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 24
    }

    private var selectionRows: [SelectionRowView<T>] = {
        options.map { option in
            SelectionRowView(
                value: option,
                isUnselectedStateAllowed: false,
                onSelected: { [weak self] in
                    self?.optionSelected($0)
                }
            )
        }
    }()

    // MARK: - Initialization

    init(options: [T], selectedOption: T? = nil) {
        super.init(frame: .zero)
        self.options = options
        self.selectedOption = selectedOption
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

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

    private func optionSelected(_ selectedOption: T) {
        print("Selected: \(selectedOption.localizedString)")
        selectionRows
            .filter { $0.value.localizedString != selectedOption.localizedString }
            .forEach {
                $0.setSelected(false)
            }
        self.selectedOption = selectedOption
    }
}

private class SelectionRowView<T: UserSelectable>: UIView {
    let value: T
    let onSelected: (T) -> Void

    /// Set `true` if it is allowed to have non of the options selected.
    let isUnselectedStateAllowed: Bool

    private lazy var selectControl = SingleSelectionControl(unselectAllowed: false).then {
        $0.addTarget(self, action: #selector(selectPressed), for: .touchUpInside)
    }
    private lazy var stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    private lazy var valueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = value.localizedString
        $0.font = KarhooUI.fonts.captionRegular()
        $0.textColor = KarhooUI.colors.text
    }

    init(
        value: T,
        isUnselectedStateAllowed: Bool = false,
        onSelected: @escaping (T) -> Void = { _ in }
    ) {
        self.value = value
        self.isUnselectedStateAllowed = isUnselectedStateAllowed
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
    }

    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews([selectControl, valueLabel])
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 24).then {
            $0.priority = .defaultLow
        }.isActive = true
    }

    func setSelected(_ isSelected: Bool) {
        
    }

    // MARK: - UI Actions
    
    @objc
    private func selectPressed() {
        onSelected(value)
    }
}

private class SingleSelectionControl: UIControl {

    // MARK: - Properties

    private let selectedImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = .uisdkImage("radioSelected")
    }
    private let defaultImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = .uisdkImage("radioUnselected")
    }

    override var allControlEvents: UIControl.Event { .touchUpInside }

    override var isSelected: Bool {
        get {
            selectionStatus
        }
        set {
            setSelected(newValue)
        }
    }

    /// Set false if view should not allow touch interactions to change it's state to unselected
    let unselectAllowed: Bool

    /// Local value to store current state, since `isSelected` is used by UIKit and need to be computed property.
    private var selectionStatus: Bool = false

    // MARK: - Initialization

    init(unselectAllowed: Bool = true) {
        self.unselectAllowed = unselectAllowed
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.unselectAllowed = true
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        isSelected = false
    }
    
    private func setupHierarchy() {
        addSubview(defaultImageView)
        addSubview(selectedImageView)
    }
    
    private func setupLayout() {
        widthAnchor.constraint(equalToConstant: 24).then {
            $0.priority = .defaultLow
        }.isActive = true
        heightAnchor.constraint(equalToConstant: 24).then {
            $0.priority = .defaultLow
        }.isActive = true
        defaultImageView.anchorToSuperview(padding: 2)
        selectedImageView.anchorToSuperview(padding: 2)
    }

    // MARK: - UI Actions

    @objc
    private func buttonTapped(_ sender: UITapGestureRecognizer) {
        switch (isSelected, unselectAllowed) {
        case (true, true):
            // Setting default/unselected state by UI interaction should be allowed only if `unselectAllowed` is true
            isSelected = false
        case (false, _):
            isSelected = true
        default:
            break
        }
    }

    // MARK: - Helpers

    private func setSelected(_ isSelected: Bool) {
        selectionStatus = isSelected
        super.isSelected = isSelected
        isSelected ? setSelectedState() : setDefaultState()
    }

    private func setSelectedState() {
        // Step 1: hide default image
        animate(animation: { [weak self] in
            self?.defaultImageView.alpha = 0
            self?.defaultImageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
        // Step 2: animate in selected image
        animate(
            withDelay: 0.1,
            animation: {
                self.selectedImageView.alpha = 1
                self.selectedImageView.transform = .identity
            },
            completion: {
//                self.defaultImageView.isHidden = true
            }
        )
    }

    private func setDefaultState() {
        // Step 1: hide selected image
        animate(animation: {
            self.selectedImageView.alpha = 0
            self.selectedImageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
        // Step 2: animate in default image
        animate(
            withDelay: 0.1,
            animation: {
                self.defaultImageView.alpha = 1
                self.defaultImageView.transform = .identity
            },
            completion: {
//                self.selectedImageView.isHidden = true
            }
        )
    }

    private func animate(withDelay delay: CGFloat = 0, animation: @escaping () -> Void, completion: @escaping () -> Void = {}) {
        UIView.animate(
            withDuration: 0.1,
            delay: delay,
            usingSpringWithDamping: UIConstants.Animation.springWithDamping,
            initialSpringVelocity: UIConstants.Animation.initialSpringVelocity,
            options: .curveEaseIn,
            animations: animation,
            completion: { _ in completion() }
        )
    }
}
