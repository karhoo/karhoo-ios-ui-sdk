//
//  KarhooRatingView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class KarhooRatingView: UIView, RatingView {
    
    private var ratingButtonsStackView: UIStackView!
    private var containerStackView: UIStackView!
    private var ratingMessageLabel: UILabel!
    private var separatorLine: UIView!
    private var titleView: UIView!
    private var commentField: HintTextView!
    
    private var rates: [RateButton] = []
    private var presenter: RatingPresenter = KarhooRatingPresenter()
    private var showSeparatorLine: Bool = false
    private var showCommentField: Bool = false
    private var isValidationEnabled: Bool = false
    
    weak var delegate: RatingViewDelegate?
    
    init(presenter: RatingPresenter = KarhooRatingPresenter(),
         showSeparatorLine: Bool = false,
         showCommentField: Bool = false,
         isValidationEnabled: Bool = false) {
        
        self.presenter = presenter
        self.showSeparatorLine = showSeparatorLine
        self.showCommentField = showCommentField
        self.isValidationEnabled = isValidationEnabled
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    private func buildRatingButtonStackView() {
        ratingButtonsStackView = UIStackView()
        ratingButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingButtonsStackView.spacing = 22.0
        ratingButtonsStackView.axis = .horizontal
    }
    
    private func buildContainerStackView() {
        containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.spacing = 5.0
        containerStackView.alignment = .center
        containerStackView.axis = .vertical
        addSubview(containerStackView)
    }
    
    private func addRatingButtons() {
        for index in 0..<presenter.ratingOptions {
            let viewModel = RateButtonViewModel()
            let rateButton = RateButton(viewModel: viewModel)
            rateButton.tag = index
            rateButton.delegate = self
            rates.append(rateButton)
            ratingButtonsStackView.addArrangedSubview(rateButton)
        }
    }
    
    private func buildCommentView() {
        // Comment textView
        commentField = HintTextView(placeholder: UITexts.TripRating.addCommentPlaceholder)
        commentField.accessibilityIdentifier = "rating_comment_field"
        commentField.isHidden = !showCommentField
    }
    
    private func buildSeparatorLineView() {
        // Separator line
        separatorLine = UIView(frame: .zero)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.accessibilityIdentifier = "separator_line"
        separatorLine.backgroundColor = .lightGray
        separatorLine.isHidden = !showSeparatorLine
        let separatorWidth: CGFloat = UIScreen.main.bounds.width - 30.0
        
        _ = [separatorLine.widthAnchor.constraint(equalToConstant: separatorWidth),
             separatorLine.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }
    }
    
    private func buildTitleView() {
        titleView = UIView(frame: .zero)
        
        ratingMessageLabel = UILabel()
        ratingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingMessageLabel.font = KarhooUI.fonts.captionRegular()
        ratingMessageLabel.text = presenter.ratingMessageTitle
        ratingMessageLabel.textAlignment = .center
        ratingMessageLabel.numberOfLines = 0
        titleView.addSubview(ratingMessageLabel)
        
        _ = [ratingMessageLabel.widthAnchor.constraint(equalToConstant: 250.0),
             ratingMessageLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
             ratingMessageLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10.0),
             ratingMessageLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10.0),
             ratingMessageLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor,
                                                          constant: -10.0)].map { $0.isActive = true }
    }
    
    private func setUpView() {
        presenter.set(view: self)

        accessibilityIdentifier = "rating_view"
        translatesAutoresizingMaskIntoConstraints = false
        
        buildRatingButtonStackView()

        buildContainerStackView()
        
        addRatingButtons()

        buildTitleView()
        
        buildCommentView()
        
        buildSeparatorLineView()
        
        containerStackView.addArrangedSubview(titleView)
        containerStackView.addArrangedSubview(ratingButtonsStackView)
        containerStackView.addArrangedSubview(commentField)
        containerStackView.addArrangedSubview(separatorLine)

        _ = [containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
             containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
             containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
             containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
    }

    func hideStars() {
        ratingButtonsStackView.isHidden = true
    }
    
    func showConfirmation(_ message: String) {
        ratingMessageLabel.text = message
    }
    
    func additionalComment() -> String {
        return commentField.getText()
    }
    
    public func getFeedBack() -> [String: Any] {
        return presenter.getFeedBackDetails()
    }
 
    @discardableResult
    public func isValid() -> Bool {
        if !isValidationEnabled {
            return false
        }
        
        if presenter.selectedRating == 0 {
            ratingButtonsStackView.shakeView()
        }
        
        if commentField.getText().count == 0 {
            commentField.showVisualFeedBack()
        }
        
        return presenter.selectedRating != 0 && commentField.getText().count != 0
    }
}

extension KarhooRatingView: RateButtonDelegate {
    
    func didTapRateButton(index: Int) {
        presenter.setRating(rating: index + 1)
        
        for button in rates {
            button.setSelected(false)
        }
        
        for i in 0...index {
            rates[i].setSelected(true)
        }
        
        delegate?.didRate(index + 1)
        presenter.didRateTrip()
    }
}
