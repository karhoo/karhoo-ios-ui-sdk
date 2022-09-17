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
        $0.image = .uisdkImage("kh_radio_selected")
    }
    private let defaultImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = .uisdkImage("kh_radio_unselected")
    }

    override var allControlEvents: UIControl.Event { .touchUpInside }

    override var isSelected: Bool {
        get {
            isOn
        }
        set {
            setSelected(newValue)
        }
    }

    /// Local value to store current state, since `isSelected` is used by UIKit and need to be computed property.
    private var isOn: Bool = false

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
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

    // MARK: - Helpers

    private func setSelected(_ isSelected: Bool) {
        isOn = isSelected
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
        selectedImageView.alpha = UIConstants.Alpha.hidden
        selectedImageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        defaultImageView.alpha = UIConstants.Alpha.enabled
        defaultImageView.transform = .identity
    }

    private func animate(
        duration: TimeInterval = UIConstants.Duration.xShort,
        withDelay delay: Double = 0,
        animation: @escaping () -> Void
    ) {
        let userInteractionSettingSnapshot = isUserInteractionEnabled
        isUserInteractionEnabled = false
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: UIConstants.Animation.springWithDamping,
            initialSpringVelocity: UIConstants.Animation.initialSpringVelocity,
            options: .curveEaseIn,
            animations: animation,
            completion: { [weak self] _ in
                self?.isUserInteractionEnabled = userInteractionSettingSnapshot
            }
        )
    }
}
