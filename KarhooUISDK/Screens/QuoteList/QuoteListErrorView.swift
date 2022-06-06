//
// Created by Aleksander Wedrychowski on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//
import Foundation
import KarhooSDK
import UIKit

@objc protocol QuoteListErrorViewDelegate: AnyObject {
    func showNoCoverageEmail()
}

final class QuoteListErrorView: UIView, UITextViewDelegate {

    private lazy var titleLabel = UILabel().then {
        $0.font = KarhooUI.fonts.subtitleSemibold()
        $0.textColor = KarhooUI.colors.text
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = viewModel.title
    }

    private lazy var descriptionTextView = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = false
        $0.font = KarhooUI.fonts.bodyRegular()
        $0.textColor = KarhooUI.colors.text
        $0.textAlignment = .center
        if let attributedMessage = viewModel.attributedMessage {
            $0.attributedText = viewModel.attributedMessage
            $0.isUserInteractionEnabled = true
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
    let viewModel: QuoteListTableErrorViewModel
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

    override func didMoveToWindow() {
        super.didMoveToWindow()
        animateIn()
    }

    // MARK: - Setup
    private func setupView() {
        addSubview(contentStackView)
        contentStackView.anchorToSuperview(padding: UIConstants.Spacing.standard)
        contentStackView.addArrangedSubviews([
            SeparatorView(),
            imageView,
            SeparatorView(fixedHeight: UIConstants.Spacing.standard),
            titleLabel,
            SeparatorView(fixedHeight: UIConstants.Spacing.standard),
            descriptionTextView,
            SeparatorView()
        ])
        imageView.anchor(width: UIConstants.Dimension.Icon.xxxLarge, height: UIConstants.Dimension.Icon.xxxLarge)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionTextView.delegate = self
    }

    // MARK: - Helpers
    private func animateIn() {
        [
            imageView,
            titleLabel,
            descriptionTextView
        ].forEach(animateSubviewIn)
    }

    private func animateSubviewIn(_ viewToAnimate: UIView) {
        viewToAnimate.alpha = UIConstants.Alpha.hidden
        viewToAnimate.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: UIConstants.Duration.medium,
            delay: .random(in: (0...UIConstants.Duration.xSmallDelay)),
            usingSpringWithDamping: UIConstants.Animation.springWithDamping,
            initialSpringVelocity: UIConstants.Animation.initialSpringVelocity,
            options: .curveEaseIn,
            animations: {
                viewToAnimate.alpha = UIConstants.Alpha.enabled
                viewToAnimate.transform = .identity
            },
            completion: nil
        )
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "OpenContactUsMail" {
            delegate?.showNoCoverageEmail()
        }
        return false
    }
}
