//
//  NoCoverageView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/03/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import UIKit

final class NoCoverageView: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.uisdkImage("kh_uisdk_info_icon").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = KarhooUI.colors.text
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = KarhooUI.fonts.captionBold()
        label.textColor = KarhooUI.colors.text
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = KarhooUI.colors.background4
        layer.cornerRadius = UIConstants.CornerRadius.small
        setupConstraints()
        textLabel.text = UITexts.Booking.noCoverageForAsapRide
    }

    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(textLabel)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.Spacing.medium),
            iconImageView.heightAnchor.constraint(equalToConstant: UIConstants.Dimension.Icon.medium),
            iconImageView.widthAnchor.constraint(equalToConstant: UIConstants.Dimension.Icon.medium),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: UIConstants.Spacing.small),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.Spacing.small),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.Spacing.small),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIConstants.Spacing.small)
        ])
    }
}
