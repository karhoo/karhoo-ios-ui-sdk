//
//  KarhooLoyaltyView.swift.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHLoyaltyViewID {
    public static let loyaltyStackView = "loyalty_stack_view"
    public static let contentView = "content_view"
    public static let titleLabel = "title_label"
    public static let subtitleLabel = "subtitle_label"
    public static let burnPointsSwitch = "burn_points_switch"
    public static let infoView = "info_view"
    public static let infoLabel = "info_label"
}

final class KarhooLoyaltyView: UIStackView {
    
    private let standardSpacing = 12.0
    private let borderWidth = 1.0
    private let cornerRadius = 3.0
    
    private var presenter: KarhooLoyaltyPresenter?
    
    // MARK: - UI
    private lazy var loyaltyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHLoyaltyViewID.loyaltyStackView
        stackView.axis = .horizontal
        stackView.spacing = standardSpacing
        stackView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        stackView.layer.borderWidth = borderWidth
        stackView.layer.cornerRadius = cornerRadius
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHLoyaltyViewID.contentView
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHLoyaltyViewID.titleLabel
        label.font = KarhooUI.fonts.captionRegular()
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
        return label
    }()
    
    private lazy var burnPointsSwitch: UISwitch = {
        let swt = UISwitch()
        swt.translatesAutoresizingMaskIntoConstraints = false
        swt.accessibilityIdentifier = KHLoyaltyViewID.burnPointsSwitch
        swt.tintColor = KarhooUI.colors.accent
        swt.isOn = false
        return swt
    }()
    
    // MARK: - Init
}
