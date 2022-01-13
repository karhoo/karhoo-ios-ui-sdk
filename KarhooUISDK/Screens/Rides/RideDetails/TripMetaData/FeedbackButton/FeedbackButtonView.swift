//
//  FeedbackButtonView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHFeedbackButtonID {
    public static let submitButton = "submit_button"
}

final class FeedbackButtonView: UIView, BaseView {

    weak var actions: FeedbackButtonActions?
    private var feedbackButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        feedbackButton.layer.cornerRadius = min(feedbackButton.bounds.width, feedbackButton.bounds.height) / 2
    }
    
    private func setUpView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = UIIdentifier.extraTripFeedbackView

        feedbackButton = UIButton(type: .custom)
        feedbackButton.accessibilityIdentifier = KHFeedbackButtonID.submitButton
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.setTitle(UITexts.TripRating.extraFeedbackButton, for: .normal)
        feedbackButton.titleLabel?.font = KarhooUI.fonts.bodyRegular()
        feedbackButton.setTitleColor(.white, for: .normal)
        feedbackButton.backgroundColor = KarhooUI.colors.primary
        feedbackButton.addTarget(self, action: #selector(feedbackSelected), for: .touchUpInside)

        addSubview(feedbackButton)

        _ = [feedbackButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
             feedbackButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0),
             feedbackButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             feedbackButton.widthAnchor.constraint(equalToConstant: feedbackButton.intrinsicContentSize.width + 30.0),
             feedbackButton.heightAnchor.constraint(equalToConstant: 40.0)].map { $0.isActive = true }

        configure()
    }

    @objc private func feedbackSelected(sender: UIButton) {
        actions?.didSelectFeedbackButton()
    }
}
