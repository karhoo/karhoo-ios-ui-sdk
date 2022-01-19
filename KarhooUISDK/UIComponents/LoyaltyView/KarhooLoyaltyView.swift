//
//  KarhooLoyaltyView.swift.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

struct KHLoyaltyViewID {
    public static let backgroundView = "background_view"
    public static let containerStackView = "container_stack_view"
    public static let loyaltyStackView = "loyalty_stack_view"
    public static let contentStackView = "content_stack_view"
    public static let titleLabel = "title_label"
    public static let subtitleLabel = "subtitle_label"
    public static let burnPointsContainerView = "burn_points_container_view"
    public static let burnPointsSwitch = "burn_points_switch"
    public static let infoView = "info_view"
    public static let infoLabel = "info_label"
    public static let balanceView = "balance_view"
    public static let balanceLabel = "balance_label"
}

final class KarhooLoyaltyView: UIView {
    
    private weak var presenter: LoyaltyPresenter?
    private var didSetupConstraints: Bool = false
    private var topSwitchConstraint: NSLayoutConstraint?
    private var bottomSwitchConstraint: NSLayoutConstraint?
    
    // MARK: - UI
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.containerStackView
        stackView.spacing = UIConstants.Spacing.medium
        stackView.distribution = .fill
        return stackView
    }()
    
    // Note: The burnPointsSwitch is hidden in case can_burn == false. This stack view makes sure to strech the labels until the right edge of the view in this scenario
    private lazy var loyaltyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.loyaltyStackView
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.Spacing.medium
        stackView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        stackView.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        stackView.layer.cornerRadius = UIConstants.CornerRadius.small
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: UIConstants.Spacing.standard,
                                                                     leading: UIConstants.Spacing.medium,
                                                                     bottom: UIConstants.Spacing.medium,
                                                                     trailing: UIConstants.Spacing.medium)
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.contentStackView
        stackView.axis = .vertical
        stackView.spacing = UIConstants.Spacing.xSmall
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.titleLabel
        label.font = KarhooUI.fonts.bodyBold()
        label.textColor = KarhooUI.colors.text
        label.text = UITexts.Loyalty.title
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.subtitleLabel
        label.font = KarhooUI.fonts.captionRegular()
        label.textColor = KarhooUI.colors.textLabel
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
        view.layer.cornerRadius = UIConstants.CornerRadius.medium
        view.layer.masksToBounds = true
        view.backgroundColor = KarhooUI.colors.primary
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.infoLabel
        label.text = UITexts.Loyalty.info
        label.textColor = UIColor.white
        label.font = KarhooUI.fonts.captionRegular()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var balanceView: KarhooLoyaltyBalanceView = {
        let view = KarhooLoyaltyBalanceView()
        view.set(balance: presenter?.balance ?? 0)
        view.set(mode: .success)
        return view
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHLoyaltyViewID.backgroundView
        
        addSubview(containerStackView)
        addSubview(balanceView)
        containerStackView.addArrangedSubview(loyaltyStackView)
        containerStackView.addArrangedSubview(infoView)
        
        loyaltyStackView.addArrangedSubview(contentStackView)
        loyaltyStackView.addArrangedSubview(burnPointsContainerView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        burnPointsContainerView.addSubview(burnPointsSwitch)
        
        infoView.addSubview(infoLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
        
        presenter = KarhooLoyaltyPresenter(view: self)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            containerStackView.anchor(top: topAnchor,
                                      leading: leadingAnchor,
                                      bottom: bottomAnchor,
                                      trailing: trailingAnchor,
                                      paddingTop: UIConstants.Dimension.View.largeTagHeight / 2)
            
            burnPointsSwitch.centerY(inView: burnPointsContainerView)
            burnPointsSwitch.anchor(leading: burnPointsContainerView.leadingAnchor,
                                    trailing: burnPointsContainerView.trailingAnchor)
            topSwitchConstraint = burnPointsSwitch.topAnchor.constraint(greaterThanOrEqualTo: burnPointsContainerView.topAnchor, constant: 0)
            bottomSwitchConstraint = burnPointsSwitch.bottomAnchor.constraint(greaterThanOrEqualTo: burnPointsContainerView.bottomAnchor, constant: 0)
            updateBurnPointsSwitchConstraints()
            
            infoLabel.anchor(top: infoView.topAnchor,
                             leading: infoView.leadingAnchor,
                             bottom: infoView.bottomAnchor,
                             trailing: infoView.trailingAnchor,
                             paddingTop: UIConstants.Spacing.medium,
                             paddingLeft: UIConstants.Spacing.medium,
                             paddingBottom: UIConstants.Spacing.medium,
                             paddingRight: UIConstants.Spacing.medium)
            
            balanceView.anchor(top: topAnchor, trailing: trailingAnchor)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func updateBurnPointsSwitchConstraints() {
        topSwitchConstraint?.isActive = subtitleLabel.isHidden
        bottomSwitchConstraint?.isActive = subtitleLabel.isHidden
        setNeedsLayout()
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
        return presenter?.getCurrentMode() ?? .none
    }
    
    func set(mode: LoyaltyMode, withSubtitle text: String) {
        subtitleLabel.text = text
        subtitleLabel.textColor = KarhooUI.colors.textLabel
        loyaltyStackView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        
        switch mode {
        case .none, .earn:
            showInfoView(false)
            
        case .burn:
            showInfoView(true)
        }
        
        refreshBalanceView(with: .success)
    }
    
    private func showInfoView(_ show: Bool) {
        if (infoView.isHidden && !show) || (!infoView.isHidden && show)  {
            return
        }
        
        if show {
            infoView.isHidden = false
            UIView.animate(withDuration: UIConstants.Duration.long) { [weak self] in
                self?.infoView.alpha = 1.0
            }
        } else {
            infoView.isHidden = false
            UIView.animate(withDuration: UIConstants.Duration.long) { [weak self] in
                self?.infoView.alpha = 0.0
                self?.infoView.isHidden = true
            }
        }
    }
    
    func showError(withMessage message: String) {
        subtitleLabel.text = message
        subtitleLabel.textColor = KarhooUI.colors.error
        loyaltyStackView.layer.borderColor = KarhooUI.colors.error.cgColor
        showInfoView(false)
        refreshBalanceView(with: .error)
    }
    
    func set(dataModel: LoyaltyViewDataModel) {
        presenter?.set(dataModel: dataModel)
        presenter?.updateLoyaltyMode(with: .earn)
    }
    
    func set(delegate: LoyaltyViewDelegate) {
        presenter?.delegate = delegate
    }
    
    func updateLoyaltyFeatures(showEarnRelatedUI: Bool, showBurnRelatedUI: Bool) {
        subtitleLabel.isHidden = !showEarnRelatedUI
        burnPointsContainerView.isHidden = !showBurnRelatedUI
        updateBurnPointsSwitchConstraints()
        
        self.isHidden = !showEarnRelatedUI && !showBurnRelatedUI
    }
    
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        presenter?.getLoyaltyPreAuthNonce(completion: completion)
    }
  
    func hasError() -> Bool {
        return presenter?.hasError() ?? false
    }
    
    private func refreshBalanceView(with mode: LoyaltyBalanceMode) {
        balanceView.set(balance: presenter?.balance ?? 0)
        balanceView.set(mode: mode)
    }
}
