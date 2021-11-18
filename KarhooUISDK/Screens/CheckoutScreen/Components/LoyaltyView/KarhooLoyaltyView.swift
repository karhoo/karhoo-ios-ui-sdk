//
//  KarhooLoyaltyView.swift.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHLoyaltyViewID {
    public static let backgroundView = "background_view"
    public static let loyaltyStackView = "loyalty_stack_view"
    public static let contentStackView = "content_stack_view"
    public static let titleLabel = "title_label"
    public static let subtitleLabel = "subtitle_label"
    public static let burnPointsContainerView = "burn_points_container_view"
    public static let burnPointsSwitch = "burn_points_switch"
    public static let infoView = "info_view"
    public static let infoLabel = "info_label"
}

final class KarhooLoyaltyView: UIStackView {
    
    private let standardHorizontalSpacing = 12.0
    private let standardVerticalSpacing = 10.0
    private let smallSpacing = 4.0
    private let cornerRadius = 3.0
    private let borderWidth = 1.0
    
    private var presenter: LoyaltyPresenter?
    private var didSetupConstraints: Bool = false
    private var topSwitchConstraint: NSLayoutConstraint?
    private var bottomSwitchConstraint: NSLayoutConstraint?
    
    // MARK: - UI
    // Note: The burnPointsSwitch is hidden in case can_burn == false. This stack view makes sure to strech the labels until the right edge of the view in this scenario
    private lazy var loyaltyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.loyaltyStackView
        stackView.axis = .horizontal
        stackView.spacing = standardHorizontalSpacing
        stackView.layer.borderColor = KarhooUI.colors.guestCheckoutGrey.cgColor
        stackView.layer.borderWidth = borderWidth
        stackView.layer.cornerRadius = cornerRadius
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: standardVerticalSpacing,
                                                                     leading: standardHorizontalSpacing,
                                                                     bottom: standardVerticalSpacing,
                                                                     trailing: standardHorizontalSpacing)
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.contentStackView
        stackView.axis = .vertical
        stackView.spacing = smallSpacing
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.titleLabel
        label.font = KarhooUI.fonts.bodyBold()
        label.textColor = KarhooUI.colors.primaryTextColor
        label.text = UITexts.Loyalty.title
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.subtitleLabel
        label.font = KarhooUI.fonts.captionRegular()
        label.textColor = KarhooUI.colors.guestCheckoutLightGrey
        label.text = UITexts.Loyalty.pointsEarnedForTrip
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var burnPointsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHLoyaltyViewID.burnPointsContainerView
        return view
    }()
    
    private lazy var burnPointsSwitch: UISwitch = {
        let swt = UISwitch()
        swt.translatesAutoresizingMaskIntoConstraints = false
        swt.accessibilityIdentifier = KHLoyaltyViewID.burnPointsSwitch
        swt.onTintColor = KarhooUI.colors.accent
        swt.isOn = false
        swt.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
        return swt
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHLoyaltyViewID.infoView
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = KarhooUI.colors.secondary
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.infoLabel
        label.text = UITexts.Loyalty.info
        label.textColor = UIColor.white
        label.font = KarhooUI.fonts.captionItalic()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setupView()
        presenter = KarhooLoyaltyPresenter(view: self)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHLoyaltyViewID.backgroundView
        spacing = standardVerticalSpacing
        axis = .vertical
        distribution = .fill
        
        addArrangedSubview(loyaltyStackView)
        addArrangedSubview(infoView)
        
        loyaltyStackView.addArrangedSubview(contentStackView)
        loyaltyStackView.addArrangedSubview(burnPointsContainerView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        burnPointsContainerView.addSubview(burnPointsSwitch)
        
        infoView.addSubview(infoLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            burnPointsSwitch.centerY(inView: burnPointsContainerView)
            burnPointsSwitch.anchor(leading: burnPointsContainerView.leadingAnchor,
                                          trailing: burnPointsContainerView.trailingAnchor)
            topSwitchConstraint = burnPointsSwitch.topAnchor.constraint(greaterThanOrEqualTo: burnPointsContainerView.topAnchor, constant: 0)
            bottomSwitchConstraint = burnPointsSwitch.bottomAnchor.constraint(greaterThanOrEqualTo: burnPointsContainerView.bottomAnchor, constant: 0)
            toggleBurnPointsSwitchConstraints()
            
            infoLabel.anchor(top: infoView.topAnchor,
                             leading: infoView.leadingAnchor,
                             bottom: infoView.bottomAnchor,
                             trailing: infoView.trailingAnchor,
                             paddingTop: standardVerticalSpacing,
                             paddingLeft: standardHorizontalSpacing,
                             paddingBottom: standardVerticalSpacing,
                             paddingRight: standardHorizontalSpacing)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func toggleBurnPointsSwitchConstraints() {
        topSwitchConstraint?.isActive = subtitleLabel.isHidden
        bottomSwitchConstraint?.isActive = subtitleLabel.isHidden
    }
    
    // MARK: - Actions
    @objc private func onSwitchValueChanged() {
        toggleLoyaltyMode()
    }
    
    @objc private func onViewTapped() {
        burnPointsSwitch.isOn = !burnPointsSwitch.isOn
        toggleLoyaltyMode()
    }
    
    private func toggleLoyaltyMode() {
        let mode: LoyaltyMode = burnPointsSwitch.isOn ? .burn : .earn
        presenter?.updateLoyaltyMode(with: mode)
    }
}

// MARK: - LoyaltyView
extension KarhooLoyaltyView: LoyaltyView {
    
    func getCurrentMode() -> LoyaltyMode {
        return presenter?.getCurrentMode() ?? .earn
    }
    
    func set(mode: LoyaltyMode, withSubtitle text: String) {
        subtitleLabel.text = text
        subtitleLabel.textColor = KarhooUI.colors.lightGrey
        loyaltyStackView.layer.borderColor = KarhooUI.colors.guestCheckoutGrey.cgColor
        
        switch mode {
        case .none, .earn:
            infoView.isHidden = false
            UIView.animate(withDuration: 0.45) { [weak self] in
                self?.infoView.alpha = 0.0
                self?.infoView.isHidden = true
            }
            
        case .burn:
            infoView.isHidden = false
            UIView.animate(withDuration: 0.45) { [weak self] in
                self?.infoView.alpha = 1.0
            }
        }
    }
    
    func showError(withMessage message: String) {
        subtitleLabel.text = message
        subtitleLabel.textColor = UIColor.red
        loyaltyStackView.layer.borderColor = UIColor.red.cgColor
    }
    
    func set(viewModel: LoyaltyViewModel) {
        presenter?.set(viewModel: viewModel)
        presenter?.updateLoyaltyMode(with: .earn)
    }
    
    func set(delegate: LoyaltyViewDelegate) {
        presenter?.delegate = delegate
    }
}
