//
// Created by Aleksander Wedrychowski on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

protocol QuoteListErrorViewDelegate: AnyObject {
}

final class QuoteListErrorView: UIView {

    // MARK: - Nested types
    
    private enum Constants {
        static let imageViewSize = CGSize(width: 68, height: 70)
        static let titleFontSize = CGFloat(18)
        static let messageFontSize = CGFloat(18)
    }

    // MARK: - Views

    private lazy var titleLabel = UILabel().then {
        $0.font = KarhooUI.fonts.getSemiboldFont(withSize: Constants.titleFontSize)
        $0.textColor = KarhooUI.colors.text
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = viewModel.title
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.font = KarhooUI.fonts.getRegularFont(withSize: Constants.messageFontSize)
        $0.textColor = KarhooUI.colors.text
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if let attributedMessage = viewModel.attributedMessage {
            $0.attributedText = viewModel.attributedMessage
        } else {
            $0.text = viewModel.message
        }
    }

    private lazy var imageView = UIImageView().then {
        $0.image = .uisdkImage(viewModel.imageName)
        $0.contentMode = .scaleAspectFit
    }

    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }

    // MARK: - Properties

    private let viewModel: QuoteListTableErrorViewModel
    private weak var delegate: QuoteListErrorViewDelegate?

    // MARK: - Initialization

    init(using viewModel: QuoteListTableErrorViewModel, delegate: QuoteListErrorViewDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(contentStackView)
        contentStackView.anchorToSuperview(padding: UIConstants.Spacing.standard)
        contentStackView.addArrangedSubviews([
            buildSeparator(),
            imageView,
            buildSeparator(height: UIConstants.Spacing.standard),
            titleLabel,
            buildSeparator(height: UIConstants.Spacing.standard),
            descriptionLabel,
            buildSeparator()
        ])
        imageView.anchor(width: Constants.imageViewSize.width, height: Constants.imageViewSize.height)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func buildSeparator(height: CGFloat? = nil) -> UIView {
        UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.anchor(height: height)
        }
    }
}
