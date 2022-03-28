//
//  RadioControl.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

/// Selection view designed accordingly to `radio` component design.
class RadioControl: UIControl {

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
    
    private let animateTransitionToDefaultState: Bool

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

    init(unselectAllowed: Bool = true, animateTransitionToDefaultState: Bool = true) {
        self.animateTransitionToDefaultState = animateTransitionToDefaultState
        self.unselectAllowed = unselectAllowed
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.unselectAllowed = true
        self.animateTransitionToDefaultState = true
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
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
                .then {
                    $0.delegate = self
                    $0.requiresExclusiveTouchType = false
                }
        )
        isSelected = false
    }
    
    private func setupHierarchy() {
        addSubview(defaultImageView)
        addSubview(selectedImageView)
    }
    
    private func setupLayout() {
        widthAnchor.constraint(equalToConstant: UIConstants.Dimension.Button.small).then {
            $0.priority = .defaultLow
        }.isActive = true
        heightAnchor.constraint(equalToConstant: UIConstants.Dimension.Button.small).then {
            $0.priority = .defaultLow
        }.isActive = true
        defaultImageView.anchorToSuperview(padding: UIConstants.Spacing.xSmall)
        selectedImageView.anchorToSuperview(padding: UIConstants.Spacing.xSmall)
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
            self?.defaultImageView.alpha = UIConstants.Alpha.hidden
            self?.defaultImageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        })
        // Step 2: animate in selected image
        animate(
            withDelay: UIConstants.Duration.xShort,
            animation: {
                self.selectedImageView.alpha = UIConstants.Alpha.enabled
                self.selectedImageView.transform = .identity
            }
        )
    }

    private func setDefaultState() {
        // Step 1: hide selected image
        animate(
            duration: animateTransitionToDefaultState ? UIConstants.Duration.xShort : 0,
            animation: {
                self.selectedImageView.alpha = UIConstants.Alpha.hidden
                self.selectedImageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            }
        )
        // Step 2: animate in default image
        animate(
            withDelay: animateTransitionToDefaultState ? UIConstants.Duration.xShort : 0,
            animation: {
                self.defaultImageView.alpha = UIConstants.Alpha.enabled
                self.defaultImageView.transform = .identity
            }
        )
    }

    private func animate(
        duration: TimeInterval = UIConstants.Duration.xShort,
        withDelay delay: CGFloat = 0,
        animation: @escaping () -> Void
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: UIConstants.Animation.springWithDamping,
            initialSpringVelocity: UIConstants.Animation.initialSpringVelocity,
            options: .curveEaseIn,
            animations: animation,
            completion: { _ in }
        )
    }
}

extension RadioControl: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
