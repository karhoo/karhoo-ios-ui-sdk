//
//  KarhooFeedbackView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class KarhooTripFeedbackViewController: UIViewController, TripFeedbackView {
    
    private var stackContainer: BaseStackView!
    private var presenter: TripFeedbackPresenter
    
    let rateType: [RatingType] = [.app, .pob, .pre_pob, .quote]
    
    init(presenter: TripFeedbackPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
        view.backgroundColor = .white
        title = UITexts.SideMenu.feedback
        
        stackContainer = BaseStackView()
        view.addSubview(stackContainer)
        
        _ = [stackContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
             stackContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
             stackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }
        
        fillView()
    }

    final class KarhooTripFeedbackScreenBuilder: TripFeedbackScreenBuilder {

        func buildFeedbackScreen(tripId: String,
                                 callback: @escaping ScreenResultCallback<Void>) -> Screen {
            let presenter = KarhooTripFeedbackPresenter(tripId: tripId, callback: callback)
            let view = KarhooTripFeedbackViewController(presenter: presenter)
            presenter.set(view: view)
            return view
        }
    }
}

extension KarhooTripFeedbackViewController {
    
    private func fillView() {
        for i in 0..<rateType.count {
            let presenter = KarhooRatingPresenter(ratingType: rateType[i])
            let view = KarhooRatingView(presenter: presenter,
                                        showSeparatorLine: false,
                                        showCommentField: true,
                                        isValidationEnabled: true)
            view.accessibilityIdentifier = "ratingView_\(i)"
            view.tag = i
            stackContainer.addViewToStack(view: view)
        }

        let buttonFooter = UIView(frame: .zero)
        buttonFooter.accessibilityIdentifier = "submit_Button_footer_view"
        
        let submitButton = UIButton(type: .custom)
        submitButton.accessibilityIdentifier = "submit_button"
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle(UITexts.Generic.submit, for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .black
        submitButton.layer.cornerRadius = 40.0 / 2
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        buttonFooter.addSubview(submitButton)
        
        _ = [submitButton.topAnchor.constraint(equalTo: buttonFooter.topAnchor, constant: 10.0),
             submitButton.bottomAnchor.constraint(equalTo: buttonFooter.bottomAnchor, constant: -10.0),
             submitButton.leadingAnchor.constraint(equalTo: buttonFooter.leadingAnchor),
             submitButton.trailingAnchor.constraint(equalTo: buttonFooter.trailingAnchor),
             submitButton.widthAnchor.constraint(equalToConstant: 150.0),
             submitButton.heightAnchor.constraint(equalToConstant: 40.0)].map { $0.isActive = true}
        
        stackContainer.addViewToStack(view: buttonFooter)
        
        // TripId label
        let tripIdContainer = UIView(frame: .zero)
        tripIdContainer.accessibilityIdentifier = "triId_container_view"
        
        let tripIdLabel = UILabel(frame: .zero)
        tripIdLabel.accessibilityIdentifier = "tripId_Label"
        tripIdLabel.translatesAutoresizingMaskIntoConstraints = false
        tripIdLabel.numberOfLines = 0
        tripIdLabel.text = "Trip id: \n" + presenter.getTripId()
        tripIdLabel.textAlignment = .center
        tripIdLabel.font = KarhooUI.fonts.captionRegular()
        tripIdLabel.textColor = KarhooUI.colors.primary
        
        tripIdContainer.addSubview(tripIdLabel)
        
        _ = [tripIdLabel.topAnchor.constraint(equalTo: tripIdContainer.topAnchor, constant: 10.0),
             tripIdLabel.bottomAnchor.constraint(equalTo: tripIdContainer.bottomAnchor, constant: -10.0),
             tripIdLabel.leadingAnchor.constraint(equalTo: tripIdContainer.leadingAnchor, constant: 10.0),
             tripIdLabel.trailingAnchor.constraint(equalTo: tripIdContainer.trailingAnchor,
                                                   constant: -10.0)].map { $0.isActive = true}
        
        stackContainer.addViewToStack(view: tripIdContainer)
    }
    
    @objc
    private func submitTapped() {
        var validationArray: [KarhooRatingView] = []

        for view in stackContainer.stackSubViews() {
            if let ratingView = view as? KarhooRatingView {
                if ratingView.isValid() {
                    presenter.addFeedback(feedback: ratingView.getFeedBack())
                } else {
                    validationArray.append(ratingView)
                }
            }
        }

        validationArray.isEmpty ? presenter.submitButtonPressed() : presenter.clearFeedbackData()
    }
}
