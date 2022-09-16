//
//  CheckboxView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 04/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class CheckboxView: UIControl {

    // MARK: - Nested types

    // Some ui properties are not default, so need to describe it properly. This is because visible view is smaller than proper UX expects.
    enum CustomConstants {
        static let visibleIconSideLenght: CGFloat = 18
        static let sideLenght: CGFloat = UIConstants.Dimension.Button.small
        static let visibleAndActualWidthOffset: CGFloat = 6
    }

    private enum SelectionState {
        case selected
        case unselected

        var image: UIImage {
            switch self {
            case .selected: return .uisdkImage("kh_checkbox_selected")
            case .unselected: return .uisdkImage("kh_checkbox_unselected")
            }
        }
    }

    // MARK: - Properties

    override var isSelected: Bool {
        get {
            selectionState == .selected
        }
        set {
            updateState(isSelected: newValue)
        }
    }

    public var showsError: Bool = false {
        didSet {
            updateErrorState()
        }
    }

    private var selectionState: SelectionState = .unselected

    // MARK: Views

    private let imageViewContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = UIConstants.CornerRadius.xSmall
        $0.layer.masksToBounds = true
    }

    private let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true

        setupHierarchy()
        setupLayout()
        setupGesture()
        updateState(isSelected: false)
    }

    private func setupHierarchy() {
        addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
    }

    private func setupLayout() {
        widthAnchor.constraint(equalToConstant: CustomConstants.sideLenght).do {
            $0.priority = .defaultHigh
            $0.isActive = true
        }
        heightAnchor.constraint(equalToConstant: CustomConstants.sideLenght).do {
            $0.priority = .defaultHigh
            $0.isActive = true
        }
        imageViewContainer.centerX(inView: self)
        imageViewContainer.centerY(inView: self)
        imageView.anchorToSuperview(padding: UIConstants.Spacing.xxSmall)
    }

    // MARK: - Endpoints

    func updateErrorState() {
        let expectedBorderWidth = showsError ? UIConstants.Dimension.Border.xLargeWidth : 0
        let expectedColor = showsError ? KarhooUI.colors.error : .clear
        UIView.animate(
            withDuration: UIConstants.Duration.short,
            animations: { [weak self] in
                self?.imageViewContainer.layer.borderColor = expectedColor.cgColor
                self?.imageViewContainer.layer.borderWidth = expectedBorderWidth
            }
        )
    }

    // MARK: - Private methods

    private func updateState(isSelected: Bool) {
        showsError = false
        selectionState = isSelected ? .selected : .unselected
        accessibilityLabel = isSelected ? UITexts.Generic.checked : UITexts.Generic.unchecked
        isUserInteractionEnabled = false

        UIView.transition(
            with: imageView,
            duration: UIConstants.Duration.short,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.imageView.image = self?.selectionState.image
            },
            completion: { [weak self] _ in
                self?.isUserInteractionEnabled = true
            }
        )
    }

    private func setupGesture() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(checkboxTapped)
            )
        )
    }

    // MARK: - Actions

    @objc
    private func checkboxTapped(_ sender: UITapGestureRecognizer) {
        isSelected.toggle()
        sendActions(for: .valueChanged)
    }
}
