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
    public static let separatorView = "separator_view"
    public static let loyaltyStackView = "loyalty_stack_view"
    public static let titleLabel = "title_label"
    public static let subtitleLabel = "subtitle_label"
    public static let earnLabel = "earn_label"
    public static let burnLabel = "burn_label"
    public static let errorLabel = "error_label"
    public static let burnPointsContainerView = "burn_points_container_view"
    public static let burnPointsLabelStackView = "burn_points_label_stack_view"
    public static let burnPointsSwitch = "burn_points_switch"
    public static let infoView = "info_view"
    public static let infoLabel = "info_label"
    public static let balanceView = "balance_view"
    public static let balanceLabel = "balance_label"
}

final class KarhooLoyaltyView: UIView {
    
    private enum LoyaltyConstants {
        static let topPaddingWithBalanceVisible : CGFloat = UIConstants.Dimension.View.largeTagHeight / 2
        static let topPaddingWithNoBalanceVisible: CGFloat = 0
    }
    
    private let presenter: LoyaltyPresenter
    private var didSetupConstraints: Bool = false
    private var topSwitchConstraint: NSLayoutConstraint?
    private var bottomSwitchConstraint: NSLayoutConstraint?
    private var topContainerConstraint: NSLayoutConstraint?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    var delegate: LoyaltyViewDelegate? {
        didSet {
            presenter.delegate = delegate
        }
    }
    
    var currentMode: LoyaltyMode {
        presenter.getCurrentMode()
    }
    
    // MARK: - UI
    private lazy var containerStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.containerStackView
        $0.spacing = UIConstants.Spacing.medium
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private lazy var loyaltyStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.loyaltyStackView
        $0.spacing = UIConstants.Spacing.xSmall
        $0.layer.borderColor = KarhooUI.colors.border.cgColor
        $0.layer.borderWidth = UIConstants.Dimension.Border.standardWidth
        $0.layer.cornerRadius = UIConstants.CornerRadius.medium
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.standard,
            leading: UIConstants.Spacing.medium,
            bottom: UIConstants.Spacing.medium,
            trailing: UIConstants.Spacing.medium
        )
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private lazy var separatorView = SeparatorWithLabelView().then {
        $0.accessibilityIdentifier = KHLoyaltyViewID.separatorView
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.titleLabel
        $0.font = KarhooUI.fonts.headerBold()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Loyalty.title
    }
    
    private lazy var earnLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.earnLabel
        $0.font = KarhooUI.fonts.captionRegular()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Loyalty.pointsEarnedForTrip
        $0.numberOfLines = 0
    }
    
    private lazy var burnTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.subtitleLabel
        $0.font = KarhooUI.fonts.bodyBold()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Loyalty.burnTitle
        $0.numberOfLines = 0
    }
    
    private lazy var burnLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.burnLabel
        $0.font = KarhooUI.fonts.captionRegular()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Loyalty.burnOffSubtitle
        $0.numberOfLines = 0
    }
    
    private lazy var errorLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.errorLabel
        $0.font = KarhooUI.fonts.captionBold()
        $0.textColor = KarhooUI.colors.error
        $0.text = UITexts.Generic.error
        $0.numberOfLines = 0
    }
    
    private lazy var burnPointsContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.burnPointsContainerView
    }
    
    private lazy var burnPointsLabelStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.burnPointsLabelStackView
        $0.axis = .vertical
        $0.spacing = UIConstants.Spacing.small
    }
    
    private lazy var burnPointsSwitch = UISwitch().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.burnPointsSwitch
        $0.onTintColor = KarhooUI.colors.accent
        $0.isOn = false
        $0.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
    }
    
    private lazy var infoView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.infoView
        $0.layer.cornerRadius = UIConstants.CornerRadius.medium
        $0.layer.masksToBounds = true
        $0.backgroundColor = KarhooUI.colors.primary
    }
    
    private lazy var infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHLoyaltyViewID.infoLabel
        $0.text = UITexts.Loyalty.info
        $0.textColor = UIColor.white
        $0.font = KarhooUI.fonts.captionRegular()
        $0.numberOfLines = 0
    }
    
    private lazy var balanceView = KarhooLoyaltyBalanceView().then {
        $0.set(balance: presenter.balance)
        $0.set(mode: .success)
    }
    
    // MARK: - Init
    init() {
        presenter = KarhooLoyaltyPresenter()
        super.init(frame: .zero)
        setupView()
        presenter.presenterDelegate = self
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
        
        loyaltyStackView.addArrangedSubview(titleLabel)
        loyaltyStackView.addArrangedSubview(earnLabel)
        loyaltyStackView.addArrangedSubview(separatorView)
        loyaltyStackView.addArrangedSubview(burnPointsContainerView)
        loyaltyStackView.addArrangedSubview(errorLabel)
        
        burnPointsContainerView.addSubview(burnPointsLabelStackView)
        burnPointsContainerView.addSubview(burnPointsSwitch)
        
        burnPointsLabelStackView.addArrangedSubview(burnTitleLabel)
        burnPointsLabelStackView.addArrangedSubview(burnLabel)
        
        infoView.addSubview(infoLabel)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        tapGestureRecognizer!.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer!)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            containerStackView.anchor(
                leading: leadingAnchor,
                bottom: bottomAnchor,
                trailing: trailingAnchor
            )
            
            topContainerConstraint = containerStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: LoyaltyConstants.topPaddingWithBalanceVisible
            )
            topContainerConstraint?.isActive = true
            
            burnPointsLabelStackView.anchor(
                top: burnPointsContainerView.topAnchor,
                leading: burnPointsContainerView.leadingAnchor,
                bottom: burnPointsContainerView.bottomAnchor
            )
            
            burnPointsSwitch.centerY(inView: burnPointsContainerView)
            
            burnPointsSwitch.anchor(
                leading: burnPointsLabelStackView.trailingAnchor,
                trailing: burnPointsContainerView.trailingAnchor,
                paddingLeft: UIConstants.Spacing.small
            )
            
            topSwitchConstraint = burnPointsSwitch.topAnchor.constraint(
                greaterThanOrEqualTo: burnPointsContainerView.topAnchor,
                constant: UIConstants.Spacing.xxSmall
            )
            
            bottomSwitchConstraint = burnPointsSwitch.bottomAnchor.constraint(
                greaterThanOrEqualTo: burnPointsContainerView.bottomAnchor,
                constant: UIConstants.Spacing.xxSmall
            )
            
            updateBurnPointsSwitchConstraints()
            
            infoLabel.anchor(
                top: infoView.topAnchor,
                leading: infoView.leadingAnchor,
                bottom: infoView.bottomAnchor,
                trailing: infoView.trailingAnchor,
                paddingTop: UIConstants.Spacing.medium,
                paddingLeft: UIConstants.Spacing.medium,
                paddingBottom: UIConstants.Spacing.medium,
                paddingRight: UIConstants.Spacing.medium
            )
            
            balanceView.anchor(top: topAnchor, trailing: trailingAnchor)
            
            separatorView.anchor(height: UIConstants.Dimension.View.smallRowHeight)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func updateBurnPointsSwitchConstraints() {
        topSwitchConstraint?.isActive = burnPointsLabelStackView.isHidden
        bottomSwitchConstraint?.isActive = burnPointsLabelStackView.isHidden
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
        presenter.updateLoyaltyMode(with: mode)
    }
}

// MARK: - LoyaltyView
extension KarhooLoyaltyView: LoyaltyView {
    
    func set(dataModel: LoyaltyViewDataModel) {
        presenter.set(dataModel: dataModel)
        presenter.updateLoyaltyMode(with: .earn)
    }
    
    func getLoyaltyPreAuthNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        presenter.getLoyaltyPreAuthNonce(completion: completion)
    }
    
    private func refreshBalanceView(with mode: LoyaltyBalanceMode) {
        balanceView.set(balance: presenter.balance)
        balanceView.set(mode: mode)
    }
}

extension KarhooLoyaltyView: LoyaltyPresenterDelegate {
    func updateWith(mode: LoyaltyMode, earnSubtitle: String?, burnSubtitle: String?, errorMessage: String?) {
        switch mode {
        case .none, .earn, .burn:
            handleUIInSuccessCases(for: mode, earnSubtitle: earnSubtitle ?? "", burnSubtitle: burnSubtitle ?? "")
        case .error(let type):
            handleUIInErrorCases(for: type, errorMessage: errorMessage ?? "")
        }
    }
    
    private func handleUIInSuccessCases(for mode: LoyaltyMode, earnSubtitle: String, burnSubtitle: String) {
        earnLabel.text = earnSubtitle
        updateBurnLabels(withMessage: burnSubtitle, for: nil)
        updateErrorLabel(withMessage: nil, for: nil)
        updateBorder(withError: nil)
        updateToggleLoyaltyModeActivity(withError: nil)
        updateBalanceView(withError: nil)
        showInfoView(mode == .burn)
    }
    
    private func handleUIInErrorCases(for errorType: LoyaltyErrorType, errorMessage: String) {
        updateBurnLabels(withMessage: nil, for: errorType)
        showInfoView(false)
        updateToggleLoyaltyModeActivity(withError: errorType)
        updateBorder(withError: errorType)
        updateErrorLabel(withMessage: errorMessage, for: errorType)
        updateBalanceView(withError: errorType)
        separatorView.isHidden = errorType != .insufficientBalance
        earnLabel.isHidden = errorType != .insufficientBalance
    }
    
    private func updateBurnLabels(withMessage message: String?, for errorType: LoyaltyErrorType?) {
        guard let type = errorType
        else {
            burnLabel.text = message
            burnLabel.isHidden = false
            burnTitleLabel.textColor = KarhooUI.colors.text
            return
        }
        
        burnLabel.isHidden = true
        burnTitleLabel.textColor = KarhooUI.colors.textLabel
        
        switch type {
        case .insufficientBalance:
            burnTitleLabel.isHidden = false
        default:
            burnTitleLabel.isHidden = true
        }
    }
    
    private func updateBorder(withError type: LoyaltyErrorType?) {
        guard let type = type
        else {
            loyaltyStackView.layer.borderColor = KarhooUI.colors.border.cgColor
            return
        }
        
        switch type {
        case .insufficientBalance:
            loyaltyStackView.layer.borderColor = KarhooUI.colors.border.cgColor
        default:
            loyaltyStackView.layer.borderColor = KarhooUI.colors.error.cgColor
        }
    }
    
    private func updateErrorLabel(withMessage message: String?, for type: LoyaltyErrorType?) {
        guard let type = type
        else {
            errorLabel.isHidden = true
            return
        }
        
        errorLabel.isHidden = false
        errorLabel.text = message
        switch type {
        case .insufficientBalance:
            errorLabel.textColor = KarhooUI.colors.textLabel
        default:
            errorLabel.textColor = KarhooUI.colors.error
        }
    }
    
    private func updateToggleLoyaltyModeActivity(withError type: LoyaltyErrorType?) {
        guard let type = type
        else {
            tapGestureRecognizer?.isEnabled = true
            burnPointsSwitch.isEnabled = true
            return
        }
        
        tapGestureRecognizer?.isEnabled = false
        burnPointsSwitch.isEnabled = false
        
        switch type {
        case .insufficientBalance:
            burnPointsSwitch.isHidden = false
            burnPointsSwitch.isOn = false
        default:
            burnPointsSwitch.isHidden = true
        }
    }
    
    private func updateBalanceView(withError type: LoyaltyErrorType?) {
        guard let type = type
        else {
            balanceView.isHidden = false
            refreshBalanceView(with: .success)
            topContainerConstraint?.constant = LoyaltyConstants.topPaddingWithBalanceVisible
            setNeedsLayout()
            return
        }
        
        switch type {
        case .insufficientBalance:
            balanceView.isHidden = false
            refreshBalanceView(with: .success)
            topContainerConstraint?.constant = LoyaltyConstants.topPaddingWithBalanceVisible
        default:
            balanceView.isHidden = true
            topContainerConstraint?.constant = LoyaltyConstants.topPaddingWithNoBalanceVisible
        }
        
        setNeedsLayout()
    }
    
    private func showInfoView(_ show: Bool) {
        if (infoView.isHidden && !show) || (!infoView.isHidden && show) {
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
    
    func togglefeatures(earnOn: Bool, burnOn: Bool) {
        earnLabel.isHidden = !earnOn
        burnPointsContainerView.isHidden = !burnOn
        separatorView.isHidden = !burnOn
        updateBurnPointsSwitchConstraints()

        self.isHidden = !earnOn && !burnOn
    }
}
