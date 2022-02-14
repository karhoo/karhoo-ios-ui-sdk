//
//  RideCell.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class RideCell: UITableViewCell {
    
    var containerView: UIView!
    var containerStackView: UIStackView!
    var tripDetailsView: TripDetailsView!
    var separatorLine: LineView!
    // Footer
    var tripStatus: TripStatusView!
    var cancellationInfo: UILabel!
    var cancellationInfoContainer: UIView!
    var stackButtonView: KarhooStackButtonView!
    
    private var trip: TripInfo?
    private var presenter: RideCellStackButtonPresenter?
    private var trackTripCallback: ((TripInfo) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addContainerOuterShadow()
    }
    
    private func setUpView() {
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        containerView = buildContainerView()
        containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(containerStackView)
        containerStackView.anchor(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: containerView.trailingAnchor)
        
        tripDetailsView = TripDetailsView()
        containerStackView.addArrangedSubview(tripDetailsView)

        cancellationInfoContainer = UIView()
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
        containerStackView.addArrangedSubview(cancellationInfoContainer)
        
        separatorLine = LineView(color: .lightGray, accessibilityIdentifier: "separator_view")
        containerStackView.addArrangedSubview(separatorLine)
        
        tripStatus = TripStatusView()
        containerStackView.addArrangedSubview(tripStatus)

        stackButtonView = KarhooStackButtonView()
        containerStackView.addArrangedSubview(stackButtonView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        tripDetailsView.prepareForReuse()
        tripStatus.setStatusTitle("")
        tripStatus.setStatusIcon(nil)
        tripStatus.setPrice("")
        presenter = nil
        trip = nil
        trackTripCallback = nil
        containerView.layer.shadowPath = nil
    }

    func set(viewModel: RideCellViewModel,
             tripDetailsViewModel: TripDetailsViewModel,
             accessibilityIdentifier: String,
             trackTripCallback: @escaping (TripInfo) -> Void) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.trackTripCallback = trackTripCallback
        tripStatus.setPrice(viewModel.price)
        tripStatus.setStatusTitle(viewModel.tripState)
        tripStatus.setStatusTitleColor(viewModel.tripStateColor)
        tripStatus.setStatusIcon(UIImage.uisdkImage(viewModel.tripStateIconName))
        tripStatus.setStatusIconTintColor(viewModel.tripStateColor)
        tripDetailsView.set(viewModel: tripDetailsViewModel)
        cancellationInfo.text = viewModel.freeCancellationMessage
        cancellationInfoContainer.isHidden = viewModel.freeCancellationMessage == nil
        
        if viewModel.showActionButtons == true {
            stackButtonView.isHidden = false
            presenter = RideCellStackButtonPresenter(stackButton: stackButtonView,
                                                     trip: viewModel.trip,
                                                     rideCellStackButtonActions: self)
            hideStatus()
            return
        }

        showStatus()
        stackButtonView.isHidden = true
        
        containerView.layer.shadowPath = nil
    }

    private func showStatus() {
        tripStatus.isHidden = false
        separatorLine.isHidden = false
    }

    private func hideStatus() {
        tripStatus.isHidden = true
        separatorLine.isHidden = true
    }
}

extension RideCell: RideCellStackButtonActions {

    func track(_ trip: TripInfo) {
        trackTripCallback?(trip)
    }
}

// MARK: Builders
private extension RideCell {
    
    func addContainerOuterShadow() {
        if containerView.layer.shadowPath == nil {
            containerView.addOuterShadow()
        }
    }
    
    func buildContainerView() -> UIView {
        let view = UIView()
        view.accessibilityIdentifier = "container_view"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(view)
        _ = [view.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
             view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
             view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
             view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0)].map { $0.isActive = true }
        
        return view
    }
}
