//
//  TripMetaDataView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

protocol TripMetaDataViewDelegate: class {
    func didRateTrip(_ rate: Int)
    func didSelectFeedback()
}

final class KarhooTripMetaDataView: UIView, TripMetaDataView {
    
    private var stackContainer: UIStackView!
    private var statusMetadata: MetaDataView!
    private var priceMetadata: MetaDataView!
    private var flightMetadata: MetaDataView!
    private var tripIDMetadata: MetaDataView!
    private var ratingView: KarhooRatingView!
    private var ratingViewContainer: UIView!
    private var cancellationInfo: UILabel!
    private var cancellationInfoContainer: UIView!
    private var extraFeedbackView: FeedbackButtonView!

    private var presenter: TripMetaDataPresenter?
    weak var delegate: TripMetaDataViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    private func setUpView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "tripMetadata_view"
        
        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .vertical
        addSubview(stackContainer)
        
        _ = [stackContainer.topAnchor.constraint(equalTo: self.topAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             stackContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        statusMetadata = MetaDataView(title: UITexts.Generic.status,
                                      accessibilityIdentifier: "status_metadata")
        stackContainer.addArrangedSubview(statusMetadata)
        
        priceMetadata = MetaDataView(title: UITexts.Bookings.quote,
                                     accessibilityIdentifier: "quote_metadata")
        priceMetadata.actionButton.addTarget(self, action: #selector(baseFarePressed), for: .touchUpInside)
        stackContainer.addArrangedSubview(priceMetadata)
        
        flightMetadata = MetaDataView(title: UITexts.Airport.flightNumber,
                                      accessibilityIdentifier: "flight_metadata")
        stackContainer.addArrangedSubview(flightMetadata)
        
        tripIDMetadata = MetaDataView(title: "Karhoo ID",
                                      accessibilityIdentifier: "tripID_metadata")
        tripIDMetadata.isBottomLineHidden(true)
        stackContainer.addArrangedSubview(tripIDMetadata)
        
        ratingViewContainer = builRatingContainerView()
        stackContainer.addArrangedSubview(ratingViewContainer)

        cancellationInfoContainer = buildCancellationInfoView()
        stackContainer.addArrangedSubview(cancellationInfoContainer)
        
        extraFeedbackView = FeedbackButtonView()
        stackContainer.addArrangedSubview(extraFeedbackView)
    }
    
    private func builRatingContainerView() -> UIView {
        let view = UIView()
        view.accessibilityIdentifier = "raiting_container_view"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let topSeparatorLine = LineView(color: .lightGray,
                                        accessibilityIdentifier: "rating_view_container_top_separator")
        view.addSubview(topSeparatorLine)
        _ = [topSeparatorLine.topAnchor.constraint(equalTo: view.topAnchor),
             topSeparatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             topSeparatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             topSeparatorLine.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }
        
        ratingView = KarhooRatingView()
        view.addSubview(ratingView)
        _ = [ratingView.topAnchor.constraint(equalTo: topSeparatorLine.bottomAnchor),
             ratingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             ratingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             ratingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        
        return view
    }

    private func buildCancellationInfoView() -> UIView {
        let cancellationInfoContainer = UIView()
        cancellationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = "cancellationInfo_label"
        cancellationInfo.font = KarhooUI.fonts.captionRegular()
        cancellationInfo.textColor = KarhooUI.colors.brightGreen
        cancellationInfo.numberOfLines = 0

        cancellationInfoContainer.addSubview(cancellationInfo)
        cancellationInfo.anchor(top: cancellationInfoContainer.topAnchor,
                                leading: cancellationInfoContainer.leadingAnchor,
                                bottom: cancellationInfoContainer.bottomAnchor,
                                trailing: cancellationInfoContainer.trailingAnchor,
                                paddingTop: 10,
                                paddingLeft: 10,
                                paddingBottom: 10,
                                paddingRight: 10)
        return cancellationInfoContainer
    }

    func set(viewModel: TripMetaDataViewModel,
             presenter: TripMetaDataPresenter) {
    
        self.presenter = presenter
        
        priceMetadata.isActionButtonEnabled(!viewModel.baseFareHidden)
        priceMetadata.isBaseFareIconHidden(viewModel.baseFareHidden)
        priceMetadata.setValue(viewModel.price)
        
        tripIDMetadata.setValue(viewModel.displayId)
        
        statusMetadata.setValue(viewModel.status)
        statusMetadata.setStatusIcon(UIImage.uisdkImage(viewModel.statusIconName))
        statusMetadata.setStatusIconTintColor(viewModel.statusColor)
        
        statusMetadata.setValueColor(viewModel.statusColor)
        
        flightMetadata.setValue(viewModel.flightNumber)
        flightMetadata.isHidden = viewModel.flightNumber.isEmpty
        
        ratingViewContainer.isHidden = !viewModel.showRateTrip
        
        ratingView.delegate = self

        cancellationInfo.text = viewModel.freeCancellationMessage
        cancellationInfoContainer.isHidden = viewModel.freeCancellationMessage == nil
        
        extraFeedbackView.actions = self
        
        extraFeedbackView.isHidden = true
    }
    
    @objc
    private func baseFarePressed() {
        presenter?.baseFareExplanationPressed()
    }

    func hideRatingOptions() {
        ratingView.hideStars()
        ratingView.showConfirmation(UITexts.TripRating.thankYouConfirmation)
        extraFeedbackView.isHidden = true
    }
}

extension KarhooTripMetaDataView: RatingViewDelegate {
    
    func didRate(_ rate: Int) {
        extraFeedbackView.configure()
        delegate?.didRateTrip(rate)
    }
}

extension KarhooTripMetaDataView: FeedbackButtonActions {

    func didSelectFeedbackButton() {
        delegate?.didSelectFeedback()
    }
}
