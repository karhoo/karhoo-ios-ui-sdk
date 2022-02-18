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
    private var cancellationInfo: UILabel!
    private var cancellationInfoContainer: UIView!

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

        cancellationInfoContainer = buildCancellationInfoView()
        stackContainer.addArrangedSubview(cancellationInfoContainer)
    }

    private func buildCancellationInfoView() -> UIView {
        let cancellationInfoContainer = UIView()
        cancellationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = "cancellationInfo_label"
        cancellationInfo.font = KarhooUI.fonts.captionRegular()
        cancellationInfo.textColor = KarhooUI.colors.text
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

        cancellationInfo.text = viewModel.freeCancellationMessage
        cancellationInfoContainer.isHidden = viewModel.freeCancellationMessage == nil
    }
    
    @objc
    private func baseFarePressed() {
        presenter?.baseFareExplanationPressed()
    }

    func hideRatingOptions() {
    }
}

extension KarhooTripMetaDataView: RatingViewDelegate {
    
    func didRate(_ rate: Int) {
        delegate?.didRateTrip(rate)
    }
}

extension KarhooTripMetaDataView: FeedbackButtonActions {

    func didSelectFeedbackButton() {
        delegate?.didSelectFeedback()
    }
}
