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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.text = UITexts.Booking.noCoverageForAsapRide
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIConstants.Spacing.small
        return stackView
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
        clipsToBounds = true
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: UIConstants.Dimension.Icon.medium),
            iconImageView.widthAnchor.constraint(equalToConstant: UIConstants.Dimension.Icon.medium),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.Spacing.medium),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.Spacing.small),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.Spacing.small),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIConstants.Spacing.small)
        ])
    }
}
